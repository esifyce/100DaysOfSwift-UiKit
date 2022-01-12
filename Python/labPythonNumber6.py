# Задача 1
array = [3, 5, 7, 1, 9, 12, 11 , 18, 2, 6]
b = 0
m = 0
r = 0
number = max(array)
for i in array:
    if i > number:
        b += 1
    elif i < number:
        m += 1
    elif i == number:
        r += 1
print("Ваш массив = ", array)
print("Максимальное число в массиве = ", max(array))
print("Количество больше чем, максимальный элемент (>) = ",b)
print("Количество меньших чем, максимальный элемент (<) = ",m)
print("Количество одинаковых значений (==) = ",r)

# Задача 2
massive = []
sum = 0
for value in range(10):
    value = int(input("\nВведите элемент массива: "))
    massive.append(value)
print("Ваш массив из 10 значений:\n", massive)
for k in massive:
    if massive[k] > 5:
        sum += massive[k]
print("Сумма вашего массива при условии (массив > 5) = ", sum)