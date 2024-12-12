#!/bin/bash

LOG_FILE=""
ERROR_FILE=""

print_help() {
    echo "Доступные флаги
Флаги:
  -u, --users         Список пользователей и их домашних директорий.
  -p, --processes     Список процессов с PID.
  -h, --help          Вызов данной подсказки.
  -l PATH, --log PATH Переадресация логирования в отдельный файл.
  -e PATH, --errors PATH Переадресация логирования ошибок в отдельный файл."
    exit 0
}

list_users() {
    getent passwd | awk -F: '{print $1, $6}' | sort
}

list_processes() {
    ps -e --no-headers --sort pid -o pid,cmd
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -u|--users)
            list_users
            ;;
        -p|--processes)
            list_processes
            ;;
        -h|--help)
            print_help
            ;;
        -l|--log)
            LOG_FILE="$2"
            [[ -z "$LOG_FILE" ]] && { echo "Ошибки: Отсутствует путь для --log" >&2; exit 1; }
            exec >"$LOG_FILE"
            shift
            ;;
        -e|--errors)
            ERROR_FILE="$2"
            [[ -z "$ERROR_FILE" ]] && { echo "Ошибки: Отсутствует путь для --errors" >&2; exit 1; }
            exec 2>"$ERROR_FILE"
            shift
            ;;
        *)
            echo "Неизвестный аргумент: $1" >&2
            print_help
            ;;
    esac
    shift
done
