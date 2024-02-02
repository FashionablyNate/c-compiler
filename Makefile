# assembler command and flags
AS := as
DBGFLAGS := -g

# linker command and flags
LD = ld
LDFlags = -macos_version_min 14.0.0 -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _main -arch arm64

# where should stuff go?
OBJ_PATH := obj
DBG_PATH := $(OBJ_PATH)/debug
SRC_PATH := src
BIN_PATH := bin

# name the executables
TARGET := $(BIN_PATH)/main
TARGET_DEBUG := $(BIN_PATH)/debug

# where can I find the files?
SRC := $(foreach x, $(SRC_PATH), $(wildcard $(addprefix $(x)/*,.s*)))
OBJ := $(addprefix $(OBJ_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))
OBJ_DEBUG := $(addprefix $(DBG_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))
CLEAN_LIST := $(TARGET) \
			  $(TARGET_DEBUG) \
			  $(OBJ_PATH) \
			  $(DBG_PATH) \
			  $(BIN_PATH) 

# make commands
default: makedir all
debug: makedir dbg	

# how do I do a normal build?
$(TARGET): $(OBJ)
	$(LD) $(LDFlags) -o  $@ $(OBJ)
$(OBJ_PATH)/%.o: $(SRC_PATH)/%.s*
	$(AS) -o $@ $<

# how do I do a debug build?
$(DBG_PATH)/%.o: $(SRC_PATH)/%.s*
	$(AS) $(DBGFLAGS) -o $@ $<
$(TARGET_DEBUG): $(OBJ_DEBUG)
	$(LD) $(LDFlags) -o $@ $(OBJ_DEBUG)

# create directories
.PHONY: makedir
makedir:
	@mkdir -p $(OBJ_PATH) $(DBG_PATH) $(BIN_PATH)

# do a normal build
.PHONY: all
all: $(TARGET)

# do a debug build
.PHONY: dbg
debug: $(TARGET_DEBUG)

# clean the build
.PHONY: clean
clean:
	@echo CLEAN $(CLEAN_LIST)
	@rm -rf $(CLEAN_LIST)