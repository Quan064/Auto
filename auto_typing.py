import pyautogui
import time

# Nội dung muốn tự động đánh
text = r"""Some people believe that it is more beneficial for college students to live in schools rather than staying at home with their parents. I strongly agree with this view because living on campus can promote independence and provide a richer educational experience.

On the one hand, living in schools helps students develop independence, which is a crucial life skill. Those who live at home tend to depend more on their parents, which may delay their transition to adulthood. This independence gained at an early stage better prepares students for their future careers and personal lives. In contrast, without their parents to rely on, students must manage their daily lives, such as doing household chores, budgeting their expenses, and maintaining a proper schedule. For instance, students who live on campus are often required to handle their responsibilities, which fosters self-reliance.

Secondly, living in schools provides an environment that enhances academic and social experiences. Students on campus are surrounded by peers who share similar academic goals, making it easier to form study groups and exchange ideas. Additionally, they can participate in various extracurricular activities and events that are more accessible when living near school facilities. These experiences not only improve their education but also help build essential social skills. In contrast, students living at home may miss out on these opportunities due to distance or time constraints.

In conclusion, I firmly believe that living in schools is better for college students because it encourages independence and allows them to enjoy a more holistic educational experience.""".strip()

print(text.replace("\n\n", " ").count(" ")+1)

# Thời gian chờ trước khi bắt đầu (để bạn có thời gian chuyển đến cửa sổ nhập liệu)
# Đánh từng dòng trong text
time.sleep(5)
for line in text.split('\n'):
    pyautogui.typewrite(line)  # Đánh chữ
    pyautogui.press("enter")   # Nhấn Enter để xuống dòng
    time.sleep(0.5)            # Chờ một chút giữa các dòng