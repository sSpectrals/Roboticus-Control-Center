cmake_minimum_required(VERSION 3.16)

project(Roboticus_control_center VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Graphs)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(appRoboticus_control_center
    main.cpp
    SensorModel.h
    SensorModel.cpp
)



qt_add_qml_module(appRoboticus_control_center
    URI com.Roboticus.ControlCenter
    QML_FILES
        Main.qml
        qml/components/SensorPanel.qml
        qml/components/SensorInfo.qml
        qml/components/AddItem.qml
        qml/components/SinglePointSeries.qml
        qml/components/VectorArrow.qml
    RESOURCES
        qml/assets/SVG/add.svg
        qml/assets/SVG/remove.svg
        qml/assets/SVG/arrow.svg
        qml/assets/SVG/trash.svg
    SOURCES
        # src/Models/sensor_model.cpp src/Models/sensor_model.h
        # src/Models/vector_model.cpp src/Models/vector_model.h
        # src/Controller/main_controller.cpp src/Controller/main_controller.h
        SensorModel.h
        SensorModel.cpp
        SOURCES SensorController.h SensorController.cpp
        SOURCES VectorModel.h VectorModel.cpp
        SOURCES VectorController.h VectorController.cpp
        SOURCES SensorModel.cpp VectorModel.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appRoboticus_control_center PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appRoboticus_control_center
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appRoboticus_control_center
    PRIVATE Qt6::Quick Qt6::Graphs
)

include(GNUInstallDirs)
install(TARGETS appRoboticus_control_center
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
