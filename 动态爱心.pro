import random
import math
from tkinter import *

# =========================
# 配置
# =========================
WIDTH = 800
HEIGHT = 600

CENTER_X = WIDTH // 2
CENTER_Y = HEIGHT // 2

BACKGROUND = "black"

# 多种粉色粒子
COLORS = [
    "#FF69B4",
    "#FF1493",
    "#FFB6C1",
    "#FFC0CB",
    "#FF85C1"
]

FRAME_DELAY = 40


# =========================
# 爱心函数
# =========================
def heart_function(t, scale=15):
    """
    爱心参数方程
    """
    x = 16 * math.sin(t) ** 3
    y = -(13 * math.cos(t)
          - 5 * math.cos(2 * t)
          - 2 * math.cos(3 * t)
          - math.cos(4 * t))

    x *= scale
    y *= scale

    x += CENTER_X
    y += CENTER_Y

    return int(x), int(y)


# =========================
# 粒子类
# =========================
class Particle:

    def __init__(self):
        t = random.uniform(0, 2 * math.pi)

        self.base_x, self.base_y = heart_function(t)

        self.x = self.base_x
        self.y = self.base_y

        self.size = random.randint(1, 3)

        self.color = random.choice(COLORS)

        self.speed = random.uniform(0.5, 2)

        self.offset = random.uniform(0, 2 * math.pi)

    def move(self, frame):

        # 心跳缩放
        beat = 1 + 0.04 * math.sin(frame * 0.2)

        dx = self.base_x - CENTER_X
        dy = self.base_y - CENTER_Y

        self.x = CENTER_X + dx * beat
        self.y = CENTER_Y + dy * beat

        # 添加随机漂浮
        self.x += math.sin(frame * 0.1 + self.offset) * self.speed
        self.y += math.cos(frame * 0.1 + self.offset) * self.speed

    def draw(self, canvas):

        canvas.create_oval(
            self.x,
            self.y,
            self.x + self.size,
            self.y + self.size,
            fill=self.color,
            outline=""
        )


# =========================
# 主爱心类
# =========================
class HeartAnimation:

    def __init__(self, canvas):

        self.canvas = canvas

        self.frame = 0

        self.particles = []

        self.create_particles()

    def create_particles(self):

        for _ in range(2500):
            self.particles.append(Particle())

    def draw_glow(self):

        # 外层光环
        radius = 220 + 8 * math.sin(self.frame * 0.15)

        self.canvas.create_oval(
            CENTER_X - radius,
            CENTER_Y - radius,
            CENTER_X + radius,
            CENTER_Y + radius,
            outline="#330011"
        )

    def render(self):

        self.canvas.delete("all")

        self.draw_glow()

        for particle in self.particles:
            particle.move(self.frame)
            particle.draw(self.canvas)

        self.frame += 1

        self.canvas.after(FRAME_DELAY, self.render)


# =========================
# 主程序
# =========================
root = Tk()

root.title("❤️ Dynamic Heart")

root.configure(bg=BACKGROUND)

root.geometry(f"{WIDTH}x{HEIGHT}")

canvas = Canvas(
    root,
    width=WIDTH,
    height=HEIGHT,
    bg=BACKGROUND,
    highlightthickness=0
)

canvas.pack()

# 文字
canvas.create_text(
    CENTER_X,
    CENTER_Y + 180,
    text="I Like You ❤️",
    fill="#FF99CC",
    font=("Helvetica", 24, "bold")
)

heart = HeartAnimation(canvas)

heart.render()

root.mainloop()