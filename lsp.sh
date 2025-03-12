#!/bin/bash

# golang
go install golang.org/x/tools/gopls@latest
brew upgrade golangci-lint
go install github.com/nametake/golangci-lint-langserver

# rust
brew upgrade rust-analyzer

# lua
brew upgrade lua-language-server

brew upgrade terraform-ls

# typescript
npm install -g typescript-language-server typescript

# HTML/CSS/JSON language servers extracted from vscode.
# https://github.com/hrsh7th/vscode-langservers-extracted
npm i -g vscode-langservers-extracted

npm i -g yaml-language-server

# java
brew upgrade jdtls

brew upgrade python-lsp-server
