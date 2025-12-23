from day07.commun import Resultat, NbOperations, Data


# Alog 3
# calcul des possibilités recursivement
# il y a arret si la somme dépassé la valeur cherché
# si la somme des valeurs restant ajouté à la valeur déjà clculé est superieur à la valeur cherché, il y a arret
# ça ne marche pas car si les valeurs restantes sont 1, l'addition va augmenter, alors que si c'est une multiplication, il n'y a pas d'augmentation
# j'ai mis le code en commentaire

class Algo3:

    def __init__(self, data: Data, nb_op: NbOperations) -> None:
        self.data = data
        self.nb_op = nb_op

    def parcourt3(self, liste_operateurs: list[str], no: int, val: int,
                  operateurs_selectionnee: list[str], reste: int) -> Resultat | None:

        if no < 0:
            raise IndexError("no=" + str(no))
        elif no >= len(self.data.nombres):
            raise IndexError("no=" + str(no) + ",len(data.nombres)=" + str(len(self.data.nombres)))
        res = -1
        if no == 0:
            v = self.data.nombres[no]
            total = 0
            # for n in self.data.nombres:
            #     total+=n
            # if total>self.data.valeur:
            #     return None
            reste = total - v
            return self.parcourt3(liste_operateurs, no + 1, v, [], reste)
        else:
            for operateur in liste_operateurs:
                if operateur == '+':
                    v2 = val + self.data.nombres[no]
                elif operateur == '*':
                    v2 = val * self.data.nombres[no]
                else:
                    raise Exception("Erreur")
                self.nb_op.nb += 1
                reste2 = reste - self.data.nombres[no]
                if v2 > self.data.valeur:
                    self.nb_op.abandon += 1
                    continue
                # elif v2+reste2>self.data.valeur:
                #     self.nb_op.abandon+=1
                #     continue
                if no >= len(self.data.nombres) - 1:
                    if v2 == self.data.valeur:
                        liste2 = operateurs_selectionnee.copy()
                        liste2.append(operateur)
                        self.nb_op.nbFeuilles += 1
                        return Resultat(self.data.valeur, self.data.nombres, liste2)
                else:
                    liste2 = operateurs_selectionnee.copy()
                    liste2.append(operateur)
                    res2 = self.parcourt3(liste_operateurs, no + 1, v2, liste2, reste2)
                    if res2 is not None:
                        return res2
        return None

    def cherche_operateurs3(self) -> Resultat | None:
        liste_operateurs = ['+', '*']

        return self.parcourt3(liste_operateurs, 0, 0, [], 0)
