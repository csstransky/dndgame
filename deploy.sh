#!/bin/bash

export MIX_ENV=prod
export ENV=prod
export PORT=9977
export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"
export SSL_KEY_PATH=/etc/letsencrypt/live/dndgame.cstransky.com/privkey.pem
export SSL_CERT_PATH=/etc/letsencrypt/live/dndgame.cstransky.com/cert.pem
export SSL_CACERT_PATH=/etc/letsencrypt/live/dndgame.cstransky.com/chain.pem

echo "Building..."

mkdir -p ~/.config
mkdir -p priv/static

mix deps.get
mix compile
(cd assets && npm install)
(cd assets && webpack --mode production)
mix phx.digest

echo "Generating release..."
mix release

#echo "Starting database..."
#mix ecto.create
#mix ecto.migrate
#mix ecto.reset

echo "Stopping old copy of app, if any..."
_build/prod/rel/dndgame/bin/dndgame stop || true

echo "Starting app..."

_build/prod/rel/dndgame/bin/dndgame foreground
