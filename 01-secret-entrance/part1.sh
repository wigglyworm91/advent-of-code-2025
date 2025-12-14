#!/bin/bash

set -euo pipefail

(echo 50; cat) | tr 'RL' '+-' | awk '{total += $0; total %= 100; print(total)}' | grep '^0$' | wc -l
