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
if [ -d $FOLDER_NAME ]; then
    if confirm "Удалить текущую папку исходников проекта? (y/n or enter for no)"; then
        if [ -d $OLD_FOLDER ]; then
            echo "[NodeJS React Builder] Удаляю предыдущую резервную копию проекта"
            rm -rf $OLD_FOLDER
        fi
        echo "[NodeJS React Builder] Создаю резервную копию проекта"
        cp -rf $FOLDER_NAME $OLD_FOLDER
        echo "[NodeJS React Builder] Удаляю основной каталог исходников проекта"
        rm -rf $FOLDER_NAME
    else
        echo "[NodeJS React Builder] Удаление отменено"
    fi
    
fi