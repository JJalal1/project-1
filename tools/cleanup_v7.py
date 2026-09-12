from pathlib import Path
import sys

path = Path(sys.argv[1] if len(sys.argv) > 1 else 'buildapp/lib/main.dart')
text = path.read_text()
start = text.find('class _Fact extends StatelessWidget')
if start >= 0:
    end = text.find('class Market extends StatelessWidget', start)
    if end < 0:
        raise SystemExit('Market marker missing after _Fact')
    text = text[:start] + text[end:]
path.write_text(text)
