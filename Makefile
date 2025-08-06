.PHONY: all with_image no_image clean clean-all test

LATEXMK = latexmk -pdf -interaction=nonstopmode
BUILD_DIR = build
SRC_DIR = src

all: with_image no_image

# Build resume with image using new modular structure
with_image:
	@echo "Building resume with headshot (modular)..."
	@cd $(BUILD_DIR) && $(LATEXMK) resume_with_image.tex
	@echo "Cleaning build files..."
	@cd $(BUILD_DIR) && $(LATEXMK) -c resume_with_image.tex

# Build resume without image using new modular structure  
no_image:
	@echo "Building resume without headshot (modular)..."
	@cd $(BUILD_DIR) && $(LATEXMK) resume_no_image.tex
	@echo "Cleaning build files..."
	@cd $(BUILD_DIR) && $(LATEXMK) -c resume_no_image.tex

# Clean auxiliary files
clean:
	@echo "Cleaning auxiliary files..."
	@cd $(BUILD_DIR) && $(LATEXMK) -c resume_with_image.tex 2>/dev/null || true
	@cd $(BUILD_DIR) && $(LATEXMK) -c resume_no_image.tex 2>/dev/null || true
	@echo "Done."

# Clean all generated files including PDFs
clean-all: clean
	@echo "Cleaning all generated files..."
	@rm -f $(BUILD_DIR)/*.pdf
	@echo "Done."

