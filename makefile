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
PDF_NAME = output# Name of the compiled pdf
ENGINE = pdflatex# PDF engine (values are pdflatex or xelatex)
HIGHLIGHT = breezedark# run pandoc --list-highlight-styles so see the full list
MARKDOWN_PATH = markdown
COVER_PATH = cover
STRUCTURE_PATH = .

# MAKE VARS (DON'T EDIT THEM!)
PDF = $(addsuffix .pdf, $(PDF_NAME))
BODY = $(addsuffix _without_cover.pdf, $(PDF_NAME))
COVER = $(wildcard $(addprefix $(COVER_PATH)/, *.pdf))
SOURCE = $(wildcard $(addprefix $(MARKDOWN_PATH)/, *.md))
STRUCTURE = $(wildcard $(addprefix $(STRUCTURE_PATH)/, *.tex))
FLAGS = --pdf-engine=pdflatex --toc -N --highlight-style breezedark -V colorlinks -V toccolor=Red
# More info about FLAGS -> https://jdhao.github.io/2019/05/30/markdown2pdf_pandoc/

# RULES
default: $(PDF)
	@echo 'Done!'

no-cover: $(BODY)
	@echo 'Generated PDF without cover'

clean:
	@echo -e "Cleaning files..."
	@rm -f $(PDF) $(BODY)

gen_dirs:
	@mkdir -p $(MARKDOWN_PATH) $(COVER_PATH) $(STRUCTURE_PATH)

$(PDF): $(COVER) $(BODY)
	@echo "Compiling done."
	@echo -e "Generating PDF with name $@..."
	@pdfunite $^ $@

$(BODY): $(SOURCE) $(STRUCTURE)
	@echo -e "Compiling markdown files:\n\t$<"
	@pandoc $(FLAGS) -H $(STRUCTURE) -s $< -o $@

