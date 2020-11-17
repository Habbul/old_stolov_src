import os

q = os.listdir()
s = [i.split('.')[::-1][0] for i in q]
a = set()
a = a.union(s)
for i in a:
    print(i)
