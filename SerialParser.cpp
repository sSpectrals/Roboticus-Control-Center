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

void SerialParser::readData() {

  if (!m_serial.isOpen()) {
    qDebug() << "Could not read serial data";
    return;
  }

  QByteArray data = m_serial.readAll();
  if (!data.isEmpty()) {
    qDebug() << "Received data:" << data;
    emit dataReceived(data);
  }
}
