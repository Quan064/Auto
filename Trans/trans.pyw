import sys
from PyQt5.QtWidgets import QApplication, QLabel, QMainWindow, QVBoxLayout, QWidget
from PyQt5.QtGui import QPixmap
from PyQt5.QtCore import Qt
from PIL import ImageGrab, Image
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import undetected_chromedriver as uc
from time import sleep
import os

PROCESSED_PATH = r"C:\Users\Hello\Downloads\captured_region.png"

def Setup_ChromeDriver():

    path = r'C:\Users\Hello\OneDrive\Code Tutorial\Python\Selenium_tutorial\chromedriver-win64\chromedriver.exe'
    chrome_options = uc.ChromeOptions()
    chrome_options.add_argument("--disable-blink-features=AutomationControlled")
    prefs = {
        "profile.managed_default_content_settings.images": 2,  # Tắt tải ảnh
        "profile.managed_default_content_settings.fonts": 2,   # Tắt fonts
    }
    chrome_options.add_experimental_option("prefs", prefs)
    driver = uc.Chrome(driver_executable_path=path, options=chrome_options)
    driver.get("https://translate.google.com/?sl=auto&tl=vi&op=images")

    driver.find_element(By.XPATH, '//*[@id="yDmH0d"]/c-wiz/div/div[2]/c-wiz/div[5]/c-wiz/div[2]/c-wiz/div/div/div/div[1]/div[2]/div[2]/div[1]/input').send_keys(r"C:\Users\Hello\OneDrive\Code Tutorial\Python\Auto\Trans\captured_region.png")
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.XPATH, '//*[@id="yDmH0d"]/c-wiz/div/div[2]/c-wiz/div[5]/c-wiz/div[2]/c-wiz/div/div[1]/div[2]/div[2]/button'))).click()
    while True:
        if os.path.exists(PROCESSED_PATH): break
        sleep(0.1)
    driver.quit()

class ScreenCaptureApp(QMainWindow):
    def __init__(self):
        super().__init__()

        # Chụp màn hình với vùng được chọn
        screenshot = ImageGrab.grab(bbox=(0, 0, 1920, 1080-32))
        screenshot.save("captured_region.png")  # Lưu tạm vào file

        Setup_ChromeDriver()

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
        """Xử lý khi nhấn chuột để bắt đầu kéo cửa sổ."""
        if event.button() == Qt.RightButton:
            self.setWindowOpacity(0)
            event.accept()

    def mouseReleaseEvent(self, event):
        """Kết thúc kéo cửa sổ khi nhả chuột."""
        if event.button() == Qt.RightButton:
            self.setWindowOpacity(1)
            event.accept()

    def mouseDoubleClickEvent(self, event):
        """Xử lý khi nhấp đúp chuột để đóng cửa sổ."""
        if event.button() == Qt.LeftButton:
            exit()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    main_window = ScreenCaptureApp()
    main_window.show()
    os.remove(PROCESSED_PATH)
    sys.exit(app.exec())