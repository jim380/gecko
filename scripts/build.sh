#!/bin/bash -e

# Ted: contact me when you make any changes
export SALTICIDAE_GO_PATH="$GOPATH/src/github.com/$SALTICIDAE_ORG/salticidae-go"
export SALTICIDAE_PATH="$SALTICIDAE_GO_PATH/salticidae"
export CGO_CFLAGS="-I$SALTICIDAE_PATH/include/salticidae"
#export CGO_LDFLAGS="-L$SALTICIDAE_PATH/build/lib/ -lsalticidae -luv -lssl -lcrypto -lstdc++"

PREFIX="${PREFIX:-$(pwd)/build}"

SRC_DIR="$(dirname "${BASH_SOURCE[0]}")"
#source "$SRC_DIR/env.sh"

GECKO_PKG=github.com/ava-labs/gecko
GECKO_PATH="$GOPATH/src/$GECKO_PKG"
if [[ -d "$GECKO_PATH/.git" ]]; then
    cd "$GECKO_PATH"
    CGO_CFLAGS="-I$SALTICIDAE_PATH/include/salticidae" go get -t -v "./..."
    cd -
else
    CGO_CFLAGS="-I$SALTICIDAE_PATH/include/salticidae" go get -t -v "$GECKO_PKG/..."
fi

env GOOS=linux GOARCH=arm GOARM=7 CGO_ENABLED=1 CC=arm-linux-gnueabihf-gcc go build -o "$PREFIX/ava" "$GECKO_PATH/main/"*.go
env GOOS=linux GOARCH=arm GOARM=7 CGO_ENABLED=1 CC=arm-linux-gnueabihf-gcc go build -o "$PREFIX/xputtest" "$GECKO_PATH/xputtest/"*.go
