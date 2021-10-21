#!/bin/bash

projectsToInstall=
initializeGit=

while getopts 'p:u:t:n:p:e:g' arg
do
  case $arg in
    p)  # The project to install
        projectsToInstall="projects/${OPTARG}"
        ;;
    u)  # The url of the local project
        projectUrl=${OPTARG}
        ;;
    t)  # The title of the site
        projectTitle=${OPTARG}
        ;;
    n)  # The admin name
        adminName=${OPTARG}
        ;;
    p)  # The admin password
        adminPass=${OPTARG}
        ;;
    e)  # The admin email
        adminEmail=${OPTARG}
        ;;
    g)  # Initialize git
        initializeGit=${OPTARG}
        ;;
  esac
done

for d in $projectsToInstall
do
    FOLDER_NAME="$(basename "$d")"
    echo "Installing: ${FOLDER_NAME}"

    if [ "$initializeGit" = true ]; then
        cd $d
        git init
        cd ../..
    fi

    docker exec $FOLDER_NAME /bin/wp-cli.phar --allow-root core install \
        --url=$projectUrl \
        --title=$projectTitle \
        --admin_name=$adminName \
        --admin_password=$adminPass \
        --admin_email=$adminEmail

    if [ "$initializeGit" = true ]; then
        cd $d
        git commit -m "First commit"
        cd ../..
    fi
done