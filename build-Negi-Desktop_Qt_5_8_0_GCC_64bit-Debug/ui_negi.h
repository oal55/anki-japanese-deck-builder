/********************************************************************************
** Form generated from reading UI file 'negi.ui'
**
** Created by: Qt User Interface Compiler version 5.8.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_NEGI_H
#define UI_NEGI_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QTextBrowser>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_Negi
{
public:
    QWidget *centralWidget;
    QLabel *labelWelcome;
    QLabel *labelFilePath;
    QPushButton *buttonBrowse;
    QComboBox *comboBox;
    QPushButton *buttonExecute;
    QTextBrowser *textBrowser;
    QLabel *label;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *Negi)
    {
        if (Negi->objectName().isEmpty())
            Negi->setObjectName(QStringLiteral("Negi"));
        Negi->resize(500, 440);
        Negi->setStyleSheet(QLatin1String("\n"
"QMainWindow{\n"
"        background-color: #222930;\n"
"}\n"
"\n"
"QMessageBox{\n"
"        background-color: #222930;\n"
"}\n"
"QLabel{\n"
"        color: #e9e9e9;\n"
"}\n"
"\n"
"QPushButton{\n"
"    font-weight: bold;\n"
"        color: #ffffff;\n"
"        min-height:24px;\n"
"        min-width:60px;\n"
"        border-radius: 10px;\n"
"        background-color: #4eb1ba;\n"
"        border: none;\n"
"        text-align: center;\n"
"}\n"
"\n"
"\n"
"QPushButton#buttonExecute{\n"
"        font-size: 12pt;\n"
"        border-radius: 20px;\n"
"}\n"
"\n"
"QPushButton:pressed {\n"
"        color: #222930;\n"
"    background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,\n"
"                                      stop: 0 #dadbde, stop: 1 #f6f7fa);\n"
"}"));
        centralWidget = new QWidget(Negi);
        centralWidget->setObjectName(QStringLiteral("centralWidget"));
        labelWelcome = new QLabel(centralWidget);
        labelWelcome->setObjectName(QStringLiteral("labelWelcome"));
        labelWelcome->setGeometry(QRect(30, 10, 171, 31));
        QFont font;
        font.setFamily(QString::fromUtf8("\346\270\270\346\230\216\346\234\235"));
        font.setPointSize(18);
        font.setBold(true);
        font.setWeight(75);
        labelWelcome->setFont(font);
        labelFilePath = new QLabel(centralWidget);
        labelFilePath->setObjectName(QStringLiteral("labelFilePath"));
        labelFilePath->setGeometry(QRect(30, 50, 271, 31));
        buttonBrowse = new QPushButton(centralWidget);
        buttonBrowse->setObjectName(QStringLiteral("buttonBrowse"));
        buttonBrowse->setGeometry(QRect(330, 54, 90, 24));
        comboBox = new QComboBox(centralWidget);
        comboBox->setObjectName(QStringLiteral("comboBox"));
        comboBox->setEnabled(true);
        comboBox->setGeometry(QRect(330, 90, 131, 22));
        buttonExecute = new QPushButton(centralWidget);
        buttonExecute->setObjectName(QStringLiteral("buttonExecute"));
        buttonExecute->setGeometry(QRect(30, 147, 440, 41));
        textBrowser = new QTextBrowser(centralWidget);
        textBrowser->setObjectName(QStringLiteral("textBrowser"));
        textBrowser->setGeometry(QRect(25, 210, 450, 200));
        label = new QLabel(centralWidget);
        label->setObjectName(QStringLiteral("label"));
        label->setGeometry(QRect(30, 90, 200, 30));
        Negi->setCentralWidget(centralWidget);
        statusBar = new QStatusBar(Negi);
        statusBar->setObjectName(QStringLiteral("statusBar"));
        Negi->setStatusBar(statusBar);

        retranslateUi(Negi);

        QMetaObject::connectSlotsByName(Negi);
    } // setupUi

    void retranslateUi(QMainWindow *Negi)
    {
        Negi->setWindowTitle(QApplication::translate("Negi", "Negi", Q_NULLPTR));
        labelWelcome->setText(QApplication::translate("Negi", "\343\202\210\357\275\236", Q_NULLPTR));
        labelFilePath->setText(QApplication::translate("Negi", "Select a file", Q_NULLPTR));
        buttonBrowse->setText(QApplication::translate("Negi", "Browse", Q_NULLPTR));
        comboBox->clear();
        comboBox->insertItems(0, QStringList()
         << QApplication::translate("Negi", "Select", Q_NULLPTR)
         << QApplication::translate("Negi", "Goi", Q_NULLPTR)
         << QApplication::translate("Negi", "Kanji", Q_NULLPTR)
        );
        buttonExecute->setText(QApplication::translate("Negi", "Execute", Q_NULLPTR));
        label->setText(QApplication::translate("Negi", "Select file type", Q_NULLPTR));
    } // retranslateUi

};

namespace Ui {
    class Negi: public Ui_Negi {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_NEGI_H
