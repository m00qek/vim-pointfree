POINTFREE := $(shell pwd)
TOOLS   := $(POINTFREE)/tools

vim:
	@vim -u $(TOOLS)/init.vim --cmd "set rtp=$(POINTFREE)"

nvim:
	@nvim -u $(TOOLS)/init.vim --cmd "set rtp=$(POINTFREE)"
