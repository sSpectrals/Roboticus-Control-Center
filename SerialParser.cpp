#include "SerialParser.h"

SerialParser::SerialParser(QObject *parent) : QObject(parent) {}

Q_INVOKABLE bool SerialParser::connectToPort(QString port, int baudRate) {

  if (m_serial.isOpen()) {
    m_serial.close();
  }

  m_serial.setPortName(port);
  m_serial.setBaudRate(baudRate);
  configureDefaultSettings();

  bool success = m_serial.open(QIODevice::ReadWrite);

  if (success) {
    emit connectionChanged();
    emit portChanged();
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

  QList<int> validRates = {1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200};
  bool wasOpen = m_serial.isOpen();

  if (wasOpen) {
    QString currentPort = m_serial.portName();
    m_serial.close();

    m_serial.setBaudRate(baudRate);
    bool success = m_serial.open(QIODevice::ReadWrite);

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

    bool success = m_serial.open(QIODevice::ReadWrite);
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

  // Look for complete JSON object (matching braces)
  int braceCount = 0;
  int startIdx = -1;
  int endIdx = -1;

  for (int i = 0; i < m_buffer.size(); ++i) {
    if (m_buffer[i] == '{') {
      if (startIdx == -1)
        startIdx = i;
      braceCount++;
    } else if (m_buffer[i] == '}') {
      braceCount--;
      if (braceCount == 0 && startIdx != -1) {
        endIdx = i;
        break;
      }
    }
  }

  if (startIdx != -1 && endIdx != -1) {
    QByteArray jsonData = m_buffer.mid(startIdx, endIdx - startIdx + 1);
    m_buffer.remove(0, endIdx + 1);

    emit dataReceived(jsonData);
    processJsonData(jsonData);
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
    QString name = sensorObj["name"].toString();
    double threshold = sensorObj["threshold"].toDouble();
    QString op = sensorObj["operator"].toString(">=");
    double input = sensorObj["input"].toDouble();

    QJsonObject location = sensorObj["location"].toObject();
    double x = location["x"].toDouble();
    double y = location["y"].toDouble();

    int idx = m_sensorModel->getIndexByName(name);

    if (idx >= 0) {
      // Update existing sensor
      QModelIndex modelIdx = m_sensorModel->index(idx);
      m_sensorModel->setData(modelIdx, input, SensorModel::InputRole);
      m_sensorModel->setData(modelIdx, threshold, SensorModel::ThresholdRole);
      m_sensorModel->setData(modelIdx, op, SensorModel::OperatorRole);
      m_sensorModel->setData(modelIdx, x, SensorModel::XRole);
      m_sensorModel->setData(modelIdx, y, SensorModel::YRole);
    } else {
      // Add new sensor
      Sensor newSensor =
          m_sensorModel->addSensor(name, input, threshold, op, x, y);
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
