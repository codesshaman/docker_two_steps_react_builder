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
# Функция удаления
if [ -d $OLD_FOLDER ]; then
    if confirm "Удалить предыдущую резервную копию исходников проекта? (y/n or enter for no)"; then
        echo "[NodeJS React Builder] Удаляю резервную копию исходников проекта"
        rm -rf $OLD_FOLDER
    else
        echo "[NodeJS React Builder] Удаление отменено"
    fi
fi
