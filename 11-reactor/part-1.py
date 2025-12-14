import argparse
import sys
from collections import defaultdict
import z3 # no kill like overkill

def main():
    parser = argparse.ArgumentParser()
    args = parser.parse_args()

    solver = z3.Solver()
    graph = defaultdict(set)
    for line in sys.stdin:
        device, *outputs = line.strip().split()
        device = device.rstrip(':')
        graph[device] = set(outputs)

    def dfs(src: str, dst: str, num_paths_to_dst: dict[str, int] = {}) -> int:
        if src == dst:
            return 1
        else:
            if src not in num_paths_to_dst:
                num_paths_to_dst[src] = sum(dfs(c, dst) for c in graph[src])
            return num_paths_to_dst[src]

    print(dfs('svr', 'out'))


if __name__ == '__main__':
    main()
