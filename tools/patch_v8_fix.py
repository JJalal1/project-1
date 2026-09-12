from pathlib import Path
import sys

path = Path(sys.argv[1] if len(sys.argv) > 1 else 'buildapp/lib/main.dart')
text = path.read_text()

# Close the location picker state before the map painter.
needle = "      );\n\nclass _MapPainter extends CustomPainter {"
if needle in text:
    text = text.replace(needle, "      );\n}\n\nclass _MapPainter extends CustomPainter {", 1)

# Search replacement removes the original switch component, so restore it.
marker = "class _FilterChipLabel extends StatelessWidget {"
if marker in text and "class _SwitchButton extends StatelessWidget" not in text:
    switch = '''class _SwitchButton extends StatelessWidget {
  final String t;
  final bool active;
  final IconData icon;
  final VoidCallback tap;
  const _SwitchButton(this.t, this.active, this.icon, this.tap);
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: tap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: active ? ink : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: active ? ink : line),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 18, color: active ? Colors.white : ink),
            const SizedBox(width: 6),
            Text(t, style: TextStyle(color: active ? Colors.white : ink, fontWeight: FontWeight.w900)),
          ]),
        ),
      );
}

'''
    text = text.replace(marker, switch + marker, 1)

path.write_text(text)
