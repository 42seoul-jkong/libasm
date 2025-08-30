# **************************************************************************** #
#                                                                              #
#      __  __       _         __ _ _                   :::      ::::::::       #
#     |  \/  |     | |       / _(_) |                :+:      :+:    :+:       #
#     | \  / | __ _| | _____| |_ _| | ___          +:+ +:+         +:+         #
#     | |\/| |/ _` | |/ / _ \  _| | |/ _ \       +#+  +:+       +#+            #
#     | |  | | (_| |   <  __/ | | | |  __/     +#+#+#+#+#+   +#+               #
#     |_|  |_|\__,_|_|\_\___|_| |_|_|\___|          #+#    #+#                 #
#                                                  ###   ########   seoul.kr   #
#                                                                              #
# **************************************************************************** #

.SUFFIXES: .s .h
.PHONY: all clean fclean re bonus

AS = nasm
AR = ar
RM = rm -f

TARGET = libasm.a
OBJECTS_DIR = obj/

SOURCES += ft_strlen.s \
			ft_strcpy.s \
			ft_strcmp.s \
			ft_write.s \
			ft_read.s \
			ft_strdup.s

OBJECTS = $(addprefix $(OBJECTS_DIR), $(SOURCES:.s=.o))

ASFLAGS += -MD $(@:.o=.d)

AS_WARNING_FLAGS = werror=all
ASFLAGS += $(addprefix -, $(AS_WARNING_FLAGS))

ifdef DEBUG
	AS_CONFIG_FLAGS += g O0
endif

ASFLAGS += $(addprefix -, $(AS_CONFIG_FLAGS))

ARFLAGS += -sc

TARGET_MACH = -f elf64

all: $(TARGET)
clean:				;	$(RM) -r $(OBJECTS_DIR)
fclean: clean		;	$(RM) $(TARGET)
re: fclean			;	$(MAKE) all

$(OBJECTS_DIR):
	mkdir -p $(OBJECTS_DIR)

$(OBJECTS_DIR)%.o: %.s | $(OBJECTS_DIR)
	$(COMPILE.s) $< -o $@

$(TARGET): $(OBJECTS)
	$(AR) $(ARFLAGS) $@ $?

-include $(OBJECTS:.o=.d)
