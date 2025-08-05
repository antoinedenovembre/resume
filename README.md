# Resume Repository

[![Compile Resume](https://github.com/antoinedenovembre/resume/actions/workflows/compile-resume.yml/badge.svg)](https://github.com/antoinedenovembre/resume/actions/workflows/compile-resume.yml)
[![Latest Release](https://img.shields.io/github/v/release/antoinedenovembre/resume?include_prereleases&label=Latest%20PDFs)](https://github.com/antoinedenovembre/resume/releases/latest)

This repository contains my resume source LaTeX files, which are automatically compiled to PDF format using GitHub Actions.

## 📄 Resume Versions

The resume is available in two versions:

- **With Photo** (`with_image/`) - Professional resume including headshot
- **Without Photo** (`no_image/`) - Clean resume without personal photo

## 🚀 Quick Access

**Latest compiled PDFs are always available here:**
👉 [**Download Latest Resume PDFs**](https://github.com/antoinedenovembre/resume/releases/latest)

## 🛠️ Local Development

### Prerequisites

- LaTeX distribution (TeX Live, MiKTeX, or MacTeX)
- `latexmk` command-line tool

### Building Locally

```bash
# Build both versions
make all

# Build only version with photo
make with_image

# Build only version without photo
make no_image

# Clean build artifacts
make clean
```

## 🔄 Automated Compilation

Every push to the `main` branch automatically:

1. ✅ Compiles both resume versions
2. ✅ Creates a "latest" release with updated PDFs
3. ✅ Stores artifacts for 30 days
4. ✅ Provides immediate access to latest versions

## 📁 Project Structure

```
resume/
├── .github/workflows/
│   └── compile-resume.yml      # CI/CD pipeline
├── with_image/
│   ├── resume.tex             # LaTeX source with photo
│   ├── resume.pdf             # Compiled PDF
│   └── images/
│       └── photo.jpg          # Profile photo
├── no_image/
│   ├── resume.tex             # LaTeX source without photo
│   └── resume.pdf             # Compiled PDF
├── resume_body.tex            # Shared resume content
├── Makefile                   # Build automation
└── README.md                  # This file
```

## 🏷️ Versioning

- **Latest Release**: Always contains the most recent compiled PDFs
- **Tagged Releases**: Create a git tag (e.g., `v1.0`) to create a permanent versioned release

```bash
# Create a versioned release
git tag v1.0
git push origin v1.0
```

## 📋 LaTeX Packages Used

- `geometry` - Page layout and margins
- `graphicx` - Image inclusion (for photo version)
- `titlesec` - Section title customization
- `tabularx` - Advanced table formatting
- `xcolor` - Color definitions
- `enumitem` - List customization
- `fontawesome5` - Icons
- `hyperref` - Links and metadata

## 📧 Contact

For any questions about this resume or potential opportunities, please reach out through the contact information provided in the resume PDFs.

---

*This repository uses GitHub Actions for automated LaTeX compilation and release management.*