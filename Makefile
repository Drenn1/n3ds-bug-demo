#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------
ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/ds_rules

export GAME_TITLE	:=	N3DS Touch Test
export GAME_SUBTITLE1	:= 
export GAME_SUBTITLE2	:= 
export GAME_ICON	:=	$(LIBNDS)/icon.bmp
export TARGET		:=	touchtest

# DSi stuff
TID = 00030004
GID = TEST


.PHONY: arm7/$(TARGET).elf arm9/$(TARGET).elf

#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
all: $(TARGET).nds $(TARGET).cia

#---------------------------------------------------------------------------------
$(TARGET).nds	:	arm9/$(TARGET).elf
	ndstool -7 $(LIBNDS)/default.elf -9 arm9/$(TARGET).elf -b $(GAME_ICON) "$(GAME_TITLE);$(GAME_SUBTITLE1);$(GAME_SUBTITLE2)" -h 0x200 -c $(TARGET).nds 
	@echo built ... $(notdir $@)

$(TARGET)_dsi.nds: arm9/$(TARGET).elf
	@ndstool -7 $(LIBNDS)/default.elf -9 arm9/$(TARGET).elf -b $(GAME_ICON) "$(GAME_TITLE);$(GAME_SUBTITLE1);$(GAME_SUBTITLE2)" -g $(GID) -u $(TID) -c $@
	@echo built ... $(notdir $@)

$(TARGET).cia: $(TARGET)_dsi.nds
	@make_cia --srl=$(TARGET)_dsi.nds
	@mv $(TARGET)_dsi.cia $(TARGET).cia

#---------------------------------------------------------------------------------
arm9/$(TARGET).elf:
	$(MAKE) -C arm9

#---------------------------------------------------------------------------------
clean:
	$(MAKE) -C arm9 clean
	rm -f $(TARGET).nds $(TARGET).dsi $(TARGET).cia $(TARGET).arm7 $(TARGET).arm9
