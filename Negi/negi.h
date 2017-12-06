#ifndef NEGI_H
#define NEGI_H

#include <QMainWindow>

namespace Ui {
class Negi;
}

class Negi : public QMainWindow
{
    Q_OBJECT

public:
    explicit Negi(QWidget *parent = 0);
    ~Negi();

private slots:
    void on_buttonBrowse_clicked();
    void on_buttonExecute_clicked();
    void readStdOut();
    void copyPasta();

private:
    Ui::Negi *ui;
    void runGoiScript();
    void runKanjiScript();
};

#endif // NEGI_H
