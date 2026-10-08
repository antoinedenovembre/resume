# Resume Project — Claude Code Guide

## What this project is
Data-driven LaTeX resume generator producing 16 PDFs (4 styles: default/tech/minimal/sidebar × with/without photo × EN/FR) from a single YAML source.

## Architecture
```
data/resume.yml          ← single source of truth (content + personal info)
scripts/generate_tex.py  ← YAML → LaTeX converter (emits semantic macros, no layout)
src/
  config/                ← shared: packages.tex, style.tex (base rendering = default style), commands.tex
  styles/<style>/        ← style.tex (overrides), header_with_image.tex, header_no_image.tex
  content/               ← GENERATED (gitignored): personal.tex, resume_content_{en,fr}.tex
build/
  <style>/resume_{with,no}_image_{en,fr}.tex ← root files (16, committed); \ResumeRoot = ../../
  <style>/resume_*.pdf   ← compiled output (gitignored)
```

## Golden rule
**All content and personal info lives in `data/resume.yml`.** Never hardcode names, contact details, or resume text in LaTeX files — always add to YAML and let the generator emit it.

## Build
```bash
make              # build all 8 variants
make default / make tech / make minimal / make sidebar  # build one style
make tech_no_image_fr     # build one variant
make en / make fr # build one language
make generate     # YAML → LaTeX only (no compilation)
make re           # clean + rebuild everything
make tail-default_resume_with_image_en  # inspect LaTeX log
```

Dependencies: `latexmk`, `python3`, `pyyaml`

## Generator script
```bash
python scripts/generate_tex.py data/resume.yml src/content/personal.tex personal
python scripts/generate_tex.py data/resume.yml src/content/resume_content_en.tex en
python scripts/generate_tex.py data/resume.yml src/content/resume_content_fr.tex fr
```

`personal` mode emits `\def\PersonName{...}` etc. for all contact fields.
`en`/`fr` modes emit experience, education, and skills sections using semantic
macros (`resumeentry`, `resumehighlights`, `resumeskillssection`, `resumeskills`,
`\resumeskill`). Their base rendering lives in `src/config/style.tex`; each
`src/styles/<style>/style.tex` redefines them. Optional `short_name` on an entry
(e.g. `UQAC`) is used by the tech style when the heading would not fit on one line.

## YAML structure
```yaml
personal:          # contact info → src/content/personal.tex
  name, location, email, phone_display, phone_tel,
  website_url, website_display, linkedin_url, linkedin_display,
  github_url, github_display

en:                # English resume content
  experience, education, skills

fr:                # French resume content
  experience, education, skills
```

Inline formatting in YAML values: `**bold**` → `\textbf{}`, `_italic_` → `\textit{}`

## Styles
| Style | Look |
|-------|------|
| `default` | original layout, icons, blue links (empty override) |
| `tech` | Times, uppercase ruled sections, date column on the left |
| `minimal` | Source Sans, gray letter-spaced titles, no rules/icons |
| `sidebar` | Roboto, colored left column (photo, contacts, skills drawn at shipout: must stay 1 page) |

Adding a style: see DEVELOPMENT.md ("Adding a style"): style folder, 4 roots, `STYLES` in Makefile, CI matrix and the style loops in release/preview workflows.

## CI/CD
- **compile** job: matrix over 4 styles × 4 variants, each uploads `build/<style>/resume_<variant>.pdf` as artifact `pdf-<style>_<variant>`
- **release** job: publishes `resume-<style>.zip` (4 PDFs each) plus the default-style PDFs used by README/site links
- **preview** job: after a release, regenerates `assets/previews/preview_<style>.png` (FR with photo) and `preview_{en,fr}.png`
- Triggers on push to `main`: replaces the `latest` release and archives the previous one as a release tagged `dd.mm.yyyy`

## Adding a new section
1. Add content to `data/resume.yml` under `en:` and `fr:`
2. Add a `generate_<section>()` call in `scripts/generate_tex.py`
3. Run `make` to verify output
