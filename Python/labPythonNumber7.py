# # Задача 1
n = 2
a = []
#Ввод массива
for i in range(n):
    b = []
    for j in range(n):
        print('Введите [', i, ',',j,']')
        b.append(int(input()))
    a.append(b)
#Вывод массива
for i in range(n):
    for j in range(n):
        print(a[i][j], end = ' ')
    print()
amax = a[0][0]
maxArr = []
minimum = a[0]
for i in range(n):
    if a[i][i] > amax:
        imax = i
        temp = i 
        amax = a[i][i]
    if a[i][n-i-1] > amax:
        imax = i 
        temp = n-i-1
        amax = a[i][n-i-1]
    maximum = a[i][0]
    for j in range(n):
        if maximum < a[i][j] :
            maximum = a[i][j]
        if minimum[j] > a[i][j]:
            minimum[j] = a[i][j]
    maxArr.append(maximum)
print('Наибольшие элементы в строках:\n', maxArr)
print('Наименьшие элементы в столбце:\n', minimum)

# Задача 2
a=[[1, 2, 3],
   [4, 5, 6],
   [7, 8, 9]]
print(*a, sep = '\n')
print()
if len(a) % 2 > 0:
    arr = [a[i][i] for i in range(len(a))]
    for i in range(len(a)):
        arr.append(a[i][-i])
    maxArr = max(arr)
    for i in range(len(a)):
        if a[i][i]== maxArr:
            a[len(a) // 2][len(a) // 2], a[i][i] = a[i][i], a[len(a) // 2][len(a) // 2]
        elif a[i][-i] == maxArr:
            a[len(a) // 2][len(a) // 2], a[i][-i] = a[i][-i], a[len(a) // 2][len(a) // 2]
    print(*a, sep = '\n')