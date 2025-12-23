import re

# cf : https://galaxyinferno.com/how-to-solve-advent-of-code-2023-day-2-with-python/

def parse_game(game_str: str):
    # game = "Game 1", content = "3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
    game, content = game_str.split(':')
    game_id = int(game.split(' ')[1])
    # content_rounds = ["3 blue, 4 red", "1 red, 2 green, 6 blue", "2 green"]
    rounds_of_game = content.split(';')
    cube_rounds = []
    for round in rounds_of_game:
        found_cubes = [0, 0, 0]
        # round example = "3 blue, 4 red" -> [["3", "blue"], ["4", "red"]]
        cube_groups = [cube_group.strip().split(' ') for cube_group in round.split(',')]
        for cube_group in cube_groups:
            if cube_group[1] == 'red':
                found_cubes[0] += int(cube_group[0])
            elif cube_group[1] == 'green':
                found_cubes[1] += int(cube_group[0])
            elif cube_group[1] == 'blue':
                found_cubes[2] += int(cube_group[0])
        cube_rounds.append(found_cubes)
    return game_id, cube_rounds


def solve1(input_file: str) -> int:
    compare_cubes = [12, 13, 14]
    possible_games = []

    with open(input_file, 'r') as f:
        lines = f.readlines()
        games = [entry.strip() for entry in lines]

    for game in games:
        game_id, cube_rounds = parse_game(game)
        print("game "+str(game_id)+":"+str(cube_rounds))
        game_possible = True
        for round in cube_rounds:
            for round_color, limit_color in zip(round, compare_cubes):
                if round_color > limit_color:
                    game_possible = False
        if game_possible:
            possible_games.append(game_id)
    print("possible game:"+str(possible_games))
    return sum(possible_games)

res=solve1('test_advent_of_code_2023_day2_part1.txt')

print("res="+str(res))

