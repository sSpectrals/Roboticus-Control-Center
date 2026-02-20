#include "SerialParser.h"

SerialParser::SerialParser(QObject *parent) : QObject(parent) {
  refreshPorts();

  // Setup timer to poll for port changes every 1 second
  connect(&m_portRefreshTimer, &QTimer::timeout, this,
          &SerialParser::refreshPorts);
  m_portRefreshTimer.start(1000);
}

Q_INVOKABLE bool SerialParser::connectToPort() {

  if (m_serial.isOpen()) {
    m_serial.close();
  }

  if (m_serial.portName().isEmpty() || m_serial.baudRate() <= 0) {
    qDebug() << "failed to set port or baudrate";
    return false;
  }

  configureDefaultSettings();

  bool success = m_serial.open(QIODevice::ReadOnly);

  if (success) {
    m_serial.setDataTerminalReady(true);

    // Clear any startup garbage (null bytes from Arduino reset)
    m_buffer.clear();
    m_serial.clear();

    connect(&m_serial, &QSerialPort::readyRead, this, &SerialParser::readData,
            Qt::UniqueConnection);

    qDebug() << "successfully connected";
    qDebug() << "Port:" << m_serial.portName()
             << "Baud:" << m_serial.baudRate();
    emit connectionChanged();
    emit portChanged();
  } else {
    qDebug() << "Error:" << m_serial.error() << m_serial.errorString()
             << "\nCheck if you have a serial monitor open somewhere else";
    qDebug() << "Port:" << m_serial.portName()
             << "Baud:" << m_serial.baudRate();
  }

  return success;
}

void SerialParser::configureDefaultSettings() {
  m_serial.setParity(QSerialPort::NoParity);
  m_serial.setDataBits(QSerialPort::Data8);
  m_serial.setStopBits(QSerialPort::OneStop);
  m_serial.setFlowControl(QSerialPort::NoFlowControl);
}

bool SerialParser::setBaudRate(int baudRate) {

  QList<int> validRates = {38400, 57600, 115200, 230400, 460800, 921600};
  bool wasOpen = m_serial.isOpen();

  if (wasOpen) {
    QString currentPort = m_serial.portName();
    m_serial.close();

    m_serial.setBaudRate(baudRate);
    bool success = connectToPort();

    if (success) {
      emit connectionChanged();
    }

    return success;
  } else {
    return m_serial.setBaudRate(baudRate);
  }
}

bool SerialParser::setComPort(QString port) {

  bool wasOpen = m_serial.isOpen();

  if (wasOpen) {
    m_serial.close();

    m_serial.setPortName(port);

    bool success = connectToPort();
    if (success) {
      emit connectionChanged();
      emit portChanged();
    }

    return success;
  } else {

    m_serial.setPortName(port);
    return true;
  }
}

void SerialParser::disconnectPort() {
  if (m_serial.isOpen()) {
    m_serial.close();
    emit connectionChanged();
    qDebug() << "Disconnected from" << m_serial.portName();
  }
}

QStringList SerialParser::availablePorts() {
  QStringList ports;
  const auto serialPorts = QSerialPortInfo::availablePorts();
  for (const QSerialPortInfo &info : serialPorts) {
    ports.append(info.portName());
  }
  return ports;
}

void SerialParser::refreshPorts() {
  QStringList newPorts = availablePorts();
  if (newPorts != m_availablePorts) {
    m_availablePorts = newPorts;
    emit availablePortsChanged();
  }
}

void SerialParser::setModels(SensorModel *sensorModel,
                             VectorModel *vectorModel) {
  m_sensorModel = sensorModel;
  m_vectorModel = vectorModel;
}

