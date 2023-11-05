import typing
from PyQt5 import QtCore
from PyQt5.QtWidgets import *
from PyQt5.QtWidgets import QWidget

class Page(QWidget):
    def __init__(self) -> None:
        super().__init__()
    
    def accept(self) -> bool:
        return True