a = input("Введите строку: ")
string = ''
for i in range(len(a)):
    if a[i] != 'А' and a[i] != 'а':
        string += a[i]
        
print("Строка без буквы 'а' = ", string)
print("Количество удаленных 'а' и 'А' в тексте = ", a.count('а') + a.count('А'))
