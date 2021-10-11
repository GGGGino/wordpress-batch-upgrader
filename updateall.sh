#!/bin/bash

commit=false
branchToCommit=""
commitMessage="Updated core and plugin"
myUser=$(id -u -n)
myGroup=$(id -g -n)

while getopts 'cb:m:u:g:' arg
do
  case $arg in
    c)  # Check if I can commit the update
        commit=true
        ;;
    b)  # Get the branch where commit
        branchToCommit=$OPTARG
        ;;
    m)
        commitMessage=$OPTARG
        ;;
    u)
        myUser=$OPTARG
        ;;
    g)
        myGroup=$OPTARG
        ;;
  esac
done

for d in projects/*/
do
    FOLDER_NAME="$(basename "$d")"
    echo "Processing: ${FOLDER_NAME}"

    if [ "$commit" = true ]; then
        if [ ! -z "${branchToCommit}" ]; then
            git checkout -B $branchToCommit
        fi
    fi
    
    #docker-compose up -d $FOLDER_NAME

    #docker-compose exec $FOLDER_NAME /bin/wp-cli.phar --allow-root core update
    #docker-compose exec $FOLDER_NAME /bin/wp-cli.phar --allow-root core update-db
    #docker-compose exec $FOLDER_NAME /bin/wp-cli.phar --allow-root plugin update --all
    #docker-compose exec $FOLDER_NAME /bin/wp-cli.phar --allow-root theme update --all

    #docker-compose exec $FOLDER_NAME sudo chown -R $myUser:$myGroup

    if [ "$commit" = true ]; then
        git add .
        git commit -m "$commitMessage"
    fi

    #docker-compose stop $FOLDER_NAME
done