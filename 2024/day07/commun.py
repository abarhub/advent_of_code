from dataclasses import dataclass


@dataclass
class Data:
    valeur: int
    nombres: list[int]


@dataclass
class Resultat:
    valeur: int
    nombres: list[int]
    operateurs: list[str]


@dataclass
class NbOperations:
    nb: int
    nbFeuilles: int
    abandon: int


def lecture(fichier) -> list[Data]:
    res = []
    with open(fichier, 'r') as file:
        # Read each line in the file
        for line in file:
            # Print each line
            s = line.strip()
            t = s.split(':')
            t2 = t[1].split()
            tab = []
            for x in t2:
                tab.append(int(x))
            d = Data(int(t[0]), tab)
            # print(line.strip())
            # print(d)
            res.append(d)

    return res
