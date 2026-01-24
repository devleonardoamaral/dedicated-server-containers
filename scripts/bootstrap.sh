#!/bin/sh

set -e

DATA_DIR="$HOME/Zomboid"
INSTALL_DIR="$PWD"
DEFAULTS_DIR="$HOME/defaults"


install_server() {
    attempts=1
    max_attempts=3
    while [ $attempts -le $max_attempts ]; do
        echo "BOOTSTRAP: installing dedicated server. Attempt: $attempts / $max_attempts ..."
        if steamcmd +login anonymous +force_install_dir "$INSTALL_DIR" +app_update 380870 validate -beta unstable +quit; then
            echo "BOOTSTRAP: Dedicated server successfully installed and validated."
            return 0
        else
            if [ $attempts -eq $max_attempts ]; then
                echo "BOOTSTRAP: CRITICAL dedicated server installation failed. Aborting."
                return 1
            else
                echo "BOOTSTRAP: dedicated server installation failed. Trying again..."
                attempts=$(( attempts + 1 ))
            fi
        fi
    done
}

install_defaults() {
    # Install db with default admin account
    DB_DIR="$DATA_DIR/db"
    DB_FILE="$DB_DIR/servertest.db"
    if [ ! -e "$DB_FILE" ]; then
        echo "BOOTSTRAP: installing default database..."
        mkdir -p "$DB_DIR"
        cp "$DEFAULTS_DIR/servertest.db" "$DB_FILE"
    fi
    echo "BOOTSTRAP: database OK."

    # Install default configuration file
    SERVER_DIR="$DATA_DIR/Server"
    CFG_FILE="$DATA_DIR/Server/servertest.ini"
    if [ ! -e "$CFG_FILE" ]; then
        echo "BOOTSTRAP: installing default configuration file..."
        mkdir -p "$SERVER_DIR"
        cp "$DEFAULTS_DIR/servertest.ini" "$CFG_FILE"
    fi
    echo "BOOTSTRAP: configuration file OK."

    # Setup RCON with random password if it is not set
    if [ -z "$(sed -nr "s/^RCONPassword=[^\$]+/true/p" "$CFG_FILE")" ]; then
        echo "BOOTSTRAP: setting a random password to RCON..."
        rcon_pwd=$(head -c 16 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9')
        sed -i "s/RCONPassword=/RCONPassword=$rcon_pwd/g" "$CFG_FILE"
    else
        rcon_pwd=$(sed -nr "s/^RCONPassword=([^\$])/\1/p" "$CFG_FILE")
    fi
    echo "BOOTSTRAP: RCON password defined as '$rcon_pwd'."
}

install_server
install_defaults

$@
