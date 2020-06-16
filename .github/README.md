## cfg

---
### setup for new hosts

1. **clone this repo:**
   ```bash
   cd ~/ && git clone --bare git@github.com:takelley1/dotfiles.git $HOME/.cfg
   ```
   1. create alias:
       ```bash
       alias dot='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'       # Linux path
       alias dot='/usr/local/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME' # FreeBSD path
       ```
   1. checkout files:
      ```bash
      dot checkout master
      ```
   1. backup dotfiles that git will overwrite:
      ```bash
      cd ~/ && mkdir .cfg.bak && mv file1.txt file2.txt file3.txt -t cfg.bak
      ```
   1. configure git
      ```bash
      git config --global user.email "hxyz@protonmail.com"
      git config --global user.name "takelley1"
      git config push --set-upstream origin master
      ```

1. **clone scripts repo**
   ```bash
    git clone [repo-url]
    ```

1. **add e2guardian proxy cert to trust store:**
   ```bash
   sudo trust anchor --store /mnt/tank/share/documents/configuration/e2guardian/my_rootCA.crt
   ```
   1. open firefox and add this same cert again to the trusted CAs list

1. **install missing packages and remove unnecessary packages:**
   ```bash
   sudo pacman -Syu
   for i in $(cat ~/.config/new-hosts/packages-to-install.txt | grep -v "^#"); do sudo pacman -Syy --noconfirm ${i}; done

   for i in $(cat ~/.config/new-hosts/packages-to-remove.txt | grep -v "^#"); do sudo pacman -Ryy --noconfirm ${i}; done
   ```

1. **copy lightdm config:**
   ```bash
   sudo cp ~/.config/new-hosts/etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/
   ```
   1. for some reason, lightdm will use the configured background, then immediately change its
      background to a default one. to fix this, just rename the default background file it's
      changing to in `/usr/share/backgrounds`.

1. **copy global environment variables:**
   ```bash
   sudo cp ~/.config/new-hosts/etc/environment /etc/
   sudo cp ~/.config/new-hosts/etc/security/pam_env.conf /etc/security/
   ```
   1. snapd doesn't respect /etc/environment, so edit the service manually:
      ```bash
      sudo systemctl edit snapd.service
      ```
   1. add the following text:
      ```
      [Service]
      Environment=http_proxy=http://10.0.0.15:8080
      Environment=https_proxy=http://10.0.0.15:8080
      ```

1. **copy other config files:**
   ```bash
   # automatic hourly pacman updates
   sudo cp ~/.config/new-hosts/etc/cron.hourly/* /etc/cron.hourly/

   # daily system snapshots
   sudo cp ~/.config/new-hosts/etc/timeshift.json /etc/timeshift.json

   # add network share to fstab
   sudo cat ~/.config/new-hosts/etc/fstab >> /etc/fstab

   # Make default gateway the primary NTP server.
   sudo cp /etc/chrony.conf /etc/chrony.conf.bak && sudo cp ~/.config/new-hosts/etc/chrony.conf /etc/
   ```

1. **build the brightnessctl package for backlight control on laptops**
   ```bash
   cd ~/.config/brightnessctl/
   make install
   ```
   1. allow running as root without a password:
      ```bash
      sudo su && visudo
      ```
      - add the line `austin ALL=NOPASSWD: /bin/brightnessctl`

1. **create symlinks according to which config files you wish to use:**
   1. symlink alacritty.yml based on preferred alacritty font size:
      ```bash
      cd ~/.config/alacritty && ln -s alacritty-[font size].yml alacritty.yml
      ```
   1. symlink Xdefaults based on preferred urxvt font size:
      ```bash
      ln -s ~/.Xdefaults-[hostname] ~/.Xdefaults
      ```

1. **create modular i3 config file for new host:**
   ```bash
   nvim ~/.config/i3/config-unique-$(hostname)
   ```
   1. see https://faq.i3wm.org/question/1367/anyway-to-include-in-config-file/%3C/p%3E.html and ./xinitrc for more info

1. **change thunar theme to dark:**
   ```bash
   lxappearance
   ```

1. **clone NeoVim packages:**
   ```bash
   mkdir -p ~/.local/share/nvim/site/pack/git-plugins/start
   # ALE for bash script linting
   git clone --depth 1 https://github.com/dense-analysis/ale.git ~/.local/share/nvim/site/pack/git-plugins/start/ale
   git clone https://github.com/itchyny/lightline.vim ~/.local/share/nvim/site/pack/git-plugins/start/lightline
   git clone https://github.com/airblade/vim-gitgutter.git ~/.local/share/nvim/site/pack/git-plugins/start/vim-gitgutter
   ```

