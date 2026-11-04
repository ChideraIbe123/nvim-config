#!/usr/bin/env bash
# One-shot setup for this Neovim config on Ubuntu/Debian.
# Usage:  bash vm-setup.sh        (run from anywhere; re-runnable)
set -euo pipefail

REPO="https://github.com/ChideraIbe123/nvim-config"
ARCH="$(uname -m)"; case "$ARCH" in x86_64) NV=nvim-linux-x86_64;; aarch64|arm64) NV=nvim-linux-arm64;; *) echo "unsupported arch $ARCH"; exit 1;; esac

echo "==> 1/6 system packages"
sudo apt-get update -qq
sudo apt-get install -y -qq git curl build-essential ripgrep fd-find fzf unzip \
  nodejs npm python3 python3-venv python3-pip imagemagick ghostscript clangd

# Ubuntu's ImageMagick policy may block PDF rendering; allow read/write for PDF.
for pol in /etc/ImageMagick-6/policy.xml /etc/ImageMagick-7/policy.xml; do
  [ -f "$pol" ] && sudo sed -i -E 's#rights="none" pattern="PDF"#rights="read|write" pattern="PDF"#' "$pol"
done

echo "==> 2/6 neovim (latest release tarball; apt's is too old for LazyVim)"
curl -fsSLo /tmp/$NV.tar.gz "https://github.com/neovim/neovim/releases/latest/download/$NV.tar.gz"
sudo rm -rf /opt/$NV && sudo tar -C /opt -xzf /tmp/$NV.tar.gz
grep -q "/opt/$NV/bin" ~/.bashrc || echo "export PATH=/opt/$NV/bin:\$PATH" >> ~/.bashrc
export PATH=/opt/$NV/bin:$PATH
mkdir -p ~/.local/bin
[ -e ~/.local/bin/fd ] || ln -s "$(command -v fdfind)" ~/.local/bin/fd
grep -q '.local/bin' ~/.bashrc || echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
export PATH=$HOME/.local/bin:$PATH
nvim --version | head -1

echo "==> 3/6 tree-sitter cli"
sudo npm install -g --silent tree-sitter-cli

echo "==> 4/6 config"
if [ -d ~/.config/nvim/.git ]; then git -C ~/.config/nvim pull --ff-only
else [ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak.$(date +%s); git clone "$REPO" ~/.config/nvim; fi

echo "==> 5/6 python env for notebooks (path the config expects)"
[ -x ~/.local/share/nvim/venv/bin/python ] || python3 -m venv ~/.local/share/nvim/venv
~/.local/share/nvim/venv/bin/pip install -q --upgrade pip pynvim jupyter_client jupytext nbformat ipykernel matplotlib pillow
~/.local/share/nvim/venv/bin/python -m ipykernel install --user --name python3 --display-name "Python 3 (nvim)" >/dev/null

echo "==> 6/6 plugins, parsers, remote plugins (headless)"
nvim --headless "+Lazy! restore" +qa
nvim --headless "+UpdateRemotePlugins" +qa
nvim --headless -c "lua require('nvim-treesitter').install({'bash','c','cpp','cmake','diff','dockerfile','html','javascript','jsdoc','json','json5','jsonc','lua','luadoc','luap','markdown','markdown_inline','printf','python','query','regex','toml','tsx','typescript','vim','vimdoc','xml','yaml','git_config','gitcommit','git_rebase','gitignore','gitattributes','latex','ninja','rst'}, {summary=true}):wait(900000)" -c "qa"

echo
echo "Done. Open a new shell (or: source ~/.bashrc), run 'nvim', then ':LazyHealth'."
echo "Mason installs the language servers in the background on first launch."
