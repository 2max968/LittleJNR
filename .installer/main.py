import typing
from PyQt5 import QtCore
from PyQt5.QtWidgets import *
from PyQt5.QtWidgets import QWidget
from PyQt5.QtGui import *
import page1_setLocation
import page0_intro
import page2_desktopEntry

class InstMainWindow(QWidget):
    def __init__(self) -> None:
        super().__init__()
        self.setMinimumSize(600, 400)
        self.setWindowTitle("Little Jnr installer")
        self.lo = QVBoxLayout()
        self.pages = []

        header = QWidget()
        headerH = QHBoxLayout()
        header.setLayout(headerH)
        ico = QLabel()
        ico.setPixmap(QPixmap("32.png"))
        headerH.addWidget(ico)
        headerH.addWidget(QLabel("Chroma"))
        headerH.addStretch(1)
        self.lo.addWidget(header)

        self.centralWidget = QWidget()
        self.central = QStackedLayout()
        self.centralWidget.setLayout(self.central)
        self.lo.addWidget(self.centralWidget)
        self.lo.addStretch(1)

        self.setLayout(self.lo)
        self.buttonbar = QGroupBox()
        self.lo.addWidget(self.buttonbar)

        self.btnNext = QPushButton("Next")
        self.btnPrev = QPushButton("Back")
        btnLayout = QHBoxLayout()
        self.buttonbar.setLayout(btnLayout)
        btnLayout.addStretch(1)
        btnLayout.addWidget(self.btnPrev)
        btnLayout.addWidget(self.btnNext)
        self.btnNext.clicked.connect(self.btnNextPressed)
        self.btnPrev.clicked.connect(self.btnPrevPressed)

        self.pageIntro = page0_intro.Page()
        self.central.addWidget(self.pageIntro)
        self.pages.append(self.pageIntro)
        self.pageFolder = page1_setLocation.Page()
        self.central.addWidget(self.pageFolder)
        self.pages.append(self.pageFolder)
        self.pageDesktop = page2_desktopEntry.Page()
        self.central.addWidget(self.pageDesktop)
        self.pages.append(self.pageDesktop)

        self.selectedPage = 0
        self.btnPrev.setEnabled(False)
    
    def btnNextPressed(self):
        if not self.pages[self.selectedPage].accept():
            return

        self.selectedPage += 1

        self.central.setCurrentIndex(self.selectedPage)
        self.btnPrev.setEnabled(self.selectedPage != 0)
        self.btnNext.setEnabled(self.selectedPage < self.central.count() - 1)

    def btnPrevPressed(self):
        self.selectedPage -= 1

        self.central.setCurrentIndex(self.selectedPage)
        self.btnPrev.setEnabled(self.selectedPage != 0)
        self.btnNext.setEnabled(self.selectedPage < self.central.count() - 1)
        

app = QApplication([])
wnd = InstMainWindow()
wnd.show()
app.exec()