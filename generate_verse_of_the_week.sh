#!/bin/zsh

SOURCE=$1
TEMPLATE=$2
OUTPUT=$3

if [ -z "$SOURCE" ] || [ -z "$TEMPLATE" ] || [ -z "$OUTPUT" ]; then
  echo "Usage: $0 <source.tex> <template.tex> <output_file.tex>"
  exit 1
fi

# Extract the title (e.g., "John 3:16") from the source .tex file
TITLE=$(grep '\\section\*{' "$SOURCE" | sed -E 's/\\section\*\{//' | sed 's/}//')

# Extract the verse content (text between \begin{verse} and \end{verse})
TEXT=$(awk '/\\begin{verse}/, /\\end{verse}/' "$SOURCE" | sed '1d;$d' | sed 's/\\\\//g')

# Read the template file and replace placeholders
cat "$TEMPLATE" | \
  sed "s/<<TITLE>>/$TITLE/g" | \
  sed "s/<<TEXT>>/$(echo "$TEXT" | sed -E 's/&/\\&/g')/g" > "$OUTPUT"

echo "Generated formatted file: $OUTPUT"

