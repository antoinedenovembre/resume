.PHONY: all with_image no_image clean

LATEXMK = latexmk -pdf -interaction=nonstopmode

all: with_image no_image

with_image:
	@echo "Building resume with headshot..."
	@cd with_image && $(LATEXMK) resume.tex
	@echo "Cleaning build files for with_image..."
	@cd with_image && $(LATEXMK) -c resume.tex

no_image:
	@echo "Building resume without headshot..."
	@cd no_image && $(LATEXMK) resume.tex
	@echo "Cleaning build files for no_image..."
	@cd no_image && $(LATEXMK) -c resume.tex

clean:
	@echo "Cleaning auxiliary files..."
	@cd with_image && $(LATEXMK) -c resume.tex
	@cd no_image && $(LATEXMK) -c resume.tex
	@echo "Done."

# This Makefile is used to compile the resume in both directories with and without a headshot.