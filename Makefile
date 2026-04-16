# ===== Pretty, quiet LaTeX CV Makefile =====
.PHONY: all en fr with_image_en no_image_en with_image_fr no_image_fr generate clean clean-all re test logs tail-%

# ===== Project =====
NAME        = resume
BUILD_DIR   = build
LOG_DIR     := $(abspath $(BUILD_DIR)/logs)

# All doc basenames (without .tex/.pdf)
DOCS        = resume_with_image_en \
              resume_no_image_en  \
              resume_with_image_fr \
              resume_no_image_fr

PDFS        = $(addprefix $(BUILD_DIR)/,$(addsuffix .pdf,$(DOCS)))

# ===== Colors =====
BLACK        = \033[0;30m
RED          = \033[0;31m
GREEN        = \033[0;32m
ORANGE       = \033[0;33m
BLUE         = \033[0;34m
PURPLE       = \033[0;35m
CYAN         = \033[0;36m
LIGHT_GRAY   = \033[0;37m
DARK_GRAY    = \033[1;30m
LIGHT_RED    = \033[1;31m
LIGHT_GREEN  = \033[1;32m
YELLOW       = \033[1;33m
LIGHT_BLUE   = \033[1;34m
LIGHT_PURPLE = \033[1;35m
LIGHT_CYAN   = \033[1;36m
WHITE        = \033[1;37m
RESET        = \033[0m

# ===== Toolchain =====
LATEXMK     = latexmk
LATEX_FLAGS = -pdf -interaction=nonstopmode -silent
PYTHON      = python3

# ===== Data & generated content =====
DATA_FILE    = data/resume.yml
PERSONAL_TEX = src/content/personal.tex
CONTENT_EN   = src/content/resume_content_en.tex
CONTENT_FR   = src/content/resume_content_fr.tex

# ===== Source dependencies =====
COMMON_SOURCES = src/config/packages.tex \
                 src/config/style.tex \
                 src/config/commands.tex \
                 $(PERSONAL_TEX)

FR_SOURCES = $(COMMON_SOURCES) $(CONTENT_FR)
EN_SOURCES = $(COMMON_SOURCES) $(CONTENT_EN)

WITH_IMAGE_SOURCES = src/layout/header_with_image.tex
NO_IMAGE_SOURCES = src/layout/header_no_image.tex

# ===== Default targets =====
all: en fr

# Grouped builds
en: $(BUILD_DIR)/resume_with_image_en.pdf $(BUILD_DIR)/resume_no_image_en.pdf
	@printf "$(BLUE)$(NAME): $(GREEN)English resumes built [√]$(RESET)\n"

fr: $(BUILD_DIR)/resume_with_image_fr.pdf $(BUILD_DIR)/resume_no_image_fr.pdf
	@printf "$(BLUE)$(NAME): $(GREEN)French resumes built [√]$(RESET)\n"

# Friendly aliases
with_image_en:  $(BUILD_DIR)/resume_with_image_en.pdf
no_image_en:    $(BUILD_DIR)/resume_no_image_en.pdf
with_image_fr:  $(BUILD_DIR)/resume_with_image_fr.pdf
no_image_fr:    $(BUILD_DIR)/resume_no_image_fr.pdf

# ===== Content generation: YAML → LaTeX =====
generate: $(PERSONAL_TEX) $(CONTENT_EN) $(CONTENT_FR)
	@printf "$(BLUE)$(NAME): $(GREEN)LaTeX content generated [√]$(RESET)\n"

$(PERSONAL_TEX): $(DATA_FILE) scripts/generate_tex.py
	@printf "\033[2K\r$(BLUE)$(NAME): $(PURPLE)$(DATA_FILE) → $(PERSONAL_TEX)$(RESET)"
	@$(PYTHON) scripts/generate_tex.py $(DATA_FILE) $(PERSONAL_TEX) personal
	@printf "\033[2K\r$(BLUE)$(NAME): $(GREEN)Generated → $(PERSONAL_TEX) [√]$(RESET)\n"

$(CONTENT_EN): $(DATA_FILE) scripts/generate_tex.py
	@printf "\033[2K\r$(BLUE)$(NAME): $(PURPLE)$(DATA_FILE) → $(CONTENT_EN)$(RESET)"
	@$(PYTHON) scripts/generate_tex.py $(DATA_FILE) $(CONTENT_EN) en
	@printf "\033[2K\r$(BLUE)$(NAME): $(GREEN)Generated → $(CONTENT_EN) [√]$(RESET)\n"

$(CONTENT_FR): $(DATA_FILE) scripts/generate_tex.py
	@printf "\033[2K\r$(BLUE)$(NAME): $(PURPLE)$(DATA_FILE) → $(CONTENT_FR)$(RESET)"
	@$(PYTHON) scripts/generate_tex.py $(DATA_FILE) $(CONTENT_FR) fr
	@printf "\033[2K\r$(BLUE)$(NAME): $(GREEN)Generated → $(CONTENT_FR) [√]$(RESET)\n"

# ===== Compile rule macro =====
# Usage: $(eval $(call compile_rule,<variant>,<sources>))
define compile_rule
$(BUILD_DIR)/resume_$(1).pdf: $(BUILD_DIR)/resume_$(1).tex $(2) | $(BUILD_DIR) $(LOG_DIR)
	@printf "\033[2K\r$(BLUE)$(NAME): $(PURPLE)resume_$(1).tex → resume_$(1).pdf$(RESET)"
	@cd $(BUILD_DIR) && $(LATEXMK) $(LATEX_FLAGS) resume_$(1).tex > "$(LOG_DIR)/resume_$(1).log" 2>&1
	@cd $(BUILD_DIR) && $(LATEXMK) -c resume_$(1).tex > /dev/null 2>&1
	@printf "\033[2K\r$(BLUE)$(NAME): $(GREEN)Built → $$@ [√]$(RESET)\n"
endef

$(eval $(call compile_rule,with_image_en,$(EN_SOURCES) $(WITH_IMAGE_SOURCES)))
$(eval $(call compile_rule,no_image_en,$(EN_SOURCES) $(NO_IMAGE_SOURCES)))
$(eval $(call compile_rule,with_image_fr,$(FR_SOURCES) $(WITH_IMAGE_SOURCES)))
$(eval $(call compile_rule,no_image_fr,$(FR_SOURCES) $(NO_IMAGE_SOURCES)))

# Ensure dirs exist
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)
	@printf "$(BLUE)$(NAME): $(GREEN)Ensured $(BUILD_DIR)/ exists$(RESET)\n"

$(LOG_DIR):
	@mkdir -p $(LOG_DIR)

# ===== Cleaning =====
clean:
	@printf "$(BLUE)$(NAME): $(YELLOW)Cleaning auxiliary files$(RESET)\n"
	@cd $(BUILD_DIR) 2>/dev/null && for f in $(DOCS); do \
		$(LATEXMK) -c $$f.tex >/dev/null 2>&1 || true ; \
	done || true
	@rm -f $(BUILD_DIR)/*.synctex.gz
	@printf "$(BLUE)$(NAME): $(GREEN)Done.$(RESET)\n"

clean-all: clean
	@printf "$(BLUE)$(NAME): $(YELLOW)Removing PDFs and generated content$(RESET)\n"
	@rm -f $(BUILD_DIR)/*.pdf
	@rm -f $(PERSONAL_TEX) $(CONTENT_EN) $(CONTENT_FR)
	@printf "$(BLUE)$(NAME): $(GREEN)Done.$(RESET)\n"

re: clean-all all

# ===== Log helpers =====
logs:
	@printf "$(BLUE)$(NAME): $(CYAN)Available logs in $(LOG_DIR):$(RESET)\n"
	@ls -1 "$(LOG_DIR)" 2>/dev/null | sed 's/^/  - /' || echo "  (no logs yet)"

# Tail last 50 lines of a specific log:
#   make tail-resume_no_image_en
tail-%:
	@tail -n 50 "$(LOG_DIR)/$*.log"
