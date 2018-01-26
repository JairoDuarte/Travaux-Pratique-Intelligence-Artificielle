hanoi(3,1,2,3)

def hanoi(n,a=1,b=2,c=3):
    if (n > 0):
        hanoi(n-1,a,c,b)
        print ("Déplace %  sur % ",a,c)
        hanoi(n-1,b,a,c)
