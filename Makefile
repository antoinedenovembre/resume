# ===== Pretty, quiet LaTeX CV Makefile =====

# ===== Project =====
NAME        = resume
BUILD_DIR   = build
LOG_DIR     := $(abspath $(BUILD_DIR)/logs)

# Styles live in src/styles/<style>/, root files in build/<style>/resume_<variant>.tex
STYLES      = default tech sidebar
VARIANTS    = with_image_en no_image_en with_image_fr no_image_fr

# All PDFs: build/<style>/resume_<variant>.pdf
PDFS        = $(foreach s,$(STYLES),$(foreach v,$(VARIANTS),$(BUILD_DIR)/$(s)/resume_$(v).pdf))

.PHONY: all en fr $(STYLES) generate clean clean-all re test logs tail-%

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

# ===== Default targets =====
all: $(PDFS)
	@printf "$(BLUE)$(NAME): $(GREEN)All resumes built [√]$(RESET)\n"

# One language, every style: `make en`, `make fr`
en fr:
	@$(MAKE) --no-print-directory $(filter %_$@.pdf,$(PDFS))
	@printf "$(BLUE)$(NAME): $(GREEN)$@ resumes built [√]$(RESET)\n"

# One style, every variant: `make tech`
$(STYLES): %: $(foreach v,$(VARIANTS),$(BUILD_DIR)/%/resume_$(v).pdf)
	@printf "$(BLUE)$(NAME): $(GREEN)$@ style built [√]$(RESET)\n"

# One variant: `make tech_no_image_fr`
$(foreach s,$(STYLES),$(foreach v,$(VARIANTS),$(s)_$(v))):
	@$(MAKE) --no-print-directory $(BUILD_DIR)/$(firstword $(subst _, ,$@))/resume_$(subst $(firstword $(subst _, ,$@))_,,$@).pdf

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

# ===== Compile rule =====
# build/<style>/resume_<img>_<lang>.pdf depends on its root file, the shared
# config, the style folder and the generated content of its language.
.SECONDEXPANSION:
$(BUILD_DIR)/%.pdf: $(BUILD_DIR)/%.tex $(COMMON_SOURCES) \
                    $$(wildcard src/styles/$$(*D)/*.tex) \
                    src/content/resume_content_$$(lastword $$(subst _, ,$$*)).tex | $(LOG_DIR)
	@printf "\033[2K\r$(BLUE)$(NAME): $(PURPLE)$*.tex → $*.pdf$(RESET)"
	@cd $(@D) && $(LATEXMK) $(LATEX_FLAGS) $(notdir $*).tex > "$(LOG_DIR)/$(subst /,_,$*).log" 2>&1 \
		|| { printf "\n$(RED)$(NAME): $* failed, see $(LOG_DIR)/$(subst /,_,$*).log$(RESET)\n"; exit 1; }
	@cd $(@D) && $(LATEXMK) -c $(notdir $*).tex > /dev/null 2>&1
	@printf "\033[2K\r$(BLUE)$(NAME): $(GREEN)Built → $@ [√]$(RESET)\n"

$(LOG_DIR):
	@mkdir -p $(LOG_DIR)

# ===== Cleaning =====
clean:
	@printf "$(BLUE)$(NAME): $(YELLOW)Cleaning auxiliary files$(RESET)\n"
	@for s in $(STYLES); do for v in $(VARIANTS); do \
		(cd $(BUILD_DIR)/$$s && $(LATEXMK) -c resume_$$v.tex >/dev/null 2>&1) || true ; \
	done; done
	@rm -f $(BUILD_DIR)/*/*.synctex.gz
	@printf "$(BLUE)$(NAME): $(GREEN)Done.$(RESET)\n"

clean-all: clean
	@printf "$(BLUE)$(NAME): $(YELLOW)Removing PDFs and generated content$(RESET)\n"
	@rm -f $(PDFS)
	@rm -f $(PERSONAL_TEX) $(CONTENT_EN) $(CONTENT_FR)
	@printf "$(BLUE)$(NAME): $(GREEN)Done.$(RESET)\n"

re: clean-all all

# ===== Log helpers =====
logs:
	@printf "$(BLUE)$(NAME): $(CYAN)Available logs in $(LOG_DIR):$(RESET)\n"
	@ls -1 "$(LOG_DIR)" 2>/dev/null | sed 's/^/  - /' || echo "  (no logs yet)"

# Tail last 50 lines of a specific log:
#   make tail-tech_resume_no_image_en
tail-%:
	@tail -n 50 "$(LOG_DIR)/$*.log"
