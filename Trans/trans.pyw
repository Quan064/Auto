import sys
from PyQt5.QtWidgets import QApplication, QLabel, QMainWindow, QVBoxLayout, QWidget
from PyQt5.QtGui import QPixmap
from PyQt5.QtCore import Qt
from PIL import ImageGrab, Image
from playwright.sync_api import sync_playwright
import os

PROCESSED_PATH = r"C:\Users\Hello\Downloads\captured_region.png"
IMAGE_PATH = r"C:\Users\Hello\OneDrive\Code Tutorial\Python\Auto\Trans\captured_region.png"

def Setup_Playwright():
    with sync_playwright() as p:
        context = p.chromium.launch_persistent_context(
            user_data_dir=r"C:\Users\Hello\OneDrive\Code Tutorial\Python\Selenium_tutorial\playwright_user",
            executable_path=r"C:/Program Files/Google/Chrome/Application/chrome.exe",
            headless=False,
            accept_downloads=True,
            args=[
                "--disable-blink-features=AutomationControlled",
                "--start-maximized"
            ]
        )
        page = context.pages[0] if context.pages else context.new_page()
        page.goto("https://translate.google.com/?sl=auto&tl=vi&op=images")

        # Upload ảnh
        file_input = page.locator('//*[@id="yDmH0d"]/c-wiz/div/div[2]/c-wiz/div[5]/c-wiz/div[2]/c-wiz/div/div/div/div[1]/div[2]/div[2]/div[1]/input')
        file_input.set_input_files(IMAGE_PATH)

        # Chờ nút xử lý xuất hiện và nhấn vào
        page.wait_for_selector('//*[@id="yDmH0d"]/c-wiz/div/div[2]/c-wiz/div[5]/c-wiz/div[2]/c-wiz/div/div[1]/div[2]/div[2]/button', timeout=10000)

        # Chờ kết quả xuất hiện (tùy trang xử lý bao lâu)
        with page.expect_download() as download_info:
            page.click('//*[@id="yDmH0d"]/c-wiz/div/div[2]/c-wiz/div[5]/c-wiz/div[2]/c-wiz/div/div[1]/div[2]/div[2]/button')
        download = download_info.value

        download.save_as(PROCESSED_PATH)
        context.close()

class ScreenCaptureApp(QMainWindow):
    def __init__(self):
        super().__init__()

        # Chụp màn hình với vùng được chọn
        screenshot = ImageGrab.grab(bbox=(0, 0, 1920, 1080 - 32))
        screenshot.save(IMAGE_PATH)  # Lưu tạm vào file

        Setup_Playwright()

        processed_img = Image.open(PROCESSED_PATH)
        processed_img = processed_img.resize(screenshot.size, Image.LANCZOS)
        processed_img.save(PROCESSED_PATH)

        pixmap = QPixmap(PROCESSED_PATH)

        self.setWindowTitle("Screen Capture Tool")
        self.setGeometry(-1, -1, pixmap.width(), pixmap.height())

        self.main_widget = QWidget()
        self.setCentralWidget(self.main_widget)

        self.layout = QVBoxLayout()
        self.main_widget.setLayout(self.layout)

        self.image_label = QLabel(self)
        self.image_label.setAlignment(Qt.AlignCenter)
        self.layout.addWidget(self.image_label)
        self.image_label.setPixmap(pixmap)
        self.layout.setContentsMargins(1, 1, 1, 1)

        # Bỏ thanh tiêu đề
        self.setWindowFlags(self.windowFlags() | Qt.FramelessWindowHint)

    def mousePressEvent(self, event):
        if event.button() == Qt.RightButton:
            self.setWindowOpacity(0)
            event.accept()

    def mouseReleaseEvent(self, event):
        if event.button() == Qt.RightButton:
            self.setWindowOpacity(1)
            event.accept()

    def mouseDoubleClickEvent(self, event):
        if event.button() == Qt.LeftButton:
            exit()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    main_window = ScreenCaptureApp()
    main_window.show()
    os.remove(PROCESSED_PATH)
    sys.exit(app.exec())