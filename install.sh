#!/bin/bash

projectsToInstall=
useGit=

while getopts 'p:u:t:n:w:e:g' arg
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
    w)  # The admin password
        adminPass=${OPTARG}
        ;;
    e)  # The admin email
        adminEmail=${OPTARG}
        ;;
    g)  # Initialize git
        useGit=${OPTARG}
        ;;
  esac
done

for d in $projectsToInstall
do
    FOLDER_NAME="$(basename "$d")"
    echo "Installing: ${FOLDER_NAME}"

    if [ "$useGit" = true ]; then
        cd $d
        echo "git init"
        git init
        cd ../..
    fi

    docker exec $FOLDER_NAME /bin/wp-cli.phar --allow-root core install \
        --url=$projectUrl \
        --title=$projectTitle \
        --admin_name=$adminName \
        --admin_password=$adminPass \
        --admin_email=$adminEmail

    if [ "$useGit" = true ]; then
        cd $d
        echo "Committing the installation"
        git commit -m "First commit"
        cd ../..
    fi

    echo ""
    echo -n "Starting theme name: "
    read -r baseThemeName

    # Install the base theme
    docker exec $FOLDER_NAME /bin/wp-cli.phar --allow-root theme install $baseThemeName

    if [ "$useGit" = true ]; then
        cd $d
        echo "Committing theme install"
        git add .
        git commit -m "Added base theme: $baseThemeName"
        cd ../..
    fi

    echo ""
    echo "Insert the name of the plugin to install(leave blank to skip this process)"
    echo "Most useful plugins are: wp-optimize wordpress-seo better-wp-security elementor pro-elements webp-converter-for-media"
    pluginToInstall='no'
    while [ ! -z "$pluginToInstall" ]
    do
        echo -n "Name of the plugin to install: "
        read -r pluginToInstall

        if [ -z "$pluginToInstall" ]
        then
            break;
        fi

        docker exec $FOLDER_NAME /bin/wp-cli.phar --allow-root plugin install $pluginToInstall
    done

    if [ "$useGit" = true ]; then
        cd $d
        echo "Committing plugin install"
        git add .
        git commit -m "Added plugins"
        cd ../..
    fi

    # wp-optimize - cache e tabelle, wordpress-seo - seo, better-wp-security antibruteforce, 
    # elementor pro-elements - plugin del tema, webp-converter-for-media
    # 

done