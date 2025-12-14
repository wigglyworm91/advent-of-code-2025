import itertools as it
import more_itertools as mit
import sys
import argparse
import re

class Machine:
    target: tuple[bool]
    buttons: list[tuple[int]]
    costs: tuple[int]
    def __repr__(self):
        return str(self.__dict__)

    def solutions(self):
        for num_combo in mit.powerset_of_sets(range(len(self.buttons))):
            combo = [self.buttons[i] for i in num_combo]
            syndrome = [
                sum(light in word for word in combo) % 2
                for light in range(len(self.target))
            ]
            if all(syn == tar for (syn,tar) in zip(syndrome, self.target)):
                yield num_combo

def parse_input(filelike) -> list[Machine]:
    out = []
    for line in filelike:
        m = Machine()
        line = line.rstrip('\n')
        g = re.match(r'\[(?P<target>[.#]+)\] (?P<buttons>(?:\([0-9,]+\) )+)(?P<costs>{[0-9,]+})', line)
        print(g.group('target'))
        print(g.group('buttons'))
        print(g.group('costs'))

        m.target = tuple({'#':True, '.':False}[c] for c in g.group('target'))
        m.buttons = [
            tuple(int(x) for x in tup.lstrip('(').rstrip(')').split(','))
            for tup in g.group('buttons').split()
        ]
        m.costs = tuple(int(x) for x in g.group('costs').lstrip('{').rstrip('}').split(','))

        out.append(m)

    return out

def main():
    parser = argparse.ArgumentParser()
    args = parser.parse_args()

    machines = parse_input(sys.stdin)
    total_best = 0
    for m in machines:
        print(m)
        best = min([soln for soln in m.solutions()], key=len)
        print('-->', best)
        total_best += len(best)

    print(f'total: {total_best}')

    
if __name__ == '__main__':
    main()
