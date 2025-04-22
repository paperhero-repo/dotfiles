function nv
	nohup neovide $argv >~/.neovide.log 2>&1 &
	disown
end
