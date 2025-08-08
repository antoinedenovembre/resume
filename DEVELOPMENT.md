# Development Guide

This document contains detailed information for developers who want to work on or understand the technical aspects of this LaTeX resume project.

## Local Development

### Prerequisites

- LaTeX distribution (TeX Live, MiKTeX, or MacTeX)
- `latexmk` command-line tool

### Building Locally

```bash
# Build all versions in both languages (recommended)
make all

# Build all English versions (with and without photo)
make en

# Build all French versions (with and without photo)
make fr

# Build specific versions
make with_image          # English with photo
make no_image           # English without photo
make with_image_fr      # French with photo
make no_image_fr        # French without photo

# Clean auxiliary files (keeps PDFs)
make clean

# Clean all generated files including PDFs
make clean-all
```

### Development Notes
- All source files are organized in the `src/` directory
- Built PDFs are generated in the `build/` directory  
- The build process automatically cleans auxiliary LaTeX files
- Modular architecture allows easy customization of individual components
- **Multi-language support**: English and French versions with shared configuration and styling

## Automated Compilation

Every push to the `main` branch automatically:

1. Compiles all resume versions (English and French, with and without photo)
2. Creates a "latest" release with updated PDFs
3. Stores artifacts for 30 days
4. Provides immediate access to latest versions

## Project Structure

```
resume/
├── .github/workflows/
│   └── compile-resume.yml      # CI/CD pipeline for automated builds
├── assets/
│   └── photo.jpg              # Profile photo asset
├── build/
│   ├── resume_with_image_en.tex       # Main LaTeX file with photo (EN)
│   ├── resume_no_image_en.tex         # Main LaTeX file without photo (EN)
│   ├── resume_with_image_fr.tex    # Main LaTeX file with photo (FR)
│   ├── resume_no_image_fr.tex      # Main LaTeX file without photo (FR)
├── src/
│   ├── config/
│   │   ├── packages.tex        # LaTeX package imports and configuration
│   │   ├── style.tex           # Styling definitions and formatting
│   │   └── commands.tex        # Custom LaTeX commands
│   ├── content/
│   │   ├── resume_content.tex  # Main resume content (English)
│   │   └── resume_content_fr.tex # Main resume content (French)
│   └── layout/
│       ├── header_with_image.tex    # Header layout with photo (EN)
│       ├── header_no_image.tex      # Header layout without photo (EN)
│       ├── header_with_image_fr.tex # Header layout with photo (FR)
│       └── header_no_image_fr.tex   # Header layout without photo (FR)
├── Makefile                   # Build automation
├── .gitignore                 # Git ignore rules
└── README.md                  # This file
```

## Modular Architecture

The project uses a modular LaTeX architecture for better maintainability:

- **Configuration Layer** (`src/config/`): Package imports, styling, and custom commands (shared across languages)
- **Content Layer** (`src/content/`): Actual resume content with separate files per language
- **Layout Layer** (`src/layout/`): Different header layouts for photo variants and languages
- **Build Layer** (`build/`): Main document files that combine all modules for each version
- **Assets** (`assets/`): Static resources like photos

### Multi-language Support

- **Shared Configuration**: All languages use the same packages, styles, and commands
- **Language-specific Content**: Separate content files for each language (`resume_content_en.tex` and `resume_content_fr.tex`)
- **Language-specific Headers**: Header files adapted for each language while maintaining the same styling
- **Consistent Build System**: Simple `make en` and `make fr` commands to build all versions for each language

## Versioning

- **Latest Release**: Always contains the most recent compiled PDFs
- **Tagged Releases**: Create a git tag (e.g., `v1.0`) to create a permanent versioned release

```bash
# Create a versioned release
git tag v1.0
git push origin v1.0
```

## LaTeX Packages Used

### Core Packages
- `geometry` - Page layout and margins configuration
- `titlesec` - Section title customization
- `tabularx` & `array` - Advanced table formatting
- `xcolor` - Color definitions and primary color scheme
- `enumitem` - List customization and styling
- `fontawesome5` - Professional icons integration
- `hyperref` & `bookmark` - PDF metadata, links, and navigation

### Layout & Formatting
- `amsmath` - Mathematical expressions support
- `eso-pic` - Floating text positioning
- `calc` - Length calculations
- `lastpage` - Total page count reference
- `changepage` - Adjustable width environments
- `paracol` - Multi-column layout support
- `needspace` - Intelligent page break management

### Conditional Packages (Photo Version Only)
- `graphicx` - Image inclusion for profile photo
- `tikz` - Graphics and diagrams creation

### Engine Compatibility
- `iftex` - LaTeX engine detection
- `ifthen` - Conditional statements
- PDF/A compatibility packages for ATS parsing

## Advanced Features

### Conditional Compilation
The project uses intelligent conditional compilation:
- Photo-related packages (`graphicx`, `tikz`) are only loaded for the image version
- Keeps the no-image version lightweight and faster to compile
- Maintains ATS (Applicant Tracking System) compatibility

### PDF Optimization
- Machine-readable PDF generation for ATS parsing
- Unicode character mapping for text extraction
- Proper PDF metadata and navigation bookmarks
- Color-coded links with professional styling

### Build System
- Automated cleanup of auxiliary LaTeX files
- Parallel compilation support via Makefile
- Consistent output in `build/` directory
- Development-friendly with modular source organization
