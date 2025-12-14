#!/bin/bash

set -euo pipefail

(echo R50; cat) | sed 's/^./& /' | tr 'RL' '+-' | while read s y; do (yes "$s"1 || true) | head -n $y; done | awk '{total += $0; total %= 100; print(total)}' | grep '^0$' | wc -l
