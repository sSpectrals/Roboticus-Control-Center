#include "UDPConnection.h"

#include <QHostAddress>
#include <QNetworkDatagram>
#include <QUdpSocket>

UDPConnection::UDPConnection(QObject *parent) : QObject(parent) {}

bool UDPConnection::startListening(quint16 port) {
  if (m_listening && m_port == port) {
    return true;
  }

  if (m_listening) {
    stopListening();
  }

  if (!m_socket) {
    m_socket = new QUdpSocket(this);
  }

  const bool bound =
      m_socket->bind(QHostAddress::AnyIPv4, port,
                     QUdpSocket::ShareAddress | QUdpSocket::ReuseAddressHint);

  if (!bound) {
    m_errorString = m_socket->errorString();
    emit errorChanged();
    emit errorOccurred(m_errorString);
    return false;
  }

  connect(m_socket, &QUdpSocket::readyRead, this,
          &UDPConnection::readPendingDatagrams, Qt::UniqueConnection);

  const bool listeningChangedNeeded = !m_listening;
  const bool portChangedNeeded = m_port != port;
  const bool errorChangedNeeded = !m_errorString.isEmpty();

  m_port = port;
  m_listening = true;
  m_errorString.clear();

  if (portChangedNeeded) {
    emit portChanged();
  }
  if (listeningChangedNeeded) {
    emit listeningChanged();
  }
  if (errorChangedNeeded) {
    emit errorChanged();
  }

  return true;
}

void UDPConnection::stopListening() {
  const bool wasListening = m_listening;

  if (m_socket) {
    disconnect(m_socket, &QUdpSocket::readyRead, this,
               &UDPConnection::readPendingDatagrams);
    m_socket->close();
  }

  m_listening = false;

  if (wasListening) {
    emit listeningChanged();
  }
}

void UDPConnection::clearStatistics() {
  m_packetsReceived = 0;
  m_bytesReceived = 0;
  m_lastSenderAddress.clear();
  m_lastSenderPort = 0;

  emit statisticsChanged();
  emit lastSenderChanged();
}

void UDPConnection::readPendingDatagrams() {
  if (!m_socket) {
    return;
  }

  bool receivedAnyDatagram = false;

  while (m_socket->hasPendingDatagrams()) {
    const QNetworkDatagram datagram = m_socket->receiveDatagram();
    const QByteArray data = datagram.data();

    ++m_packetsReceived;
    m_bytesReceived += static_cast<quint64>(data.size());
    m_lastSenderAddress = datagram.senderAddress().toString();
    m_lastSenderPort = datagram.senderPort();

    receivedAnyDatagram = true;
    emit rawDataReceived(data);
  }

  if (receivedAnyDatagram) {
    emit statisticsChanged();
    emit lastSenderChanged();
  }
}
