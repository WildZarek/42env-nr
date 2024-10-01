#!/bin/bash

COLOR_YELLOW="\e[33m"
COLOR_MAGENTA="\e[35m"
COLOR_CYAN="\e[36m"
COLOR_GREY="\e[90m"
COLOR_RED="\e[91m"
COLOR_GREEN="\e[92m"
COLOR_BLUE="\e[94m"
COLOR_WHITE="\e[97m"
COLOR_RESET="\e[0m"

banner() {
    echo -e "${COLOR_GREY}"
    cat << "EOF"

  ┌─────────────────────────────────────────────────────────────┐
  │       ██╗  ██╗██████╗     ███████╗███╗   ██╗██╗   ██╗       │
  │       ██║  ██║╚════██╗    ██╔════╝████╗  ██║██║   ██║       │
  │       ███████║ █████╔╝    █████╗  ██╔██╗ ██║██║   ██║       │
  │       ╚════██║██╔═══╝     ██╔══╝  ██║╚██╗██║╚██╗ ██╔╝       │
  │            ██║███████╗    ███████╗██║ ╚████║ ╚████╔╝        │
  │            ╚═╝╚══════╝    ╚══════╝╚═╝  ╚═══╝  ╚═══╝         │
  │                                     NO SUDO EDITION         │
  └─────────────────────────────────────────────────────────────┘
EOF
echo -e "${COLOR_RESET}${COLOR_WHITE}"
echo -e ">> 42ENV | 42 Environment Configuration Script"
echo ""
echo -e ">> Si te sirvió este script, dale '★ Star' en el repositorio. ¡Gracias!"
echo -e ">> ${COLOR_BLUE}https://github.com/WildZarek/42env-nr${COLOR_WHITE}"
echo -e ">> Basado en: ${COLOR_BLUE}https://github.com/WildZarek/42env${COLOR_RESET}"
echo ""
sleep 3
}

clear
banner

print_warning() {
    echo -ne "${COLOR_WHITE}[${COLOR_RED}!${COLOR_WHITE}] $1${COLOR_RESET}"
}

print_info() {
    echo -ne "${COLOR_WHITE}[${COLOR_CYAN}>${COLOR_WHITE}] $1${COLOR_RESET}"
}

print_installed() {
    echo -e "${COLOR_WHITE}[${COLOR_MAGENTA}i${COLOR_WHITE}] $1${COLOR_RESET}"
}

print_ok() {
    echo -e "${COLOR_GREEN}OK${COLOR_RESET}"
}

print_pass() {
    echo -e "${COLOR_BLUE}PASS${COLOR_RESET}"
}

print_error() {
    echo -e "${COLOR_RED}ERROR${COLOR_RESET}"
}

print_info "Escribe tu usuario de la Intra 42: ${COLOR_RESET}"
read USER
INTRAUSER="${USER}"

boost_zsh() {
    #Instalación de Oh-My-Zsh y plugins estilo fish
    OMZ_SH_FILE="$HOME/.oh-my-zsh/oh-my-zsh.sh"
    if [ ! -f $OMZ_SH_FILE ]; then
        print_info "Instalando ${COLOR_YELLOW}Oh-My-Zsh${COLOR_WHITE}..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1
        sleep 2
        # Doble validación por si no se instaló correctamente...
        if [ -f $OMZ_SH_FILE ]; then
            print_ok
        else
            print_warning "${COLOR_YELLOW}Oh-My-Zsh${COLOR_WHITE} no se instaló correctamente..."
            sleep 1
            print_pass
        fi
    else
        print_installed "Paquete ${COLOR_YELLOW}Oh-My-Zsh${COLOR_WHITE} ya está instalado."
    fi

    ZSH_PLUGIN1_PATH="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    if [ -d $ZSH ] && [ ! -d $ZSH_PLUGIN1_PATH ]; then
        print_info "Instalando plugin ${COLOR_YELLOW}zsh-autosuggestions${COLOR_WHITE}..."
        git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PLUGIN1_PATH > /dev/null 2>&1
        sleep 2
        print_ok
    else
        print_installed "Plugin ${COLOR_YELLOW}zsh-autosuggestions${COLOR_WHITE} ya está instalado."
    fi

    ZSH_PLUGIN2_PATH="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    if [ -d $ZSH ] && [ ! -d $ZSH_PLUGIN2_PATH ]; then
        print_info "Instalando plugin ${COLOR_YELLOW}zsh-syntax-highlighting${COLOR_WHITE}..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGIN2_PATH > /dev/null 2>&1
        sleep 2
        print_ok
    else
        print_installed "Plugin ${COLOR_YELLOW}zsh-syntax-highlighting${COLOR_WHITE} ya está instalado."
    fi

    ZSHRC_SRC="./files/.zshrc"
    ZSHRC_DEST="$HOME/.zshrc"
    ALIASES_FILE="./files/aliases.txt"
    if [ -f "$ZSHRC_SRC" ]; then
        if [ -f $ZSHRC_DEST ]; then
            print_info "Copiando el archivo de configuración ${COLOR_YELLOW}.zshrc${COLOR_WHITE}..."
            mv "$ZSHRC_DEST" "$HOME/.zshrc.pre-42env"
            cp "$ZSHRC_SRC" "$ZSHRC_DEST"
            sleep 2
            print_ok
            # Añadir los alias al .zshrc si el archivo ya existe y no existen otros alias definidos
            if ! grep -q "ALIASES" "$ZSHRC_DEST"; then
                print_info "Añadiendo los alias al archivo ${COLOR_YELLOW}.zshrc${COLOR_WHITE}..."
                cat "$ALIASES_FILE" >> "$ZSHRC_DEST"
                sleep 2
                print_ok
            else
                print_warning "Ya existen alias definidos. Cancelando configuración..."
                sleep 1
                print_pass
            fi
        fi
    else
        print_warning "No se encontró el archivo ${COLOR_YELLOW}.zshrc${COLOR_WHITE} en la ruta de origen..."
        sleep 1
        print_error
    fi
    42tools
}

