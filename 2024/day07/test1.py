from dataclasses import dataclass
from itertools import product
from timeit import timeit

from day07.algo1 import Algo1
from day07.algo2 import Algo2
from day07.algo3 import Algo3
from day07.commun import lecture, NbOperations, Data, Resultat


def cherche_operateurs_choix(data: Data, no: int, nb_op: NbOperations) -> Resultat | None:
    if no == 0:
        return Algo1(data, nb_op).cherche_operateurs()
    elif no == 1:
        return Algo2(data, nb_op).cherche_operateurs2()
    elif no == 2:
        return Algo3(data, nb_op).cherche_operateurs3()
    else:
        raise Exception("Erreur")


def recherche(no: int):
    # liste1 = lecture('test1.txt')
    liste1 = lecture('input.txt')
    print(liste1)

    total = 0
    nb = 0
    nbOp = NbOperations(0, 0, 0)
    for x in liste1:
        op = cherche_operateurs_choix(x, no, nbOp)
        if op is not None:
            print('trouve:', x, op)
            nb += 1
            total += x.valeur
        else:
            print('non trouve:', x)
    print('nb:', nb)
    print('total:', total)
    print('nb op:', nbOp)


if True:
    no = 0
    no = 1
    # no = 2

    recherche(no)
else:
    no = 0
    no = 1
    print(timeit(lambda: recherche(no), number=500))
