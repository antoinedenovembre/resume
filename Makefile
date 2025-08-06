.PHONY: all en fr with_image no_image with_image_fr no_image_fr clean clean-all test

LATEXMK = latexmk -pdf -interaction=nonstopmode
BUILD_DIR = build
SRC_DIR = src

all: en fr

# Build English versions (both with and without image)
en: with_image no_image

# Build French versions (both with and without image)  
fr: with_image_fr no_image_fr

# Build resume with image using new modular structure
with_image:
	@echo "Building English resume with headshot..."
	@cd $(BUILD_DIR) && $(LATEXMK) resume_with_image.tex
	@echo "Cleaning build files..."
	@cd $(BUILD_DIR) && $(LATEXMK) -c resume_with_image.tex

# Build resume without image using new modular structure  
no_image:
	@echo "Building English resume without headshot..."
	@cd $(BUILD_DIR) && $(LATEXMK) resume_no_image.tex
	@echo "Cleaning build files..."
	@cd $(BUILD_DIR) && $(LATEXMK) -c resume_no_image.tex

# Build French resume with image
with_image_fr:
	@echo "Building French resume with headshot..."
	@cd $(BUILD_DIR) && $(LATEXMK) resume_with_image_fr.tex
	@echo "Cleaning build files..."
	@cd $(BUILD_DIR) && $(LATEXMK) -c resume_with_image_fr.tex

# Build French resume without image
no_image_fr:
	@echo "Building French resume without headshot..."
	@cd $(BUILD_DIR) && $(LATEXMK) resume_no_image_fr.tex
	@echo "Cleaning build files..."
	@cd $(BUILD_DIR) && $(LATEXMK) -c resume_no_image_fr.tex

# Clean auxiliary files
clean:
	@echo "Cleaning auxiliary files..."
	@cd $(BUILD_DIR) && $(LATEXMK) -c resume_with_image.tex 2>/dev/null || true
	@cd $(BUILD_DIR) && $(LATEXMK) -c resume_no_image.tex 2>/dev/null || true
	@cd $(BUILD_DIR) && $(LATEXMK) -c resume_with_image_fr.tex 2>/dev/null || true
	@cd $(BUILD_DIR) && $(LATEXMK) -c resume_no_image_fr.tex 2>/dev/null || true
	@echo "Removing synctex.gz files..."
	@rm -f $(BUILD_DIR)/*.synctex.gz
	@echo "Done."

# Clean all generated files including PDFs
clean-all: clean
	@echo "Cleaning all generated files..."
	@rm -f $(BUILD_DIR)/*.pdf
	@echo "Done."

