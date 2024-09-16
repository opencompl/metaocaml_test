# Compiler and flags
OCAMLOPT = metaocamlopt
OCAMLFLAGS = -c

# File extensions
SRC_EXT = ml
OBJ_EXT = o

# Source and object files
SOURCES = $(filter-out main.$(SRC_EXT), $(wildcard *.$(SRC_EXT)))
OBJECTS = $(SOURCES:.$(SRC_EXT)=.$(OBJ_EXT))

# Target to compile all .ml files to .o files
all: $(OBJECTS)

run: all
	metaocaml main.ml

# Rule to compile each .ml file to a .o file
%.$(OBJ_EXT): %.$(SRC_EXT)
	$(OCAMLOPT) $(OCAMLFLAGS) -o $@ $<

# Clean up the generated files
clean:
	rm -f *.$(OBJ_EXT) *.cmi *.cmx

.PHONY: all clean