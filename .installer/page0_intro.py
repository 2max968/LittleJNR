from PyQt5.QtWidgets import *
import page

DESCRIPTION = "This program will lead you through the installation of ..."

class Page(page.Page):
    def __init__(self) -> None:
        super().__init__()

        self.lo = QVBoxLayout()
        self.setLayout(self.lo)
        self.lo.addWidget(QLabel(""))