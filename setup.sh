#!/usr/bin/env bash

# TODO:
#  - add OSX functionality


## Variables
scriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
oldDir=~/.dotfiles_old

## Create dotfiles_old in homedir
echo -n "Creating $oldDir for backup of any existing dotfiles in ~"
mkdir -p $oldDir
echo " ...done."

# Move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in * .[^.]*; do

    cd $HOME
    
    if [ $file != "README.md" ] && [ $file != "setup.sh" ] && [ $file != ".git" ]; then
        
        if [ -L "$HOME/.$file" ]; then
            echo "Deleting existing symbolic link."
            rm "$HOME/.$file"
        fi
        
        if [ -f "$HOME/.$file" ]; then
            echo "Moving $file from ~ to $oldDir."
            mv "$HOME/.$file" $oldDir
        fi
        
        echo "Creating symlink to $file in ~/.$file directory."
        ln -s $scriptPath/$file "$HOME/.$file"
        
    fi
    
    cd $scriptPath
    
done

echo "Done!"









