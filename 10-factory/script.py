import itertools as it
import more_itertools as mit
import sys
import argparse
import re
import z3

class Machine:
    target: tuple[bool]
    buttons: list[tuple[int]]
    joltages: tuple[int]
    def __repr__(self):
        return str(self.__dict__)

    def solve(self):
        s = z3.Optimize()
        presses = [z3.Int(f'presses_{i}') for i in range(len(self.buttons))]
        # all buttons must be pressed a nonnegative number of times
        for b in presses:
            s.add(b >= 0)

        # each joltage must be satisfied
        sim_joltages = [0 for j in range(len(self.joltages))]
        for p, press in enumerate(presses):
            for light in self.buttons[p]:
                sim_joltages[light] = sim_joltages[light] + press

        for j, jolt in enumerate(sim_joltages):
            s.add(jolt == self.joltages[j])

        s.minimize(sum(presses))

        #print(s)
        assert s.check() == z3.sat
        soln = s.model()
        return [
            soln[presses[i]].as_long() for i in range(len(self.buttons))
        ]

def parse_input(filelike) -> list[Machine]:
    out = []
    for line in filelike:
        m = Machine()
        line = line.rstrip('\n')
        g = re.match(r'\[(?P<target>[.#]+)\] (?P<buttons>(?:\([0-9,]+\) )+)(?P<joltages>{[0-9,]+})', line)

        m.target = tuple({'#':True, '.':False}[c] for c in g.group('target'))
        m.buttons = [
            tuple(int(x) for x in tup.lstrip('(').rstrip(')').split(','))
            for tup in g.group('buttons').split()
        ]
        m.joltages = tuple(int(x) for x in g.group('joltages').lstrip('{').rstrip('}').split(','))

        out.append(m)

    return out

def main():
    parser = argparse.ArgumentParser()
    args = parser.parse_args()

    machines = parse_input(sys.stdin)
    total_best = 0
    for m in machines:
        print(m)
        best = m.solve()
        print('-->', best)
        total_best += sum(best)

    print(f'total: {total_best}')

    
if __name__ == '__main__':
    main()