1. **set up Dell fan controls:**
   1. allow passwordless modprobe
      ```bash
      sudo su && visudo
      ```
      - add the line `austin ALL=NOPASSWD: usr/bin/modprobe`
   1. install i8k controller from AUR
      ```bash
      yay -S i8kutils
      ```

---
#### from https://www.atlassian.com/git/tutorials/dotfiles
### The best way to store your dotfiles: A bare Git repository

*Disclaimer: the title is slightly hyperbolic, there are other proven solutions to the problem. I do think the technique below is very elegant though.*

Recently I read about this amazing technique in an Hacker News thread on people's solutions to store their dotfiles. User StreakyCobra showed his elegant setup and ... It made so much sense! I am in the process of switching my own system to the same technique. The only pre-requisite is to install Git.

In his words the technique below requires:

No extra tooling, no symlinks, files are tracked on a version control system, you can use different branches for different computers, you can replicate you configuration easily on new installation.

The technique consists in storing a Git bare repository in a "side" folder (like $HOME/.cfg or $HOME/.myconfig) using a specially crafted alias so that commands are run against that repository and not the usual .git local folder, which would interfere with any other Git repositories around.
Starting from scratch

If you haven't been tracking your configurations in a Git repository before, you can start using this technique easily with these lines:

    git init --bare $HOME/.cfg
    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    config config --local status.showUntrackedFiles no
    echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc

The first line creates a folder ~/.cfg which is a Git bare repository that will track our files.
Then we create an alias config which we will use instead of the regular git when we want to interact with our configuration repository.

We set a flag - local to the repository - to hide files we are not explicitly tracking yet. This is so that when you type config status and other commands later, files you are not interested in tracking will not show up as untracked.
Also you can add the alias definition by hand to your .bashrc or use the the fourth line provided for convenience.

I packaged the above lines into a snippet up on Bitbucket and linked it from a short-url. So that you can set things up with:

    curl -Lks http://bit.do/cfg-init | /bin/bash

After you've executed the setup any file within the $HOME folder can be versioned with normal commands, replacing git with your newly created config alias, like:

    config status
    config add .vimrc
    config commit -m "Add vimrc"
    config add .bashrc
    config commit -m "Add bashrc"
    config push

Install your dotfiles onto a new system (or migrate to this setup)

If you already store your configuration/dotfiles in a Git repository, on a new system you can migrate to this setup with the following steps:

Prior to the installation make sure you have committed the alias to your .bashrc or .zsh:

    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

And that your source repository ignores the folder where you'll clone it, so that you don't create weird recursion problems:

    echo ".cfg" >> .gitignore

Now clone your dotfiles into a bare repository in a "dot" folder of your $HOME:

    git clone --bare <git-repo-url> $HOME/.cfg

Define the alias in the current shell scope:

    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

Checkout the actual content from the bare repository to your $HOME:

    config checkout

The step above might fail with a message like:

    error: The following untracked working tree files would be overwritten by checkout:
        .bashrc
        .gitignore
    Please move or remove them before you can switch branches.
    Aborting

This is because your $HOME folder might already have some stock configuration files which would be overwritten by Git. The solution is simple: back up the files if you care about them, remove them if you don't care. I provide you with a possible rough shortcut to move all the offending files automatically to a backup folder:

    mkdir -p .config-backup && \
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
    xargs -I{} mv {} .config-backup/{}

Re-run the check out if you had problems:

    config checkout

Set the flag 'showUntrackedFiles' to no on this specific (local) repository:

    config config --local status.showUntrackedFiles no

You're done, from now on you can now type config commands to add and update your dotfiles:

    config status
    config add .vimrc
    config commit -m "Add vimrc"
    config add .bashrc
    config commit -m "Add bashrc"
    config push

Again as a shortcut not to have to remember all these steps on any new machine you want to setup, you can create a simple script, store it as Bitbucket snippet like I did, create a short url for it and call it like this:

    curl -Lks http://bit.do/cfg-install | /bin/bash

For completeness this is what I ended up with (tested on many freshly minted Alpine Linux containers to test it out):

    git clone --bare https://bitbucket.org/durdn/cfg.git $HOME/.cfg
    function config {
       /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
    }
    mkdir -p .config-backup
    config checkout
    if [ $? = 0 ]; then
      echo "Checked out config.";
      else
        echo "Backing up pre-existing dot files.";
        config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
    fi;
    config checkout
    config config status.showUntrackedFiles no

#### Wrapping up

I hope you find this technique useful to track your configuration. If you're curious, my dotfiles live here. Also please do stay connected by following @durdn or my awesome team at @atlassiandev.
