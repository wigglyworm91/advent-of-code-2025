import argparse
import sys
from collections import defaultdict
from typing import Iterable

def main():
    parser = argparse.ArgumentParser()
    args = parser.parse_args()

    graph = defaultdict(set)
    for line in sys.stdin:
        device, *outputs = line.strip().split()
        device = device.rstrip(':')
        graph[device] = set(outputs)

    def dfs(src: str, dst: str, avoid: Iterable[str] = set(), num_paths_to_dst: dict[str, int] = None) -> int:
        if num_paths_to_dst is None:
            num_paths_to_dst = {}
        if src == dst:
            return 1
        else:
            if src not in num_paths_to_dst:
                num_paths_to_dst[src] = sum(dfs(c, dst, avoid=avoid, num_paths_to_dst=num_paths_to_dst) for c in graph[src] if c not in avoid)
            return num_paths_to_dst[src]

    print(dfs('svr', 'out'))
    print(
        dfs('svr', 'dac', avoid={'fft'}),
        dfs('dac', 'fft', avoid={'svr'}),
        dfs('fft', 'out', avoid={'dac'})
    )

    print(
        dfs('svr', 'fft', avoid={'dac'}),
        dfs('fft', 'dac', avoid={'svr'}),
        dfs('dac', 'out', avoid={'fft'})
    )


if __name__ == '__main__':
    main()
