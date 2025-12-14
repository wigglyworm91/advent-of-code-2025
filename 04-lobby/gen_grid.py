#!/usr/bin/env python3
import sys
import argparse
import random

def generate_grid(size: int, density: float) -> list[str]:
    """Generate a square grid with given density of @ symbols"""
    grid = []
    for _ in range(size):
        row = ''.join('@' if random.random() < density else '.' for _ in range(size))
        grid.append(row)
    return grid

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate a random grid of @ and .')
    parser.add_argument('size', type=int, help='Size of the square grid (e.g., 10 for 10x10)')
    parser.add_argument('-k', '--density', type=float, default=0.5,
                       help='Density of @ symbols (0.0 to 1.0, default: 0.5)')
    
    args = parser.parse_args()
    
    if not 0 <= args.density <= 1:
        print('Error: density must be between 0.0 and 1.0', file=sys.stderr)
        sys.exit(1)
    
    grid = generate_grid(args.size, args.density)
    for row in grid:
        print(row)
