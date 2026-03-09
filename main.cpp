#include <QDebug>
#include <QFile>
#include <QGuiApplication >
#include <QIcon>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[]) {
  qputenv("QT_QUICK_CONTROLS_STYLE", "Material");
  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;

  app.setWindowIcon(QIcon(":/qt/qml/com/Roboticus/ControlCenter/qml/assets/"
                          "icons/Roboticus_icon.ico"));

  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
      []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
  engine.loadFromModule("com.Roboticus.ControlCenter", "Main");

  return app.exec();
}
