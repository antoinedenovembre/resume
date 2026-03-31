# Resume Repository

[![Last build](https://github.com/antoinedenovembre/resume/actions/workflows/compile-resume.yml/badge.svg)](https://github.com/antoinedenovembre/resume/actions/workflows/compile-resume.yml)
[![Latest Release](https://img.shields.io/github/v/release/antoinedenovembre/resume?label=latest)](../../releases/latest)
[![Pages](https://img.shields.io/badge/pages-live-brightgreen)](https://antoinedenovembre.github.io/resume/)

A clean, modular LaTeX resume with multilingual support (French & English), optimized for both human readability and ATS parsing. Automatically compiled with GitHub Actions and updated on every push.

## Quick Access

### Download Latest Resume
- **🇫🇷 French:** [PDF with photo](https://github.com/antoinedenovembre/resume/releases/latest/download/resume_fr.pdf) · [PDF without photo](https://github.com/antoinedenovembre/resume/releases/latest/download/resume-no-image-fr.pdf)
- **🇺🇸 English:** [PDF with photo](https://github.com/antoinedenovembre/resume/releases/latest/download/resume_en.pdf) · [PDF without photo](https://github.com/antoinedenovembre/resume/releases/latest/download/resume-no-image-en.pdf)

### Browse Online
- **Live preview:** [GitHub Pages](https://antoinedenovembre.github.io/resume/)
- **All versions:** [Latest Release](https://github.com/antoinedenovembre/resume/releases/latest)

## Editing on Mobile (or anywhere)

Resume content is stored as simple YAML files — no LaTeX knowledge required for everyday edits.

### Edit content
Open one of these files on GitHub (web or mobile app) and edit directly:
- [`data/resume_en.yml`](data/resume_en.yml) — English resume
- [`data/resume_fr.yml`](data/resume_fr.yml) — French resume

Use `**bold text**` for bold and `_italic text_` for italic. Commit your change and GitHub Actions will compile and publish the updated PDFs automatically.

### Manual rebuild (without editing)
Go to **[Actions → Compile resume](../../actions/workflows/compile-resume.yml)** and click **Run workflow** to trigger a fresh build without changing any file. This works from the GitHub mobile app too.

## Preview

<div align="center">
  <img src="assets/previews/preview_fr.png" alt="CV Français" width="45%"/>
  <img src="assets/previews/preview_en.png" alt="Resume English" width="45%"/>
</div>

## For Developers

Want to customize this resume template or understand how it works?

**[See Development Guide](DEVELOPMENT.md)** for detailed documentation.

## Contact

For any questions about this resume or potential opportunities, please reach out through the contact information provided in the resume PDFs.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

*🤖 This repository uses GitHub Actions for automated LaTeX compilation and release management.*
