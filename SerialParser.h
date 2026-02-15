#ifndef SERIALPARSER_H
#define SERIALPARSER_H

#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QObject>
#include <QQmlEngine>
#include <QSerialPort>
#include <QSerialPortInfo>

#include "SensorModel.h"
#include "VectorModel.h"

class SerialParser : public QObject {
  Q_OBJECT
  QML_ELEMENT

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

  Q_INVOKABLE void setModels(SensorModel *sensorModel, VectorModel *vectorModel);
  Q_INVOKABLE void readData();

signals:
  void connectionChanged();
  void portChanged();
  void dataReceived(QByteArray data);

private:
  QSerialPort m_serial;
  QByteArray m_buffer;
  SensorModel *m_sensorModel = nullptr;
  VectorModel *m_vectorModel = nullptr;

  void configureDefaultSettings();
  void processJsonData(const QByteArray &jsonData);
  void updateSensorsFromJson(const QJsonArray &sensors);
  void updateVectorsFromJson(const QJsonArray &vectors);
};

#endif // SERIALPARSER_H
