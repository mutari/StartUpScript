#!/bin/bash
clear

echo "What is the name of your prodjekt?"
read NAME

echo "Do you whant to set up github repos? (yes|no)"
read REPO_ANSWER
if [[ REPO_ANSWER -eq "yes" ]]; then
    #checks if gh is installed
    dpkg -s gh &> /dev/null

    #$? - Status of the most recently executed foreground-pipeline (exit/return code)
    if [[ ! $? -eq 0 ]]; then
        echo "github CLI is not installed! do you whant to install gh (yes | no)"
        read ANSWER
        if [[ ANSWER -eq "yes" ]]; then
            echo "Installing packet"
            apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
            apt-add-repository https://cli.github.com/packages
            apt update
            apt install gh
        else
            echo "Script ended! you need to install gh to set up a github repos"
            exit 1
        fi
    fi
    echo "To sett up github repos you need to first login to github!"
    gh auth login
    if [[ $? -eq 0 ]]; then
        echo "Created github repo for $NAME"
        gh repo create $NAME --public
    else
        echo "You could not be logged in!"
        exit 1
    fi 
fi

echo "What kind of projekt do you want to set up? (express|symfony)"
read TYPE
if [[ TYPE -eq "express" ]]; then
    mkdir $NAME
    cd ./$NAME
    echo "Setting up node/express envirement!"
    dpkg -s nodejs &> /dev/null

    if [[ ! $? -eq 0 ]]; then
        echo "Nodejs is not installed! do you whant to install nodejs (yes|no)?"
        read ANSWER
        if [[ ANSWER -eq "yes" ]]; then
            echo "Installing nodejs ..."
            apt install nodejs
        else
            echo "Need nodejs! script terminated! ):"
            exit 1
        fi 
    fi

    npm init -y
    echo "Installing express ..."
    npm install express

    echo "Setting upp express start up file"
    cat > app.js << EOF
const express = require("express");
const app = express();
const port = process.env.PORT | 3000;

app.get('/', (req, res) => {
    res.send('hello wrold');
});

app.listen(port, err => {
    if(err) console.error(err);
    else console.log(`Server started and running on port: ${port}`)
});
EOF

    if [[ REPO_ANSWER -eq "yes" ]]; then
        echo "Do you whant to create initial commit to repo? (yes|no)"
        read ANSWER
        if [[ ANSWER -eq "yes" ]]; then
            cat > .gitignore << EOF
node_modules
EOF
            git add .
            git commit -m "Initial commit"
            git push --set-upstream origin master
        else
            echo "Oke! No commit!!  :("
        fi
    fi
    cd ../
else 

    if [[ REPO_ANSWER -eq "yes" ]]; then
        echo "Do you whant to create initial commit to repo? (yes|no)"
        read ANSWER
        if [[ ANSWER -eq "yes" ]]; then
            cat > README.md << EOF
# This is your new prodjekt
EOF
            git add .
            git commit -m "Initial commit"
            git push --set-upstream origin master
        else
            echo "Oke! No commit!!  :("
        fi
    fi

fi
