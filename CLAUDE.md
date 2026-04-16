# Resume Project — Claude Code Guide

## What this project is
Data-driven LaTeX resume generator producing 4 PDF variants (with/without photo × EN/FR) from a single YAML source.

## Architecture
```
data/resume.yml          ← single source of truth (content + personal info)
scripts/generate_tex.py  ← YAML → LaTeX converter
src/
  config/                ← packages.tex, style.tex, commands.tex
  layout/                ← header_with_image.tex, header_no_image.tex
  content/               ← GENERATED (gitignored): personal.tex, resume_content_{en,fr}.tex
build/
  resume_{variant}.tex   ← root LaTeX files (4 variants, committed)
  resume_{variant}.pdf   ← compiled output (gitignored)
```

## Golden rule
**All content and personal info lives in `data/resume.yml`.** Never hardcode names, contact details, or resume text in LaTeX files — always add to YAML and let the generator emit it.

## Build
```bash
make              # build all 4 variants
make en / make fr # build one language
make generate     # YAML → LaTeX only (no compilation)
make re           # clean + rebuild everything
make tail-resume_with_image_en  # inspect LaTeX log
```

Dependencies: `latexmk`, `python3`, `pyyaml`

## Generator script
```bash
python scripts/generate_tex.py data/resume.yml src/content/personal.tex personal
python scripts/generate_tex.py data/resume.yml src/content/resume_content_en.tex en
python scripts/generate_tex.py data/resume.yml src/content/resume_content_fr.tex fr
```

`personal` mode emits `\def\PersonName{...}` etc. for all contact fields.
`en`/`fr` modes emit experience, education, and skills sections.

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
| File | Image | Lang |
|------|-------|------|
| `resume_with_image_en.tex` | yes | EN |
| `resume_no_image_en.tex`   | no  | EN |
| `resume_with_image_fr.tex` | yes | FR |
| `resume_no_image_fr.tex`   | no  | FR |

## CI/CD
- **compile** job: matrix over 4 variants, each uploads its PDF as artifact `pdf-<variant>`
- **release** job: downloads all 4 PDFs, creates/updates GitHub release
- Triggers on push to `main` (latest release) or a version tag (tagged release)

## Adding a new section
1. Add content to `data/resume.yml` under `en:` and `fr:`
2. Add a `generate_<section>()` call in `scripts/generate_tex.py`
3. Run `make` to verify output
