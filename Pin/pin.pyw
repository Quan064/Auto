import sys
from PyQt5.QtWidgets import QApplication, QLabel, QMainWindow, QVBoxLayout, QWidget
from PyQt5.QtGui import QPixmap
from PyQt5.QtCore import Qt, QPoint
from tkinter import Tk, Canvas
from PIL import ImageGrab


class ScreenCaptureApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.capture_screen()

    def init_ui(self, pixmap):
        self.setWindowTitle("Screen Capture Tool")
        self.setGeometry(100, 100, pixmap.width(), pixmap.height())

        self.main_widget = QWidget()
        self.setCentralWidget(self.main_widget)

        self.layout = QVBoxLayout()
        self.main_widget.setLayout(self.layout)

        self.image_label = QLabel(self)
        self.image_label.setAlignment(Qt.AlignCenter)
        self.layout.addWidget(self.image_label)

        # Thiết lập cửa sổ luôn trên cùng
        self.setWindowFlags(self.windowFlags() | Qt.WindowStaysOnTopHint)

        # Bỏ thanh tiêu đề
        self.setWindowFlags(self.windowFlags() | Qt.FramelessWindowHint)

    def mousePressEvent(self, event):
        """Xử lý khi nhấn chuột để bắt đầu kéo cửa sổ."""
        if event.button() == Qt.LeftButton:
            self.drag_pos = event.globalPos() - self.frameGeometry().topLeft()
            self.setWindowOpacity(0.5)
            event.accept()

    def mouseMoveEvent(self, event):
        """Xử lý khi di chuyển chuột để kéo cửa sổ."""
        if event.buttons() == Qt.LeftButton:
            self.move(event.globalPos() - self.drag_pos)
            event.accept()

    def mouseReleaseEvent(self, event):
        """Kết thúc kéo cửa sổ khi nhả chuột."""
        if event.button() == Qt.LeftButton:
            self.drag_pos = QPoint()
            self.setWindowOpacity(1)
            event.accept()

    def mouseDoubleClickEvent(self, event):
        """Xử lý khi nhấp đúp chuột để đóng cửa sổ."""
        if event.button() == Qt.LeftButton:
            exit()

    def capture_screen(self):

        # Hiển thị giao diện chọn vùng bằng Tkinter
        def on_selection_complete(crop_box):
            root.attributes("-alpha", 0)

            # Chụp màn hình với vùng được chọn
            screenshot = ImageGrab.grab(bbox=crop_box)
            screenshot.save("captured_region.png")  # Lưu tạm vào file
            pixmap = QPixmap("captured_region.png")

            self.init_ui(pixmap)
            self.image_label.setPixmap(pixmap)
            self.layout.setContentsMargins(1, 1, 1, 1)

            root.destroy()  # Đóng cửa sổ Tkinter

        # Tạo cửa sổ toàn màn hình
        root = Tk()
        root.attributes("-fullscreen", True)
        root.attributes("-alpha", 0.3)
        root.bind("<Escape>", lambda e: exit())  # Thoát bằng phím Esc

        canvas = Canvas(root, cursor="cross")
        canvas.pack(fill="both", expand=True)

        # Biến để lưu vị trí bắt đầu và kết thúc
        start_x, start_y = None, None
        rect_id = None

        def on_mouse_press(event):
            nonlocal start_x, start_y, rect_id
            start_x, start_y = event.x, event.y
            rect_id = canvas.create_rectangle(start_x, start_y, start_x, start_y, outline="red", width=2)

        def on_mouse_drag(event):
            nonlocal rect_id
            canvas.coords(rect_id, start_x, start_y, event.x, event.y)

        def on_mouse_release(event):
            x1, y1, x2, y2 = canvas.coords(rect_id)
            crop_box = (int(min(x1, x2)), int(min(y1, y2)), int(max(x1, x2)), int(max(y1, y2)))
            on_selection_complete(crop_box)

        canvas.bind("<ButtonPress-1>", on_mouse_press)
        canvas.bind("<B1-Motion>", on_mouse_drag)
        canvas.bind("<ButtonRelease-1>", on_mouse_release)

        root.mainloop()


if __name__ == "__main__":
    app = QApplication(sys.argv)
    main_window = ScreenCaptureApp()
    main_window.show()
    sys.exit(app.exec())
