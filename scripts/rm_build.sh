#!/bin/bash
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
# Функция удаления билда
if [ -d build ]; then
    if confirm "Удалить результат билда контейнера? (y/n or enter for no)"; then
        echo "[NodeJS React Builder] Удаляю результат сборки проекта"
        rm -rf build/*
    else
        echo "[NodeJS React Builder] Удаление отменено"
    fi
fi
