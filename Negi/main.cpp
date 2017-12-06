#include "negi.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    Negi w;
    w.show();

    return a.exec();
}
