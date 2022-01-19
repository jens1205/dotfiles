#!/bin/bash

go install golang.org/x/tools/gopls@latest

brew upgrade rust-analyzer
brew upgrade golangci-lint
go get github.com/nametake/golangci-lint-langserver

npm install --save typescript
npm install -g typescript-language-server
