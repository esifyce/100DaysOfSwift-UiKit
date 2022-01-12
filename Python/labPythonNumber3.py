import math
a = float(input("Введите число а: "))
b = float(input("Введите число b: "))
c = float(input("Введите число c: "))

if math.sin(a) > math.sin(b):
    if math.sin(a) > math.sin(c):
        d = a
    else:
        d = c
else:
    if math.sin(b) > math.sin(a):
        d = b
    else:
        d = c
print("Максимальный синус из трёх чисел = ", d)
