#include "negi.h"
#include "ui_negi.h"
#include <QFileDialog>
#include <QMessageBox>
#include <QProcess>
#include <QFile>

Negi::Negi(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::Negi)
{
    ui->setupUi(this);
}

Negi::~Negi()
{
    delete ui;
}

const QString SCRIPT_HOME_DIR = QDir::homePath() + QDir::separator() + QString::fromStdString("negiScripts") + QDir::separator();


void Negi::on_buttonBrowse_clicked(){
    QString pathToFile = QFileDialog::getOpenFileName(this, "Select file", QDir::homePath());

    // return if the user doesn't select a file
    if(pathToFile.isNull() || pathToFile.isEmpty())     return;
    // TODO: error handling
    ui->labelFilePath->setText(pathToFile);
}

void Negi::on_buttonExecute_clicked(){
    const QString qSelect = QString::fromStdString("Select");
    const QString qKanji  = QString::fromStdString("Kanji");
    const QString qGoi    = QString::fromStdString("Goi");
    QString qCurrent = ui->comboBox->currentText();

    // if the user hasn't selected a file , return;
    if(QString::compare(ui->labelFilePath->text(), QString::fromStdString("Select a file")) == 0){
        QString title = QString::fromStdString("Warning");
        QString message = QString::fromStdString("You must select a file first.");
        QMessageBox::critical(this, title, message);
        return;
    }

    // if the user hasn't selected the file type, return;
    if(QString::compare(qCurrent, qSelect) == 0){
        QString title = QString::fromStdString("Warning");
        QString message = QString::fromStdString("You must select the file type");
        QMessageBox::critical(this, title, message);
        return;
    }

    if(QString::compare(qCurrent, qGoi) == 0){
        runGoiScript();
        return;
    }

    if(QString::compare(qCurrent, qKanji) == 0){
        runKanjiScript();
        return;
    }

}

void Negi::runGoiScript(){
    ui->textBrowser->clear();
    QProcess *p = new QProcess( this );
    connect(p, SIGNAL(readyReadStandardOutput()), this, SLOT(readStdOut()));
    connect(p, SIGNAL(finished(int)), this, SLOT(copyPasta()));

    if (p){
      p->setEnvironment( QProcess::systemEnvironment() );
      p->setProcessChannelMode( QProcess::MergedChannels );
      p->setWorkingDirectory(SCRIPT_HOME_DIR);
      std::string cmd = "perl goi.pl " + ui->labelFilePath->text().toStdString();
      p->start(cmd.c_str());
      p->waitForStarted();
    }
}

void Negi::runKanjiScript(){
    ui->textBrowser->clear();
    QProcess *p = new QProcess( this );
    connect(p, SIGNAL(readyReadStandardOutput()), this, SLOT(readStdOut()));
    connect(p, SIGNAL(finished(int)), this, SLOT(copyPasta()));

    if (p){
      p->setEnvironment( QProcess::systemEnvironment() );
      p->setProcessChannelMode( QProcess::MergedChannels );
      p->setWorkingDirectory(SCRIPT_HOME_DIR);
      std::string cmd = "perl kanji.pl " + ui->labelFilePath->text().toStdString();
      p->start(cmd.c_str());
      p->waitForStarted();
    }
}

void Negi::copyPasta(){
    QString output = SCRIPT_HOME_DIR + QDir::separator() + QString::fromStdString("anki.txt");
    QString target = QDir::homePath() + QDir::separator() + "Desktop" + QDir::separator() + "anki.txt";
    if (QFile::exists(target)){
        QFile::remove(target);
    }
    ui->textBrowser->append("Bitenzi");
    QFile::copy(output, target);
}

void Negi::readStdOut(){
    QProcess *p = dynamic_cast<QProcess *>( sender() );
    if (p)
      ui->textBrowser->insertPlainText( p->readAllStandardOutput() );
}

