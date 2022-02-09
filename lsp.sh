#!/bin/bash

go install golang.org/x/tools/gopls@latest

brew upgrade rust-analyzer
brew upgrade golangci-lint
go install github.com/nametake/golangci-lint-langserver

npm install --save typescript
npm install -g typescript-language-server
