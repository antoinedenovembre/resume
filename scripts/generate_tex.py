#!/usr/bin/env python3
"""
Convert YAML resume data to LaTeX content files.

Usage: python generate_tex.py <input.yml> <output.tex> [lang]

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


def main() -> None:
    if len(sys.argv) < 3:
        print(f'Usage: {sys.argv[0]} <input.yml> <output.tex> [lang]', file=sys.stderr)
        sys.exit(1)

    yaml_path = Path(sys.argv[1])
    tex_path = Path(sys.argv[2])
    lang = sys.argv[3] if len(sys.argv) > 3 else 'en'

    with yaml_path.open(encoding='utf-8') as f:
        data = yaml.safe_load(f)

    tex_content = generate_tex(data, lang)

    tex_path.parent.mkdir(parents=True, exist_ok=True)
    with tex_path.open('w', encoding='utf-8') as f:
        f.write(tex_content)

    print(f'Generated {tex_path}')


if __name__ == '__main__':
    main()