void SerialParser::readData() {

  if (!m_serial.isOpen()) {
    qDebug() << "Could not read serial data";
    return;
  }

  m_buffer.append(m_serial.readAll());

  // Prevent buffer from growing too large (e.g., malformed data)
  constexpr int maxBufferSize = 65536;
  if (m_buffer.size() > maxBufferSize) {
    qDebug() << "Buffer overflow, keeping last 4KB";
    m_buffer = m_buffer.right(4096);
  }

  // Process all complete lines (newline-delimited JSON)
  int newlineIdx;
  while ((newlineIdx = m_buffer.indexOf('\n')) != -1) {
    QByteArray line = m_buffer.left(newlineIdx).trimmed();
    m_buffer.remove(0, newlineIdx + 1);

    // Skip empty lines or non-JSON data
    if (line.isEmpty()) {
      continue;
    }

    // Find start of JSON (skip any leading garbage)
    int jsonStart = line.indexOf('{');
    if (jsonStart > 0) {
      line = line.mid(jsonStart);
    }
    if (!line.startsWith('{') || !line.endsWith('}')) {
      qDebug() << "Discarded malformed line:" << line.left(100);
      continue;
    }

    // qDebug() << "Received JSON:" << line.size() << "bytes";

    emit dataReceived(line);
    processJsonData(line);
  }
}

void SerialParser::processJsonData(const QByteArray &jsonData) {
  QJsonParseError parseError;
  QJsonDocument doc = QJsonDocument::fromJson(jsonData, &parseError);

  if (parseError.error != QJsonParseError::NoError) {
    qDebug() << "JSON parse error:" << parseError.errorString();
    return;
  }

  QJsonObject frame = doc.object();

  qint64 timestamp = frame["timestamp"].toInteger();
  Q_UNUSED(timestamp) // Available for future replay functionality

  if (frame.contains("sensors")) {
    updateSensorsFromJson(frame["sensors"].toArray());
  }

  if (frame.contains("vectors")) {
    updateVectorsFromJson(frame["vectors"].toArray());
  }
}

void SerialParser::updateSensorsFromJson(const QJsonArray &sensors) {
  if (!m_sensorModel)
    return;

  for (const QJsonValue &sensorVal : sensors) {
    QJsonObject sensorObj = sensorVal.toObject();
    QString name = sensorObj["name"].toString("no name set");

    QJsonValue thresholdVal = sensorObj["threshold"];
    double threshold = thresholdVal.isBool()
                           ? (thresholdVal.toBool() ? 1.0 : 0.0)
                           : thresholdVal.toDouble(-1);

    QJsonValue inputVal = sensorObj["input"];
    double input = inputVal.isBool() ? (inputVal.toBool() ? 1.0 : 0.0)
                                     : inputVal.toDouble(-1);

    bool isTriggered = sensorObj["isTriggered"].toBool(false);

    QJsonObject location = sensorObj["location"].toObject();
    double x = location["x"].toDouble(0.0);
    double y = location["y"].toDouble(0.0);

    int idx = m_sensorModel->getIndexByName(name);

    if (idx >= 0) {
      // Update existing sensor
      QModelIndex modelIdx = m_sensorModel->index(idx);
      m_sensorModel->setData(modelIdx, input, SensorModel::InputRole);
      m_sensorModel->setData(modelIdx, threshold, SensorModel::ThresholdRole);
      m_sensorModel->setData(modelIdx, isTriggered, SensorModel::TriggerRole);
      m_sensorModel->setData(modelIdx, x, SensorModel::XRole);
      m_sensorModel->setData(modelIdx, y, SensorModel::YRole);
    } else {
      // Add new sensor
      Sensor newSensor =
          m_sensorModel->addSensor(name, input, threshold, isTriggered, x, y);
    }
  }
}

void SerialParser::updateVectorsFromJson(const QJsonArray &vectors) {
  if (!m_vectorModel)
    return;

  for (const QJsonValue &vectorVal : vectors) {
    QJsonObject vectorObj = vectorVal.toObject();
    QString name = vectorObj["name"].toString();
    double rotation = vectorObj["rotation"].toDouble();
    QString color = vectorObj["color"].toString("#ffffff");

    QJsonObject location = vectorObj["location"].toObject();
    double x = location["x"].toDouble();
    double y = location["y"].toDouble();

    int idx = m_vectorModel->getIndexByName(name);

    if (idx >= 0) {
      // Update existing vector
      QModelIndex modelIdx = m_vectorModel->index(idx);
      m_vectorModel->setData(modelIdx, rotation, VectorModel::RotationRole);
      m_vectorModel->setData(modelIdx, color, VectorModel::ColorRole);
      m_vectorModel->setData(modelIdx, x, VectorModel::XRole);
      m_vectorModel->setData(modelIdx, y, VectorModel::YRole);
    } else {
      // Add new vector
      m_vectorModel->addVector(name, rotation, 1.0, QColor(color), x, y);
    }
  }
}
