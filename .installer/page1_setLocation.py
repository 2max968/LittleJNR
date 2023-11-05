import typing
from PyQt5 import QtCore
from PyQt5.QtWidgets import *
from PyQt5.QtWidgets import QWidget
import os
import page

if os.name == "nt":
    FOLDERS = [
        ["Local user", "%APPDATA%\\LittleJnr"],
        ["All users", "%PROGRAMFILES%\\LittleJnr"]
    ]
elif os.name == "posix":
    FOLDERS = [
        ["Local user", "~/.local/share/LittleJnr"],
        ["All users", "/usr/share/LittleJnr"]
    ]

DESCRIPTION = "Select where to install the game."

class Page(page.Page):
    def __init__(self) -> None:
        super().__init__()
        self.SelectedFolder = ""

        self.lo = QVBoxLayout()
        self.setLayout(self.lo)

        self.lo.addWidget(QLabel(DESCRIPTION))

        self.rbs = []
        for i, folder in enumerate(FOLDERS):
            fdPath = os.path.expandvars(os.path.expanduser(folder[1]))
            rb = QRadioButton(f"{folder[0]} ({fdPath})")
            self.lo.addWidget(rb)
            if i == 0:
                rb.setChecked(True)
            self.rbs.append(rb)
            rb.clicked.connect(self.selectionChanged)

        self.rbsel = QRadioButton("Select folder")
        self.lo.addWidget(self.rbsel)
        self.rbsel.clicked.connect(self.selectionChanged)

        self.selW = QWidget()
        selL = QHBoxLayout()
        self.selW.setLayout(selL)
        self.tbPath = QLineEdit()
        selL.addWidget(self.tbPath)
        self.btnSel = QPushButton("...")
        selL.addWidget(self.btnSel)
        self.lo.addWidget(self.selW)
        self.selW.setEnabled(False)
        self.btnSel.clicked.connect(self.btnSelectClick)
        
        self.lo.addStretch(1)
    
    def accept(self) -> bool:
        self.SelectedFolder = None
        for i in range(len(self.rbs)):
            if self.rbs[i].isChecked():
                self.SelectedFolder = FOLDERS[i][1]
        if self.rbsel.isChecked():
            if os.path.exists(self.tbPath.text()) and os.path.isdir(self.tbPath.text()):
                self.SelectedFolder = self.tbPath.text()
        if self.SelectedFolder == None:
            return False
        return True

    def selectionChanged(self):
        self.selW.setEnabled(self.rbsel.isChecked())
    
    def btnSelectClick(self):
        dialog = QFileDialog(self)
        dialog.setFileMode(QFileDialog.Directory)
        dialog.setOption(QFileDialog.ShowDirsOnly)
        res = dialog.exec_()
        if res:
            folder = dialog.selectedFiles()[0]
            self.tbPath.setText(folder)