# Resume Project — Claude Code Guide

## What this project is
Data-driven LaTeX resume generator producing 8 PDF variants (default/tech style × with/without photo × EN/FR) from a single YAML source.

## Architecture
```
data/resume.yml          ← single source of truth (content + personal info)
scripts/generate_tex.py  ← YAML → LaTeX converter
src/
  config/                ← packages.tex, style.tex (default), commands.tex,
                           style_tech.tex (tech style overrides)
  layout/{default,tech}/ ← header_with_image.tex, header_no_image.tex
  content/               ← GENERATED (gitignored): personal.tex, resume_content_{en,fr}.tex
build/
  resume_{style}_{variant}.tex ← root LaTeX files (8 variants, committed)
  resume_{variant}.pdf   ← compiled output (gitignored)
```

## Golden rule
**All content and personal info lives in `data/resume.yml`.** Never hardcode names, contact details, or resume text in LaTeX files — always add to YAML and let the generator emit it.

## Build
```bash
make              # build all 8 variants
make default / make tech  # build one style
make en / make fr # build one language
make generate     # YAML → LaTeX only (no compilation)
make re           # clean + rebuild everything
make tail-resume_default_with_image_en  # inspect LaTeX log
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
macros (`resumeentry`, `resumehighlights`, `resumeskills`, `\resumeskill`).
Their default rendering lives in `style.tex`; `style_tech.tex` redefines them for
the tech style (Times font, date column on the left). Optional `short_name` on an
entry (e.g. `UQAC`) is used by the tech style when the heading would not fit on one line.

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

## Variants
Root files are `build/resume_<style>_<with|no>_image_<en|fr>.tex`:

| Style | Look | Style files | Headers |
|-------|------|-------------|---------|
| `default` | original layout, icons, blue links | `style.tex` | `src/layout/default/` |
| `tech` | Times, uppercase ruled sections, date column on the left | `style.tex` + `style_tech.tex` | `src/layout/tech/` |

## CI/CD
- **compile** job: matrix over 2 styles × 4 variants, each uploads its PDF as artifact `pdf-<style>_<variant>`
- **release** job: downloads all 8 PDFs, publishes `resume-default.zip` and `resume-tech.zip` (4 PDFs each) plus the default-style PDFs used by README links
- Triggers on push to `main`: replaces the `latest` release and archives the previous one as a release tagged `dd.mm.yyyy`

## Adding a new section
1. Add content to `data/resume.yml` under `en:` and `fr:`
2. Add a `generate_<section>()` call in `scripts/generate_tex.py`
3. Run `make` to verify output