42tools() {
    if ! pip3 show norminette &> /dev/null
    then
        print_info "${COLOR_YELLOW}norminette${COLOR_WHITE} no está instalada. Instalando..."
        pip3 install --user norminette > /dev/null 2>&1
        sleep 2
        print_ok
    else
        print_installed "${COLOR_YELLOW}norminette${COLOR_WHITE} ya está instalada."
    fi

    if ! pip3 show c-formatter-42 &> /dev/null
    then
        print_info "${COLOR_YELLOW}c-formatter-42${COLOR_WHITE} no está instalado. Instalando..."
        pip3 install --user c-formatter-42 > /dev/null 2>&1
        sleep 2
        print_ok
    else
        print_installed "${COLOR_YELLOW}c-formatter-42${COLOR_WHITE} ya está instalado."
    fi
}

nf_termux() {
    FONT_DIR="$HOME/.termux"
    print_info "Instalando la fuente ${COLOR_YELLOW}Hack Nerd Font${COLOR_WHITE}..."
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip -O Hack.zip
    unzip -q Hack.zip > /dev/null 2>&1
    mv HackNerdFontMono-Regular.ttf $FONT_DIR/font.ttf
    print_ok
    rm Hack.zip
    rm *.ttf
    termux-reload-settings
}

nf_linux() {
    FONT_DIR="$HOME/.local/share/fonts"
    FONT_NAME="Hack"
    if ! fc-list | grep -q "$FONT_NAME"; then
        print_info "Instalando la fuente ${COLOR_YELLOW}Hack Nerd Font${COLOR_WHITE}..."
        wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip -O /tmp/Hack.zip
        unzip -q /tmp/Hack.zip -d $FONT_DIR > /dev/null 2>&1
        fc-cache -f -v > /dev/null 2>&1
        print_ok
        rm /tmp/Hack.zip
    else
        print_installed "La fuente ${COLOR_YELLOW}Hack Nerd Font${COLOR_WHITE} ya está instalada."
    fi
}

nvim_linux() {
    # Descarga del AppImage de Nvim desde el repo oficial
    USR_BIN_DIR="$HOME/.local/bin"
    if command -v nvim > /dev/null 2>&1; then
        print_installed "${COLOR_YELLOW}NeoVim${COLOR_WHITE} ya está instalado."
    else
        print_info "Instalando ${COLOR_YELLOW}Neovim${COLOR_WHITE}..."
        wget -q https://github.com/neovim/neovim-releases/releases/download/v0.10.1/nvim.appimage -O $USR_BIN_DIR/nvim.appimage > /dev/null 2>&1
        sleep 2
        print_ok
    fi
}

# INSTALACIÓN EN TERMUX
if [ "$(uname -o)" = "Android" ]; then
    if [ -d "/data/data/com.termux" ]; then
        if [ "$(echo $TERMUX_VERSION)" ]; then
            print_info "Detectado ${COLOR_YELLOW}Termux v$(echo $TERMUX_VERSION)${COLOR_WHITE}..."
            sleep 1
            print_info "Actualizando el sistema..."
            pkg update && pkg upgrade -y > /dev/null 2>&1
            sleep 2
            print_ok
            print_info "Instalando paquetes necesarios..."
            pkg install curl wget git zsh unzip python lsd bat neovim xclip -y > /dev/null 2>&1
            sleep 2
            print_ok
        fi
        boost_zsh
        42tools
        nf_termux
    fi
