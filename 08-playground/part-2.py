import sys
import itertools as it
from disjoint_set import DisjointSet

def dister(a: str, b: str) -> float:
    a = [int(x) for x in a.split(',')]
    b = [int(x) for x in b.split(',')]
    return sum( (x-y)**2 for (x,y) in zip(a, b) ) ** 0.5

boxes = [line.strip() for line in sys.stdin.readlines()]

dists = [(dister(b, c), b, c) for (b,c) in it.combinations(boxes, r=2)]
dists = list(sorted(dists))


uf = DisjointSet.from_iterable(boxes)

while len(list(uf.itersets())) > 1:
    dist, src, dst = dists.pop(0)
    print(f'Joining {src} to {dst} at a cost of {dist}')
    uf.union(src, dst)
