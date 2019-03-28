#!/bin/bash

export MIX_ENV=prod
export PORT=9977

echo "Stopping old copy of app, if any..."

_build/prod/rel/dndgame/bin/dndgame stop || true

echo "Starting app..."

# Foreground for testing and for systemd
_build/prod/rel/dndgame/bin/dndgame foreground
