import keyboard
import tkinter as tk
from monitorcontrol import get_monitors
import subprocess

hide_after_id = None
path = r"C:\Users\Hello\OneDrive\Tài liệu\ClickMonitorDDC_7_2\ClickMonitorDDC_7_2.exe"

def adjust_brightness(delta):
    global hide_after_id

    with get_monitors()[0] as monitor:
        current = monitor.get_luminance()
        new_value_brightness = max(0, min(100, current + delta))
        monitor.set_luminance(new_value_brightness)
        subprocess.run(f'"{path}" c{new_value_brightness}', shell=True)
        brightness_label.config(text=f"{new_value_brightness:.0f}%")

        if not root.winfo_viewable():
            root.deiconify()

    if not root.winfo_viewable():
        root.deiconify()

    if hide_after_id is not None:
        root.after_cancel(hide_after_id)

    hide_after_id = root.after(3000, hide_window)

def hide_window():
    global hide_after_id
    root.withdraw()
    hide_after_id = None

# Tạo cửa sổ không viền và nền trong suốt
root = tk.Tk()
root.overrideredirect(True)
root.geometry("86x35+917+972")
root.wm_attributes('-topmost', True)

# Màu sẽ được làm trong suốt
transparent_color = 'pink'
root.configure(bg=transparent_color)
root.wm_attributes('-transparentcolor', transparent_color)
hide_window()

# Canvas nền
canvas = tk.Canvas(root, width=86, height=35, bg=transparent_color, highlightthickness=0)
canvas.pack()

# Vẽ hình bo góc với nền thật
def draw_rounded_rect(x, y, w, h, r, color):
    canvas.create_arc(x, y, x+r*2, y+r*2, start=90, extent=90, fill=color, outline=color)
    canvas.create_arc(x+w-r*2, y, x+w, y+r*2, start=0, extent=90, fill=color, outline=color)
    canvas.create_arc(x+w-r*2, y+h-r*2, x+w, y+h, start=270, extent=90, fill=color, outline=color)
    canvas.create_arc(x, y+h-r*2, x+r*2, y+h, start=180, extent=90, fill=color, outline=color)
    canvas.create_rectangle(x+r, y, x+w-r, y+h, fill=color, outline=color)
    canvas.create_rectangle(x, y+r, x+w, y+h-r, fill=color, outline=color)

draw_rounded_rect(0, 0, 86, 35, 8, "#2f2f2f")

# Biểu tượng và nhãn
light_icon = tk.Label(root, text="🔆", font=("Arial", 14), bg="#2f2f2f", fg="white")
light_icon.place(x=8, y=1)

brightness_label = tk.Label(root, text="50%", font=("Arial", 13), bg="#2f2f2f", fg="white")
brightness_label.place(x=35, y=5)

# Phím tắt
with get_monitors()[0] as monitor:
    monitor.set_luminance(60)
    subprocess.run(f'"{path}" c60', shell=True)
keyboard.add_hotkey("ctrl+f1", lambda: adjust_brightness(-10))
keyboard.add_hotkey("ctrl+f2", lambda: adjust_brightness(+10))

root.mainloop()