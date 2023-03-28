#!/bin/bash
GIT_REPOS="$(grep "REPOS" .env | sed -r 's/.{,6}//')"
GIT_BRANCH="$(grep "BRANCH" .env | sed -r 's/.{,7}//')"
FOLDER_NAME="$(grep "FOLDER" .env | sed -r 's/.{,7}//')"
BUILDER_NAME="$(grep "BUILDER" .env | sed -r 's/.{,8}//')"
PRODUCT_NAME="$(grep "PRODUCT" .env | sed -r 's/.{,8}//')"
FIRST_CHECK=false
SECOND_CHECK=false
THIRD_CHECK=false
FOURTH_CHECK=false
TIMEOUT=5
if [ ! -d $FOLDER_NAME ]; then
    echo "[NodeJS React Builder] Скачиваю проект из репозитория"
    git clone ${GIT_REPOS} -b ${GIT_BRANCH} ${FOLDER_NAME}
elif [ -d $FOLDER_NAME ]; then
    echo "[NodeJS React Builder] Обновляю код проекта"
    cd ${FOLDER_NAME}
    git pull
    cd ../
fi
rm -rf build/*
echo "[NodeJS React Builder] Запускаю сборку"
echo "[NodeJS React Builder] Вывод перенаправляется в файл, ожидайте"
docker-compose -f ./docker-compose.build.yml up -d --build > logs.txt
echo "[NodeJS React Builder] Сборка закончена, ожидаю старта контейнера"
sleep $TIMEOUT
curl -Is http://localhost:999 | head -n 1 >> logs.txt
docker inspect $BUILDER_NAME >> logs.txt
grep 'Successfully built' logs.txt && FIRST_CHECK=true || FIRST_CHECK=false
grep '"Status": "running"' logs.txt && SECOND_CHECK=true || SECOND_CHECK=false
grep  '"Running": true' logs.txt && THIRD_CHECK=true || THIRD_CHECK=false
grep 'HTTP/1.1 200 OK' logs.txt && FOURTH_CHECK=true || FOURTH_CHECK=false
NETWORK=grep 'NetworkMode' logs.txt
echo "[NodeJS React Builder] Выполняю проверку запуска"
# Проверка сборки
if [ $FIRST_CHECK == true ]; then
    echo "[NodeJS React Builder] Проверка сборки пройдена"
else
    echo "[NodeJS React Builder] Сборка завершилась неудачно"
fi
# Проверка запуска
if [ $SECOND_CHECK == true ]; then
    echo "[NodeJS React Builder] Проверка запуска пройдена"
else
    echo "[NodeJS React Builder] Обнаружены проблемы с запуском"
fi
# Проверка запуска
if [ $THIRD_CHECK == true ]; then
    echo "[NodeJS React Builder] Контейнер успешно запущен"
else
    echo "[NodeJS React Builder] Не удалось запустить контейнер"
fi
# Проверка healthcheck
if [ $FOURTH_CHECK == true ]; then
    echo "[NodeJS React Builder] Проверка здоровья пройдена"
else
    echo "[NodeJS React Builder] Проверка здоровья не пройдена"
fi
if [ $FOURTH_CHECK == true ] && [ $THIRD_CHECK == true ] && [ $SECOND_CHECK == true ] && [ $FIRST_CHECK == true ]; then
    echo "[NodeJS React Builder] Запускаю билд nginx"
    echo "[NodeJS React Builder] Останавливаю контейнеры"
    docker-compose -f ./docker-compose.build.yml down
    make down
    echo "[NodeJS React Builder] Удаляю предыдущую сборку"
    rm -rf prod/*
    echo "[NodeJS React Builder] Копирую новую сборку"
    cp -rf build/* prod/
    echo "[NodeJS React Builder] Запускаю контейнер nginx"
    docker-compose -f ./docker-compose.prod.yml up -d --build
    make ps
else
    echo "[NodeJS React Builder] Проверяю состояние production"
    make ps > logs.txt
    grep $PRODUCT_NAME logs.txt && FIRST_CHECK=true || FIRST_CHECK=false
    grep 'Up (healthy)' logs.txt && SECOND_CHECK=true || SECOND_CHECK=false
    grep 'HTTP/1.1 200 OK' logs.txt && THIRD_CHECK=true || THIRD_CHECK=false
    if [ $THIRD_CHECK == true ] && [ $SECOND_CHECK == true ] && [ $FIRST_CHECK == true ]; then
        echo "[NodeJS React Builder] Production-контейнер работает"
        make ps
    else
        make
        make ps
    fi
fi