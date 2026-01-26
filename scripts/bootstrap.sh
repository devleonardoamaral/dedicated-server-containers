#!/bin/bash

set -e

ls

DATA_DIR="$HOME/Zomboid"
INSTALL_DIR="$PWD"
DEFAULTS_DIR="$HOME/defaults"

source /root/lib/filetostrlib.sh
source /root/lib/steamcmdlib.sh
source /root/lib/stringlib.sh

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


install_mods () {
    echo "BOOTSTRAP: installing mods ..."

    echo "BOOTSTRAP: verifying 'mods.txt' ..."
    if [ ! -e "$DATA_DIR/mods.txt" ]; then
        touch "$DATA_DIR/mods.txt"
    fi

    echo "BOOTSTRAP: verifying 'workshopitems.txt' ..."
    if [ ! -e "$DATA_DIR/workshopitems.txt" ]; then
        touch "$DATA_DIR/workshopitems.txt"
    fi

    echo "BOOTSTRAP: verifying mods ..."
    CFG_FILE="$DATA_DIR/Server/servertest.ini"

    echo "BOOTSTRAP: updating mods ..."
    option_mods=""
    if [ -n "$(cat "$DATA_DIR/mods.txt")" ]; then
        option_mods="$(join_file_lines "$DATA_DIR/mods.txt" '\' "" ";")"
        option_mods="$(escape_sed_regex_chars "$option_mods")"
    fi
    echo "$option_mods"
    sed -r -i 's/^Mods=[^$]*/Mods='"$option_mods"'/g' "$CFG_FILE"

    echo "BOOTSTRAP: updating workshopitems ..."
    option_workshopitems=""
    if [ -n "$(cat "$DATA_DIR/workshopitems.txt")" ]; then
        option_workshopitems="$(join_file_lines "$DATA_DIR/workshopitems.txt" "" "" ";")"
        option_workshopitems="$(escape_sed_regex_chars "$option_workshopitems")"
    fi
    sed -r -i 's/^WorkshopItems=[^$]*/WorkshopItems='"$option_workshopitems"'/g' "$CFG_FILE"
}

install_steamcmd_app "380870" "$INSTALL_DIR" "unstable"
install_defaults
install_mods

echo "BOOTSTRAP: starting server ..."
$@

echo ""
echo "BOOTSTRAP: server exited with ($?)"
