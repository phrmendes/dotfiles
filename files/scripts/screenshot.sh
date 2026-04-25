#!/usr/bin/env bash

set -euo pipefail

grim -g "$(slurp)" - | satty --filename -
