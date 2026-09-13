from pathlib import Path
import sys

path = Path(sys.argv[1] if len(sys.argv) > 1 else 'buildapp/lib/main.dart')
text = path.read_text()
text = text.replace("    const tile = Color(0xFF2B2E2E);\n", "")
path.write_text(text)
