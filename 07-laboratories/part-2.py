import sys
lines = sys.stdin.readlines()
W = len(lines[0])
H = len(lines)

state = [0] * W
state[lines[0].find('S')] = 1

for line in lines[1:]:
    print(line)
    for w in range(W):
        if line[w] == '^':
            state[w-1] += state[w]
            state[w+1] += state[w]
            state[w] = 0

    print(state)

print(sum(state))

'''
.......S.......
.......^.......
......^.^......
.....^.^.^.....
....^.^...^....
...^.^...^.^...
..^...^.....^..
.^.^.^.^.^...^.
'''
