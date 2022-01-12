import math
x = float(input("Введите переменную х: "))
a = float(input("Введите переменную a: "))
b = float(input("Введите переменную b: "))
n = float(input("Введите переменную n: "))

t1 = 1/a * (-1/(n-2)*pow(x, n-2) + b/(n-1)*pow(x, n-1))
t2 = 2*x/pow(a, 2) * math.sin(a * x) - (pow(x,2) / a - 2 / pow(a,3)) * math.cos(a*x)

print("t1 = {0:.2f}".format(t1))
print("t2 = {0:.2f}".format(t2))