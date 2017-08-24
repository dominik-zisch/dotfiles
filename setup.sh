#!/usr/bin/env bash


## Variables
scriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
oldDir=~/.dotfiles_old
homeDir=~

## Create dotfiles_old in homedir
echo -n "Creating $oldDir for backup of any existing dotfiles in ~"
mkdir -p $oldDir
echo " ...done."

# Move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in * .[^.]*; do

    cd $homeDir
    
    if [ $file != "README.md" ] && [ $file != "setup.sh" ] && [ $file != ".git" ]; then
        
        if [ -L ~/$file ]; then
            echo "Deleting existing symbolic link."
            rm ~/$file
        fi
        
        if [ -f ~/$file ]; then
            echo "Moving $file from ~ to $oldDir."
            mv ~/$file $oldDir
        fi
        
        echo "Creating symlink to $file in $homeDir/$file directory."
        ln -s $scriptPath/$file "$homeDir/$file"
        
    fi
    
    cd $scriptPath
    
done

echo "Done!"