else
# INSTALACIÓN EN LINUX
    if [ $(echo $SHELL | grep -o zsh) ]; then
        print_installed "La shell por defecto ya es ${COLOR_YELLOW}zsh${COLOR_WHITE}..."
        sleep 2
        print_pass
    else
        print_info "Configurando ${COLOR_YELLOW}zsh${COLOR_WHITE} como shell por defecto..."
        $F_ZSH=$(which zsh)
        [ -z "$ZSH_VERSION" ] && exec "$F_ZSH" -l
        sleep 2
        print_ok
    fi
    boost_zsh
    42tools
    nf_linux
    nvim_linux
fi

# Configuración de Neovim + Plugins
# Plugins Path: $HOME/.local/share/nvim/plugged
VIMPLUG_FILE="$HOME/.local/share/nvim/site/autoload/plug.vim"
if [ $(which nvim) ]; then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' > /dev/null 2>&1
    if [ -f $VIMPLUG_FILE ]; then
        print_info "Gestor de plugins ${COLOR_YELLOW}Vim-Plug${COLOR_WHITE} para NeoVim instalado..."
        sleep 1
        print_ok
    else
        print_warning "El gestor de plugins ${COLOR_YELLOW}Vim-Plug${COLOR_WHITE} para NeoVim no se instaló correctamente..."
        sleep 1
        print_error
    fi
else
    print_warning "${COLOR_YELLOW}NeoVim${COLOR_WHITE} no se instaló correctamente..."
    sleep 1
    print_error
fi

NVIM_SRC="./files/init.vim"
NVIM_DEST="$HOME/.config/nvim/lua"
NVIM_CFG_FILE="$NVIM_DEST/init.vim"
if [ -f $NVIM_SRC ]; then
    if [ ! -d $NVIM_DEST ]; then
        mkdir -p $NVIM_DEST
    else
        if [ ! -f $NVIM_CFG_FILE ]; then
            print_info "Copiando archivo ${COLOR_YELLOW}init.vim${COLOR_WHITE}..."
            cp "$NVIM_SRC" "$NVIM_CFG_FILE"
            sed -i "s/INTRAUSER/$INTRAUSER/g" "$NVIM_CFG_FILE"
            sleep 1
            print_ok
        else
            print_installed "Archivo ${COLOR_YELLOW}init.vim${COLOR_WHITE} ya existente. Cancelando copia..."
            sleep 1
            print_pass
            if [ ! $(grep -q "let g:user42" $NVIM_CFG_FILE) ] && [ ! $(grep -q "let g:mail42" $NVIM_CFG_FILE) ]; then
                print_info "Configurando variables para el header de 42..."
                echo -e "let g:user42 = '${INTRAUSER}'" >> $NVIM_CFG_FILE
                echo -e "let g:mail42 = '${INTRAUSER}@student.42malaga.com'" >> $NVIM_CFG_FILE
                sleep 1
                print_ok
            else
                print_installed "El usuario de la Intra 42 ya está configurado."
            fi
        fi
    fi
else
    print_warning "No se encontró el archivo ${COLOR_YELLOW}init.vim${COLOR_WHITE} en la ruta de origen..."
    sleep 1
    print_error
fi

KEYMAPS_LUA_SRC="./files/keymaps.lua"
KEYMAPS_LUA_DEST="$HOME/.config/nvim/lua/configs/"
if [ -f "$KEYMAPS_LUA_SRC" ]; then
    if [ -d $KEYMAPS_LUA_DEST ]; then
        print_info "Copiando archivo ${COLOR_YELLOW}keymaps.lua${COLOR_WHITE} al directorio de configuración de nvim..."
        cp "$KEYMAPS_LUA_SRC" "$KEYMAPS_LUA_DEST"
        sleep 1
        print_ok
    else
        print_warning "No se encontró el directorio 'configs' de nvim. Creando los directorios..."
        mkdir -p $KEYMAPS_LUA_DEST
        sleep 1
        print_ok
        print_info "Copiando archivo ${COLOR_YELLOW}keymaps.lua${COLOR_WHITE} al directorio de configuración de nvim..."
        cp "$KEYMAPS_LUA_SRC" "$KEYMAPS_LUA_DEST"
        sleep 1
        print_ok
    fi
else
    print_warning "No se encontró el archivo ${COLOR_YELLOW}keymaps.lua${COLOR_WHITE} en la ruta actual..."
    sleep 1
    print_error

echo ""

print_installed "Todos los programas necesarios han sido instalados."

print_info "Ejecuta 'nvim' (alias 'nv') y escribe ':PlugInstall' para que la configuración de Neovim se complete."

echo ""
echo ""