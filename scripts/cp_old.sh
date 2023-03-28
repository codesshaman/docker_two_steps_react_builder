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
# Функция создания резервной копии
if [ -d $FOLDER_NAME ]; then
    if confirm "Создать резервную копию исходников проекта? (y/n or enter for no)"; then
        if [ -d $OLD_FOLDER ]; then
            echo "[NodeJS React Builder] Удаляю предыдущую копию исходников проекта"
            rm -rf $OLD_FOLDER
        fi
        echo "[NodeJS React Builder] Создаю резервную копию исходников проекта"
        cp -rf $FOLDER_NAME $OLD_FOLDER
    else
        echo "[NodeJS React Builder] Резервное копирование отменено"
    fi
fi