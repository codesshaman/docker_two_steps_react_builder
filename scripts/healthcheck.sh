#!/bin/bash
PORT="$(grep "PORT" .env | sed -r 's/.{,5}//')"
RESULT=$(curl -Is http://localhost:$PORT | head -n 1)
echo $RESULT