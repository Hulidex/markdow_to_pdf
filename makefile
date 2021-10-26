# Author: Jolu Izquierdo alias Hulidex
#
# INFO: Compile Markdown files to a single beautiful PDF
#
# USAGE: $ make [no-cover] [-e <USER VARS>=<VALUE>]
#
# Prerequisites:
#
#   - You must have installed the following packages:
#     * poppler
#     * pandoc
#
#   - A TEX distribution like 'TeX Live' or 'MikTeX' or 'MacTeX'

# USER VARS (You can edit them if you want)
OUT_NAME 	= final# Name of the compiled pdf
ENGINE 		= xelatex# PDF engine (values are pdflatex or xelatex)
HIGHLIGHT 	= breezedark# run pandoc --list-highlight-styles so see the full list
TOC_COLOR 	= black# Table of content color

# PATHS
COVER_PATH 		= markdown/cover#Relative Path to the cover
STRUCTURE_PATH 	= .#Relative Path to the intermediate latex structure config
MARKDOWN_PATH 	= markdown/src#Relative Path to the markdown files
OUTPUT_PATH 	= markdown/out#Relative Path to 

# MAKE VARS (DON'T EDIT THEM!)
PDF			= $(addprefix $(OUTPUT_PATH)/, $(addsuffix .pdf, $(OUT_NAME)))
DOCX		= $(addprefix $(OUTPUT_PATH)/, $(addsuffix .docx, $(OUT_NAME)))
BODY		= $(addprefix $(OUTPUT_PATH)/, $(OUT_NAME))
COVER		= $(wildcard $(addprefix $(COVER_PATH)/, *.pdf))
SOURCE		= $(wildcard $(addprefix $(MARKDOWN_PATH)/, *.md))
STRUCTURE	= $(wildcard $(addprefix $(STRUCTURE_PATH)/, *.tex))
FLAGS 		= --pdf-engine=$(ENGINE) --toc -N --highlight-style $(HIGHLIGHT) -V colorlinks -V toccolor=$(TOC_COLOR)
# More info about FLAGS -> https://jdhao.github.io/2019/05/30/markdown2pdf_pandoc/

# RULES
default: clean pdf docx
	@echo 'Done!'

no-cover: $(BODY)
	@echo 'Generated PDF without cover'

clean:
	@echo -e "Cleaning files..."
	@rm -f $(OUTPUT_PATH)/*

gen_dirs:
	@mkdir -p $(MARKDOWN_PATH) $(COVER_PATH) $(STRUCTURE_PATH) $(OUTPUT_PATH)

pdf: $(COVER) $(BODY).pdf
	@echo -e "Generating PDF with name $(BODY)_with_cover.pdf..."
	@pdfunite $^ $(BODY)_with_cover.pdf

docx: $(BODY).docx
	@echo -e "Generating DOCX with name $<..."

$(BODY).pdf $(BODY).docx: $(SOURCE) $(STRUCTURE)
	@echo -e "Compiling markdown files:\n\t$<\nTo Create the output file:\n\t$@\n"
	@pandoc $(FLAGS) -H $(STRUCTURE) -s $< -o $@
	@echo "Compiling done."

