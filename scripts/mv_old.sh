#!/bin/bash
FOLDER_NAME="$(grep "FOLDER" .env | sed -r 's/.{,7}//')"
POSTFIX="_old"
OLD_FOLDER=$FOLDER_NAME$POSTFIX
# Функция подтверждения
confirm() {
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}
# Функция восстановления
if [ -d $OLD_FOLDER ]; then
    if confirm "Восстановить исходники из последней резервной копии? (y/n or enter for no)"; then
        echo "[NodeJS React Builder] Восстанавливаю резервную копию"
        rm -rf $FOLDER_NAME
        cp -rf $OLD_FOLDER $FOLDER_NAME
    else
        echo "[NodeJS React Builder] Восстановление отменено"
    fi
else
    echo "[NodeJS React Builder] Резервная копия отсутствует"
fi
