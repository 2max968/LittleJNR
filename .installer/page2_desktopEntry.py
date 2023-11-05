from PyQt5.QtWidgets import *
import page

class Page(page.Page):
    def __init__(self) -> None:
        super().__init__()

        self.lo = QVBoxLayout()
        self.setLayout(self.lo)
        self.lo.addWidget(QLabel("Lorem Iposum"))