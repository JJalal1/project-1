from pathlib import Path
import sys

path = Path(sys.argv[1] if len(sys.argv) > 1 else 'buildapp/lib/main.dart')
text = path.read_text()
start = text.find('class _ActionTile extends StatelessWidget')
end = text.find('class PropertyCard extends StatelessWidget', start)
if start >= 0 and end > start:
    text = text[:start] + text[end:]
path.write_text(text)
