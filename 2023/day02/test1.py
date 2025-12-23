import re

file1 = open('test_advent_of_code_2023_day2_part1.txt', 'r')
Lines = file1.readlines()

def recherche(couleur):

    valeur=0
    res=re.findall(r'\d+ '+couleur, line)
    if len(res)>0:
        for tmp in res:
            s0=tmp[0:-len(couleur)-1]
            n0=int(s0)
            valeur+=n0
    
    return valeur

total=0
listeGame=[]

for line in Lines:
    print('line:',line)
    res=re.findall(r'Game \d+', line)
    if len(res)>0:
        n=int(res[0][5:])
        

        rouge=recherche('red')
        vert=recherche('green')
        bleu=recherche('blue')

        print("game "+str(n)+" "+str(rouge)+" rouge, "+str(vert)+" vert, "+str(bleu)+" bleu")

        if rouge<=12 and vert<=13 and bleu<=14:
            listeGame.append(n)
            total+=n

print("game"+str(listeGame))
print(total)
