#include "myapplication.h"

/*
 * Main file, description of the application
 * The application HMI is done in QML
 * main.qml describes the application
 *
 */

int main(int argc, char *argv[])
{
    // initialisation of the application where HMI is defined in QML
    MyApplication c_application(argc, argv);

    // load the qml file describing the application
    c_application.loadMainQml(QUrl("qrc:/main.qml"));

    return c_application.exec();
}

