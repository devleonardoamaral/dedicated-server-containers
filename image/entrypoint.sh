#!/bin/bash

cluster_name="${CLUSTER_NAME}"
steamcmd_dir="$HOME/.steam/steam/steamcmd"
install_dir="$HOME/.steam/steam/steamapps/common/Don't Starve Together Dedicated Server"
dontstarve_dir="$HOME/.klei/DoNotStarveTogether/"

cluster_dir="/$dontstarve_dir/$cluster_name"


if [ ! -d  "$cluster_dir" ]; then
    mkdir -p $cluster_dir
fi

cp -rf /servercfg/* $cluster_dir
echo "${KLEI_TOKEN}" > $cluster_dir/cluster_token.txt

function fail()
{
	echo Error: "$@" >&2
	exit 1
}

function check_for_file()
{
	if [ ! -e "$1" ]; then
		fail "Missing file: $1"
	fi
}

cd "$steamcmd_dir" || fail "Missing $steamcmd_dir directory!"

check_for_file "steamcmd.sh"
check_for_file "$dontstarve_dir/$cluster_name/cluster.ini"
check_for_file "$dontstarve_dir/$cluster_name/cluster_token.txt"
check_for_file "$dontstarve_dir/$cluster_name/Master/server.ini"
check_for_file "$dontstarve_dir/$cluster_name/Caves/server.ini"

check_for_file "$install_dir/bin64"

cd "$install_dir/bin64" || fail

run_shared=(./dontstarve_dedicated_server_nullrenderer_x64)
run_shared+=(-console)
run_shared+=(-cluster "$cluster_name")
# run_shared+=(-monitor_parent_process $$)

if [ "${SERVER_TYPE}" == "Caves" ]; then
    exec "${run_shared[@]}" -shard Caves  | sed 's/^/Caves:  /'
elif [ "${SERVER_TYPE}" == "Master" ]; then
    exec "${run_shared[@]}" -shard Master | sed 's/^/Master: /'
else
    echo "Error: invalid SERVER_TYPE"
    exit 1
fi
