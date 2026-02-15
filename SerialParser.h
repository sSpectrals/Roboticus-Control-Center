#ifndef SERIALPARSER_H
#define SERIALPARSER_H

#include <QDebug>
#include <QObject>
#include <QQmlEngine>
#include <QSerialPort>
#include <QSerialPortInfo>

class SerialParser : public QObject {
  Q_OBJECT
  Q_PROPERTY(bool isConnected READ isConnected NOTIFY connectionChanged)
  Q_PROPERTY(QString currentPort READ currentPort NOTIFY portChanged)
public:
  explicit SerialParser(QObject *parent = nullptr);

  Q_INVOKABLE bool connectToPort(QString port, int baudRate);

  Q_INVOKABLE bool setBaudRate(int baudRate);
  Q_INVOKABLE bool setComPort(QString port);
  Q_INVOKABLE void disconnectPort();

  Q_INVOKABLE QStringList availablePorts();

  bool isConnected() const { return m_serial.isOpen(); }
  QString currentPort() const { return m_serial.portName(); }

  void readData();

signals:
  void connectionChanged();
  void portChanged();
  void dataReceived(QByteArray data);

private:
  QSerialPort m_serial;
      void configureDefaultSettings();
};

#endif // SERIALPARSER_H
