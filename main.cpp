#include <QGuiApplication >
#include <QQmlApplicationEngine>
// #include "src/Controller/SensorModel.h"


int main(int argc, char *argv[])
{
    qputenv("QT_QUICK_CONTROLS_STYLE", "Material");
    QGuiApplication  app(argc, argv);

    QQmlApplicationEngine engine;


    // SensorModel *sensorModel = new SensorModel(&app);
    // qmlRegisterSingletonInstance("com.Roboticus.ControlCenter.models", 1, 0, "SensorModel", sensorModel);


    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("com.Roboticus.ControlCenter", "Main");

    return app.exec();
}
