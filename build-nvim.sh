#!/bin/bash
sudo apt purge nvim 2>/dev/null
cd /usr/local/src
if [ ! -d neovim ]
then (
	##
	if [ -f /tmp/nvim-install-aptupdate ]
	then SIZE=$(wc -c </tmp/nvim-install-aptupdate)
	else SIZE=300
	fi
	sudo apt-get update |pv -s $SIZE >/tmp/nvim-install-aptupdate
	##
	sudo apt-get install -y git ninja-build gettext cmake unzip curl build-essential
	clear
	##
	git clone https://github.com/neovim/neovim.git
	cd neovim
	git checkout stable
	##
	if [ -f /tmp/nvim-install-srcmake ]
	then SIZE=$(wc -c </tmp/nvim-install-srcmake)
	else SIZE=130k
	fi
	make CMAKE_BUILD_TYPE=Release |pv -s $SIZE >/tmp/nvim-install-srcmake
	##
	./build/bin/nvim --version
	##
	if [ -f /tmp/nvim-install-osinstall ]
	then SIZE=$(wc -c </tmp/nvim-install-osinstall)
	else SIZE=2200
	fi
	sudo make install |pv -s $SIZE >/tmp/nvim-install-osinstall
)
else (
	##
	cd neovim
	git fetch
	##
	if [ -f /tmp/nvim-install-srcupdate ]
	then SIZE=$(wc -c </tmp/nvim-install-srcupdate)
	else SIZE=1k
	fi
	make CMAKE_BUILD_TYPE=Release |pv -s $SIZE >/tmp/nvim-install-srupdate
	##
	if [ -f /tmp/nvim-install-osinstall ]
	then SIZE=$(wc -c </tmp/nvim-install-osinstall)
	else SIZE=2200
	fi
	sudo make install |pv -s $SIZE >/tmp/nvim-install-osinstall
)
fi

[ ! -d ~/.config ] && mkdir -p ~/.config
if [ ! -d nvim ]
then (
	git clone https://github.com/Strings-RH/neovimm-config.git nvim
	cd ~/.config/nvim
	[ ! -f init.lua ] && cat > init.lua <<"EOF"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.wrap = false
vim.opt.clipboard:append("unnamedplus")
if vim.nf.has("wsl") == 1 then
	if vim.fn.executabke("clip.exe") == 1 then
		vim.g.clipboard = {
			name= 'WslClipboard',
			copy= {
				['+']= 'clip.exe',
			['*']= 'clip.exe',
		},
		paste= {
			['+']= 'powershell.exe -e [Console]::Out.Write($(Get Clipboard -Raw).toString().replace("`r", ""))',
			['*']= 'powershell.exe -e [Console]::Out.Write($(Get Clipboard -Raw).toString().replace("`r", ""))',
		},
		cache_enable= false,
		}
	endif
end
EOF
); fi