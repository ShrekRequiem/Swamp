#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "Please run this script as root."
   return 1
fi

apt-get update -y
apt-get upgrade -y
apt-get install nala -y

username='shrekrequiem'

# Création de shrekrequiem
create_user() {

   # Check if the user already exists
   if id "$username" >/dev/null 2>&1; then
      echo "User $username already exists."
      return 0
   else
      useradd -m "$username"
   fi

   if [[ $username -ne 0 ]]; then
      echo ""
   exit 1
   fi


  # Generate SSH keys for the user
  sudo -u "$username" ssh-keygen -t rsa -N "" -f "/home/$username/.ssh/id_rsa"

  # Set proper ownership and permissions for .ssh directory
  chown -R "$username:$username" "/home/$username/.ssh"
  chmod 700 "/home/$username/.ssh"

  # Allow SSH access for the user
  sed -i -e '/AllowUsers/s/$/ '"$username"'/' /etc/ssh/sshd_config

  # Restart SSH service for changes to take effect
  if systemctl restart sshd >/dev/null 2>&1; then
    echo "User $username created successfully with SSH access."
  else
    echo "Failed to restart SSH service. Please manually restart."
  fi
}


# Installation des applications par apt
if command -v nala &> /dev/null
then
    echo "nala est installé"
else
    echo "nala n'est pas installé"
fi

apt_app_list=("zsh" "sudo" "curl" "build-essential" "cmake" "libssl-dev" "pkg-config" "ca-certificates")

#install_apt_apps() {
#   for app in "$@"; do
#       echo "Installation de '$app'..."
#       nala install "$app" -y
#       echo "Installation de '$app' réussie"
#   done
#}

install_apt_apps() {
    apps_to_install=""
    for app in "$@"; do
        echo "Adding '$app' to the installation list..."
        apps_to_install+=" $app"
    done

    echo "Installing apps: $apps_to_install"
    nala install "$apps_to_install" -y

    echo "Installation complete for all apps"
}

install_apt_apps "${apt_app_list[@]}"

# Installation des applications par cargo
curl https://sh.rustup.rs -sSf | sh
source /home/shrekrequiem/.bashrc

cargo install sccache
export RUSTC_WRAPPER="sccache cargo install {package}"

cargo_app_list=("zoxide" "bat" "starship" "zellij" "mprocs" "ripgrep" "gitui" "wiki-tui" "speedtest-rs" "oxker" "aichat" "diskonaut" "genact" "gping" "lsd" "navi" "bottom")

install_cargo_apps() {
  # Vérification de cargo
  if ! command -v cargo >/dev/null 2>&1; then
    echo "Cargo n'est pas installé"
    exit 1
  fi

  # Itération à travers la liste
  for app in "$@"; do
    echo "Installation de '$app'..."
    cargo install "$app"
    echo "Installation de '$app' réussie"
  done
}

install_cargo_apps "${cargo_app_list[@]}"

# Installation de zsh
if [ -x "$(command -v zsh)" ]; then
   # Change the default shell
   chsh -s "$(command -v zsh)" "$username"
   echo "Default shell changed to zsh for user $username."
else
   echo "Zsh is not installed on your system."
   exit 1
fi

# Installation de docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

docker_list=("docker-ce" "docker-ce-cli" "containerd.io" "docker-buildx-plugin" "docker-compose-plugin")
install_apt_apps "${docker_list[@]}"

# Installation de portal et croc
curl -sL portal.spatiumportae.com | bash
curl https://getcroc.schollz.com | bash

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"



# Installation des plugins zsh
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git /home/shrekrequiem/.oh-my-zsh/custom/plugins/you-should-use
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /home/shrekrequiem/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
git clone https://github.com/unixorn/warhol.plugin.zsh.git /home/shrekrequiem/.oh-my-zsh/custom/plugins/warhol
git clone https://github.com/zsh-users/zsh-history-substring-search /home/shrekrequiem/.oh-my-zsh/custom/plugins/zsh-history-substring-search
git clone https://github.com/marlonrichert/zsh-autocomplete.git /home/shrekrequiem/.oh-my-zsh/custom/plugins/zsh-autocomplete
git clone https://github.com/zsh-users/zsh-autosuggestions /home/shrekrequiem/.oh-my-zsh/custom/plugins/zsh-autosuggestions

