#!/usr/bin/env python3
"""
Convert YAML resume data to LaTeX content files.

Usage:
  python generate_tex.py <input.yml> <output.tex> [lang]
  python generate_tex.py <input.yml> <output.tex> personal

The input YAML may be a merged file with top-level language keys (e.g. 'en', 'fr'),
or a single-language file with top-level section keys ('experience', 'education', 'skills').

Supported inline formatting in YAML values:
  **bold text**  -> \\textbf{bold text}
  _italic text_  -> \\textit{italic text}
"""

import re
import sys
import yaml
from pathlib import Path


def format_text(text: str) -> str:
    """Convert Markdown-style bold/italic markers to LaTeX commands."""
    text = re.sub(r'\*\*(.+?)\*\*', r'\\textbf{\1}', text)
    text = re.sub(r'_(.+?)_', r'\\textit{\1}', text)
    return text


def generate_entry(entry: dict) -> list:
    """Generate LaTeX lines for a single experience or education entry."""
    lines = []

    company = format_text(entry.get('company', entry.get('institution', '')))
    title = format_text(entry.get('title', entry.get('degree', '')))
    location = format_text(entry.get('location', ''))
    period = format_text(entry.get('period', ''))

    lines.append(r'        \begin{twocolentry}{')
    lines.append(f'\t\t\t\\textbf{{{location}}} \\\\')
    lines.append(f'\t\t\t\\textit{{{period}}}')
    lines.append(r'            }{')
    lines.append(f'            \\textbf{{{company}}} \\\\')
    lines.append(f'            \\textit{{{title}}}')
    lines.append(r'            }')
    lines.append(r'        \end{twocolentry}')
    lines.append('')

    highlights = entry.get('highlights', [])
    if highlights:
        lines.append(r'        \begin{onecolentry}')
        lines.append(r'            \begin{highlights}')
        for h in highlights:
            lines.append(f'                \\item {format_text(h)}')
        lines.append(r'            \end{highlights}')
        lines.append(r'        \end{onecolentry}')
        lines.append('')

    return lines


def generate_tex(data: dict, lang: str = 'en') -> str:
    """Generate full LaTeX content from YAML resume data."""
    lines = []

    # Experience section
    exp_entries = data.get('experience', [])
    if exp_entries:
        section_title = 'Experience' if lang == 'en' else 'Parcours professionnel'
        lines.append(f'    \\section{{{section_title}}}')
        for entry in exp_entries:
            lines.extend(generate_entry(entry))

    # Education section
    edu_entries = data.get('education', [])
    if edu_entries:
        section_title = 'Education' if lang == 'en' else 'Parcours académique'
        lines.append(f'    \\section{{{section_title}}}')
        for entry in edu_entries:
            lines.extend(generate_entry(entry))

    # Skills section
    skills = data.get('skills', {})
    if skills:
        section_title = 'Skills and Technologies' if lang == 'en' else 'Compétences et intérêts'
        lines.append(f'    \\section{{{section_title}}}')

        # French typography uses a space before the colon
        colon = ':' if lang == 'en' else ' :'

        if lang == 'en':
            labels = {
                'languages': 'Languages',
                'technical': 'Technical Skills',
                'interests': 'Interests',
            }
        else:
            labels = {
                'languages': 'Langues',
                'technical': 'Compétences techniques',
                'interests': 'Intérêts',
            }

        for key in ('languages', 'technical', 'interests'):
            value = skills.get(key)
            if value:
                lines.append(r'        \begin{onecolentry}')
                lines.append(f'            \\textbf{{{labels[key]}{colon}}} {format_text(value)}')
                lines.append(r'        \end{onecolentry}')
                lines.append('')

    return '\n'.join(lines) + '\n'


def generate_personal_tex(personal: dict) -> str:
    """Generate a LaTeX file of \\def commands for personal contact info."""
    required = (
        'name', 'location', 'email',
        'phone_display', 'phone_tel',
        'website_url', 'website_display',
        'linkedin_url', 'linkedin_display',
        'github_url', 'github_display',
    )
    missing = [k for k in required if k not in personal]
    if missing:
        raise ValueError(
            f'Missing required personal keys: {", ".join(missing)}'
        )

    lines = [
        '% Personal information – generated from data/resume.yml',
        '% Do not edit manually.',
        r'\def\PersonName{' + personal['name'] + '}',
        r'\def\PersonLocation{' + personal['location'] + '}',
        r'\def\PersonEmail{' + personal['email'] + '}',
        r'\def\PersonPhoneDisplay{' + personal['phone_display'] + '}',
        r'\def\PersonPhoneTel{' + personal['phone_tel'] + '}',
        r'\def\PersonWebsiteURL{' + personal['website_url'] + '}',
        r'\def\PersonWebsiteDisplay{' + personal['website_display'] + '}',
        r'\def\PersonLinkedinURL{' + personal['linkedin_url'] + '}',
        r'\def\PersonLinkedinDisplay{' + personal['linkedin_display'] + '}',
        r'\def\PersonGithubURL{' + personal['github_url'] + '}',
        r'\def\PersonGithubDisplay{' + personal['github_display'] + '}',
    ]
    return '\n'.join(lines) + '\n'


def main() -> None:
    if len(sys.argv) < 3:
        print(f'Usage: {sys.argv[0]} <input.yml> <output.tex> [lang|personal]', file=sys.stderr)
        sys.exit(1)

    yaml_path = Path(sys.argv[1])
    tex_path = Path(sys.argv[2])
    lang = sys.argv[3] if len(sys.argv) > 3 else 'en'

    with yaml_path.open(encoding='utf-8') as f:
        raw = yaml.safe_load(f)

    if raw is None:
        print(f'Error: YAML file "{yaml_path}" is empty.', file=sys.stderr)
        sys.exit(1)

    if not isinstance(raw, dict):
        print(
            f'Error: Top-level YAML in "{yaml_path}" must be a mapping, '
            f'got {type(raw).__name__}.',
            file=sys.stderr,
        )
        sys.exit(1)

    if lang == 'personal':
        personal = raw.get('personal')
        if not isinstance(personal, dict):
            print(
                f'Error: No "personal" section found in "{yaml_path}".',
                file=sys.stderr,
            )
            sys.exit(1)
        try:
            tex_content = generate_personal_tex(personal)
        except ValueError as e:
            print(f'Error: {e}', file=sys.stderr)
            sys.exit(1)
    else:
        # Support merged file (top-level language keys) or single-language file
        if lang in raw:
            data = raw[lang]
            if not isinstance(data, dict):
                print(
                    f'Error: Entry for language "{lang}" in "{yaml_path}" must be a mapping, '
                    f'got {type(data).__name__}.',
                    file=sys.stderr,
                )
                sys.exit(1)
        else:
            looks_like_single_lang = any(
                key in raw for key in ('experience', 'education', 'skills')
            )
            if looks_like_single_lang:
                data = raw
            else:
                available_keys = ', '.join(sorted(raw.keys()))
                print(
                    f'Error: Language "{lang}" not found in "{yaml_path}". '
                    f'Available top-level keys: {available_keys or "(none)"}',
                    file=sys.stderr,
                )
                sys.exit(1)

        tex_content = generate_tex(data, lang)

    tex_path.parent.mkdir(parents=True, exist_ok=True)
    with tex_path.open('w', encoding='utf-8') as f:
        f.write(tex_content)

    print(f'Generated {tex_path}')


if __name__ == '__main__':
    main()
