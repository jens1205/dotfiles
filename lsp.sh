#!/bin/bash

go install golang.org/x/tools/gopls@latest

brew upgrade rust-analyzer

npm install --save typescript
npm install -g typescript-language-server
