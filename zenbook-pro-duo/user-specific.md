# User specific setup

## My always installed programs

btop - system monitor

tldr - short explanation of frequently used commands

kitty - terminal emulator

    sudo dnf install btop tldr kitty

## Pass - password manager

### Importing existing passwords

First let's clone our password store git repository.

    cd ~
    sudo dnf install pass -y
    git clone {repo}.git .password-store

Now import our gpg keys assuming they are stored in ~/exported-keys

    cd exported-keys
    gpg --import private.pgp
    gpg --import public.pgp

    gpg --edit-key {gpg-key-id}
    gpg> trust
    Your decision? 5
    gpg> save

### Setting up a new password store

    sudo dnf install pass
    gpg --gen-key

    > Real name: {your name}
    > Email address: {your email}

    >> Passphrase: {this is your master password, make it memorable}

    # gpg -K   This will show you the key id and some extra info

    # If you wanna change the expiration date of your key
    gpg --edit-key {gpg-key-id}
    gpg> expire
    Key is valid for? {choose expiry time, 0 is never}
    gpg> save

    # Now we initialize the password store
    pass init {gpg-key-id}
    pass git init  # Turn password store into a git repo
    pass git remote add origin {git-url}  # Add git remote so you can save your passwords to cloud. Use private repos.
    pass git push origin main

    # To save your newly inserted/generated passwords
    pass git push

    # TLDR man
    pass                    shows all existing password names
         insert {name}      add existing password
         generate {name}    generate a new secure password
         find {name}        find passwords having name in them
         show {name}        show all info stored about name
         edit {name}        add metadata to name. First line is the actual password so leave it as is and add new info in new lines.
         grep {something}   grep metadata
         git {command}      manage pass git repo. Same commands as normal git.
         -c                 copy to clipboard instead of printing it out

## VS Code setup

    https://code.visualstudio.com/docs/setup/linux

## Github CLI

    https://github.com/cli/cli/blob/trunk/docs/install_linux.md

## Tmux customization

Install tmux if you dont have it already.

Install tmux package manager (tpm)

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    touch ~/.config/tmux/tmux.conf
    # Insert contents of tmux.conf from this repo to the newly created tmux.conf file
    tmux
    Ctrl+Space, I

## Powerline fonts

Download latest release from

    https://github.com/ryanoasis/nerd-fonts/tree/master?tab=readme-ov-file

Run

    ./install.sh {font name}

Then go to terminal settings and change the font.

## Customize Kitty

### Change font

    # Open kitty
    ctrl+shift+f2  # to open kitty conf
    # Change the following lines to choose your font
    font_family      monospace
    bold_font        auto
    italic_font      auto
    bold_italic_font auto

### Install theme

    THEME=https://raw.githubusercontent.com/dexpota/kitty-themes/master/themes/gruvbox_dark.conf
    wget "$THEME" -P ~/.config/kitty/kitty-themes/themes

    cd ~/.config/kitty
    ln -s ./kitty-themes/themes/gruvbox_dark.conf ~/.config/kitty/theme.conf

Add this line to kitty conf

    include ./theme.conf
