# ===== Pretty, quiet LaTeX CV Makefile =====
.PHONY: all en fr with_image_en no_image_en with_image_fr no_image_fr clean clean-all re test logs tail-%

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

# ===== Pattern rule: build build/foo.pdf from build/foo.tex =====
# We cd into build/ (your sources live there) and silence latexmk output,
# redirecting full logs to build/logs/foo.log. Aux files are cleaned right after.
$(BUILD_DIR)/%.pdf: $(BUILD_DIR)/%.tex | $(BUILD_DIR) $(LOG_DIR)
	@printf "\033[2K\r$(BLUE)$(NAME): $(PURPLE)$*.tex → $*.pdf$(RESET)"
	@cd $(BUILD_DIR) && $(LATEXMK) $(LATEX_FLAGS) $*.tex > "$(LOG_DIR)/$*.log" 2>&1
	@cd $(BUILD_DIR) && $(LATEXMK) -c $*.tex > /dev/null 2>&1
	@printf "\033[2K\r$(BLUE)$(NAME): $(GREEN)Built → $@ [√]$(RESET)\n"

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
	@printf "$(BLUE)$(NAME): $(YELLOW)Removing PDFs$(RESET)\n"
	@rm -f $(BUILD_DIR)/*.pdf
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