export GITHUB_USERNAME="ShrekRequiem"
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME

~ via  v21.6.1
❯ cat scripts/bash/swamp_init.sh
#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "Please run this script as root."
   return 1
fi

apt-get update -y
apt-get upgrade -y
apt-get install nala -y

username='shrekrequiem'

# Création de shrekrequiem
create_user() {

   # Check if the user already exists
   if id "$username" >/dev/null 2>&1; then
      echo "User $username already exists."
      return 0
   else
      useradd -m "$username"
   fi

   if [[ $username -ne 0 ]]; then
      echo ""
   exit 1
   fi


  # Generate SSH keys for the user
  sudo -u "$username" ssh-keygen -t rsa -N "" -f "/home/$username/.ssh/id_rsa"

  # Set proper ownership and permissions for .ssh directory
  chown -R "$username:$username" "/home/$username/.ssh"
  chmod 700 "/home/$username/.ssh"

  # Allow SSH access for the user
  sed -i -e '/AllowUsers/s/$/ '"$username"'/' /etc/ssh/sshd_config

  # Restart SSH service for changes to take effect
  if systemctl restart sshd >/dev/null 2>&1; then
    echo "User $username created successfully with SSH access."
  else
    echo "Failed to restart SSH service. Please manually restart."
  fi
}


# Installation des applications par apt
if command -v nala &> /dev/null
then
    echo "nala est installé"
else
    echo "nala n'est pas installé"
fi

apt_app_list=("zsh" "sudo" "curl" "build-essential" "cmake" "libssl-dev" "pkg-config" "ca-certificates")

install_apt_apps() {
   for app in "$@"; do
       echo "Installation de '$app'..."
       nala install "$app" -y
       echo "Installation de '$app' réussie"
   done
}

install_apt_apps "${apt_app_list[@]}"

# Installation des applications par cargo
curl https://sh.rustup.rs -sSf | sh
source /home/shrekrequiem/.bashrc

cargo install sccache
export RUSTC_WRAPPER="sccache cargo install {package}"

cargo_app_list=("zoxide" "bat" "starship" "zellij" "mprocs" "ripgrep" "gitui" "wiki-tui" "speedtest-rs" "oxker" "aichat" "diskonaut" "genact" "gping" "lsd" "navi" "bottom")

install_cargo_apps() {
  # Vérification de cargo
  if ! command -v cargo >/dev/null 2>&1; then
    echo "Cargo n'est pas installé"
    exit 1
  fi

  # Itération à travers la liste
  for app in "$@"; do
    echo "Installation de '$app'..."
    cargo install "$app"
    echo "Installation de '$app' réussie"
  done
}

install_cargo_apps "${cargo_app_list[@]}"

# Installation de zsh
if [ -x "$(command -v zsh)" ]; then
   # Change the default shell
   chsh -s "$(command -v zsh)" "$username"
   echo "Default shell changed to zsh for user $username."
else
   echo "Zsh is not installed on your system."
   exit 1
fi

# Installation de docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

docker_list=("docker-ce" "docker-ce-cli" "containerd.io" "docker-buildx-plugin" "docker-compose-plugin")
install_apt_apps "${docker_list[@]}"

# Installation de portal et croc
curl -sL portal.spatiumportae.com | bash
curl https://getcroc.schollz.com | bash

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"



# Installation des plugins zsh
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git /home/shrekrequiem/.oh-my-zsh/custom/plugins/you-should-use
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git /home/shrekrequiem/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
git clone https://github.com/unixorn/warhol.plugin.zsh.git /home/shrekrequiem/.oh-my-zsh/custom/plugins/warhol
git clone https://github.com/zsh-users/zsh-history-substring-search /home/shrekrequiem/.oh-my-zsh/custom/plugins/zsh-history-substring-search
git clone https://github.com/marlonrichert/zsh-autocomplete.git /home/shrekrequiem/.oh-my-zsh/custom/plugins/zsh-autocomplete
git clone https://github.com/zsh-users/zsh-autosuggestions /home/shrekrequiem/.oh-my-zsh/custom/plugins/zsh-autosuggestions


# Installation des dotfiles
export GITHUB_USERNAME="ShrekRequiem"
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
