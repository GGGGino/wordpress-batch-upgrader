#!/bin/bash

commit=false
branchToCommit=""
commitMessage="Updated core and plugin"
myUser=$(id -u -n)
myGroup=$(id -g -n)
projectsToUpdate=projects/*/

while getopts 'cb:m:u:g:p:e:' arg
do
  case $arg in
    c)  # Check if I can commit the update
        commit=true
        ;;
    b)  # Get the branch where execute commit
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
    p)
        projectsToUpdate="projects/${OPTARG}"
        ;;
    e)
        myGroup=$OPTARG
        ;;
  esac
done

for d in $projectsToUpdate
do
    FOLDER_NAME="$(basename "$d")"
    echo "Processing: ${FOLDER_NAME}"

    if [ "$commit" = true ]; then
        if [ ! -z "${branchToCommit}" ]; then
            cd $d
            git checkout -B $branchToCommit
            cd ../..
        fi
    fi

    docker exec $FOLDER_NAME /bin/wp-cli.phar --allow-root core update
    docker exec $FOLDER_NAME /bin/wp-cli.phar --allow-root core update-db
    docker exec $FOLDER_NAME /bin/wp-cli.phar --allow-root plugin update --all
    # docker-compose exec $FOLDER_NAME /bin/wp-cli.phar --allow-root theme update --all

    sudo chown -R $myUser:$myGroup $d

    if [ "$commit" = true ]; then
        cd $d
        git add .
        git commit -m "$commitMessage"
        cd ../..
    fi
done