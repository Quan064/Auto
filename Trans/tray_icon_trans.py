import sys
import os
import subprocess
from PyQt5.QtWidgets import QApplication, QSystemTrayIcon, QMenu
from PyQt5.QtGui import QIcon

class SystemTrayApp:
    def __init__(self):
        self.app = QApplication(sys.argv)

        # Khởi tạo tray icon
        icon_path = os.path.join(os.path.dirname(__file__), 'trans.ico')  # Bạn cần có file icon.ico
        self.tray = QSystemTrayIcon(QIcon(icon_path), self.app)
        self.tray.setToolTip("Click để chạy script")

        # Menu chuột phải (tùy chọn)
        menu = QMenu()
        quit_action = menu.addAction("Thoát")
        quit_action.triggered.connect(self.exit_app)
        self.tray.setContextMenu(menu)

        # Sự kiện click chuột
        self.tray.activated.connect(self.on_click)

        self.tray.show()
        self.app.exec_()

    def on_click(self, reason):
        # Nếu click chuột trái
        if reason == QSystemTrayIcon.Trigger:
            script = os.path.join(os.path.dirname(__file__), "trans.pyw")
            subprocess.Popen(['pythonw', script], shell=True)

    def exit_app(self):
        self.tray.hide()
        self.app.quit()

if __name__ == "__main__":
    SystemTrayApp()
