#!/bin/bash

install_steamcmd_app() {
    app_code="$1"
    install_dir="$2"
    branch=""

    if [ -n "$3" ]; then
        branch="-beta $3"
    fi

    attempts=1
    max_attempts=3
    while [ $attempts -le $max_attempts ]; do
        echo "BOOTSTRAP: installing steamcmd app. Attempt: $attempts / $max_attempts ..."
        if steamcmd +login anonymous +force_install_dir "$install_dir" +app_update $app_code validate $branch +quit; then
            echo "BOOTSTRAP: app successfully installed and validated."
            return 0
        else
            if [ $attempts -eq $max_attempts ]; then
                echo "BOOTSTRAP: CRITICAL steamcmd app installation failed. Aborting."
                return 1
            else
                echo "BOOTSTRAP: steamcmd app installation failed. Trying again..."
                attempts=$(( attempts + 1 ))
            fi
        fi
    done
}
