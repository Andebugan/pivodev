#!/bin/bash

function describe.web() {
    echo -e "${YELLOW}web${RESET} ${LIGHT_GRAY}- npm + typescript + lsp's for http, css, js, ts${RESET}"
}

function install.web() {
    sudo apt install npm -y

    sudo npm install -g gulp
    sudo npm install -g typescript
}

