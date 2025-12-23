from day07.commun import Resultat, Data, NbOperations


# Algo 2
# calcul des possibilités recursivement
# il y a arret si la somme dépassé la valeur cherché

class Algo2:

    def __init__(self, data: Data, nb_op: NbOperations) -> None:
        self.data = data
        self.nb_op = nb_op

    def parcourt(self, liste_operateurs: list[str], no: int, val: int,
                 operateurs_selectionnee: list[str]) -> Resultat | None:

        if no < 0:
            raise IndexError("no=" + str(no))
        elif no >= len(self.data.nombres):
            raise IndexError("no=" + str(no) + ",len(data.nombres)=" + str(len(self.data.nombres)))
        if no == 0:
            v = self.data.nombres[no]
            return self.parcourt(liste_operateurs, no + 1, v, [])
        else:
            for operateur in liste_operateurs:
                if operateur == '+':
                    v2 = val + self.data.nombres[no]
                    self.nb_op.nb += 1
                elif operateur == '*':
                    v2 = val * self.data.nombres[no]
                    self.nb_op.nb += 1
                else:
                    raise Exception("Erreur")
                if no >= len(self.data.nombres) - 1:
                    if v2 == self.data.valeur:
                        liste2 = operateurs_selectionnee.copy()
                        liste2.append(operateur)
                        self.nb_op.nbFeuilles += 1
                        return Resultat(self.data.valeur, self.data.nombres, liste2)
                else:
                    liste2 = operateurs_selectionnee.copy()
                    liste2.append(operateur)
                    res2 = self.parcourt(self.data, liste_operateurs, no + 1, v2, liste2, self.nb_op)
                    if res2 is not None:
                        return res2
        return None

    def parcourt2(self, liste_operateurs: list[str], no: int, val: int,
                  operateurs_selectionnee: list[str]) -> Resultat | None:

        if no < 0:
            raise IndexError("no=" + str(no))
        elif no >= len(self.data.nombres):
            raise IndexError("no=" + str(no) + ",len(data.nombres)=" + str(len(self.data.nombres)))
        if no == 0:
            v = self.data.nombres[no]
            return self.parcourt2(liste_operateurs, no + 1, v, [])
        else:
            for operateur in liste_operateurs:
                if operateur == '+':
                    v2 = val + self.data.nombres[no]
                    self.nb_op.nb += 1
                elif operateur == '*':
                    v2 = val * self.data.nombres[no]
                    self.nb_op.nb += 1
                else:
                    raise Exception("Erreur")
                if v2 > self.data.valeur:
                    self.nb_op.abandon += 1
                    continue
                if no >= len(self.data.nombres) - 1:
                    if v2 == self.data.valeur:
                        liste2 = operateurs_selectionnee.copy()
                        liste2.append(operateur)
                        self.nb_op.nbFeuilles += 1
                        return Resultat(self.data.valeur, self.data.nombres, liste2)
                else:
                    liste2 = operateurs_selectionnee.copy()
                    liste2.append(operateur)
                    res2 = self.parcourt2(liste_operateurs, no + 1, v2, liste2)
                    if res2 is not None:
                        return res2
        return None

    def cherche_operateurs2(self) -> Resultat | None:
        liste_operateurs = ['+', '*']

        return self.parcourt2(liste_operateurs, 0, 0, [])
