import re

# cf : https://galaxyinferno.com/how-to-solve-advent-of-code-2023-day-2-with-python/

def min(a,b):
    if a>0 and b>0:
        return max(a,b)
    elif a>0:
        return a
    elif b>0:
        return b
    else:
        return 0

def parse_game(game_str: str):
    # game = "Game 1", content = "3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
    game, content = game_str.split(':')
    game_id = int(game.split(' ')[1])
    # content_rounds = ["3 blue, 4 red", "1 red, 2 green, 6 blue", "2 green"]
    rounds_of_game = content.split(';')
    cube_rounds = [0, 0, 0]
    for round in rounds_of_game:

        # round example = "3 blue, 4 red" -> [["3", "blue"], ["4", "red"]]
        cube_groups = [cube_group.strip().split(' ') for cube_group in round.split(',')]
        for cube_group in cube_groups:
            if cube_group[1] == 'red':
                cube_rounds[0] = min(cube_rounds[0],int(cube_group[0]))
            elif cube_group[1] == 'green':
                cube_rounds[1] = min(cube_rounds[1],int(cube_group[0]))
            elif cube_group[1] == 'blue':
                cube_rounds[2] = min(cube_rounds[2],int(cube_group[0]))
    return game_id, cube_rounds


def solve1(input_file: str) -> int:
    #compare_cubes = [12, 13, 14]
    values = []

    with open(input_file, 'r') as f:
        lines = f.readlines()
        games = [entry.strip() for entry in lines]

    for game in games:
        game_id, cube_rounds = parse_game(game)
        print("game "+str(game_id)+":"+str(cube_rounds))
        n=1
        for round in cube_rounds:
            if round>0:
                    n=n*round

        values.append(n)



            
        
    print("possible game:"+str(values))
    return sum(values)

res=solve1('test_advent_of_code_2023_day2_part1.txt')
#res=solve1('test4.txt')

print("res="+str(res))

# solution : 66027
