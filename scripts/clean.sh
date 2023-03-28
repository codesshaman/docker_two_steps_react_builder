#!/bin/bash
FOLDER_NAME="$(grep "FOLDER" .env | sed -r 's/.{,7}//')"
rm -rf ${FOLDER_NAME}