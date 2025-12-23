from itertools import product

from day07.commun import Resultat, NbOperations, Data


# algo 1 :
# calcul directe de toutes les possibilité avec une boucle
#

class Algo1:
    def __init__(self, data: Data, nb_op: NbOperations) -> None:
        self.data = data
        self.nb_op = nb_op

    def cherche_operateurs(self) -> Resultat | None:
        liste_operateurs = ['+', '*']

        longueur = len(self.data.nombres) - 1
        combinaisons = [''.join(p) for p in product(liste_operateurs, repeat=longueur)]

        for combinaison in combinaisons:
            valeur = 0
            for i in range(len(self.data.nombres)):
                if i == 0:
                    valeur = self.data.nombres[i]
                else:
                    op2 = combinaison[i - 1]
                    v = self.data.nombres[i]
                    if op2 == '+':
                        valeur = valeur + v
                        self.nb_op.nb += 1
                    elif op2 == '*':
                        valeur = valeur * v
                        self.nb_op.nb += 1
            if valeur == self.data.valeur:
                self.nb_op.nbFeuilles += 1
                return Resultat(valeur, self.data.nombres, combinaison.split())

        return None
