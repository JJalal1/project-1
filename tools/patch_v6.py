from pathlib import Path
import sys

path = Path(sys.argv[1] if len(sys.argv) > 1 else 'buildapp/lib/main.dart')
text = path.read_text()

# Professional, restrained real-estate palette.
replacements = {
    "const navy = Color(0xFF12283F);": "const navy = Color(0xFF17352F);",
    "const navy2 = Color(0xFF1D3C59);": "const navy2 = Color(0xFF294B44);",
    "const teal = Color(0xFF0E8A72);": "const teal = Color(0xFF176B58);",
    "const coral = Color(0xFFE45D52);": "const coral = Color(0xFF9B6A3D);",
    "const cream = Color(0xFFFFFCF7);": "const cream = Color(0xFFF7F7F4);",
    "const sand = Color(0xFFF5F0E8);": "const sand = Color(0xFFEFEEE9);",
    "const sky = Color(0xFFEAF4F8);": "const sky = Color(0xFFE8F1EE);",
    "const ink = Color(0xFF1D2630);": "const ink = Color(0xFF18211E);",
    "const muted = Color(0xFF6F7882);": "const muted = Color(0xFF66716D);",
    "const line = Color(0xFFE7E1D8);": "const line = Color(0xFFDDE2DE);",
    "title: 'العقار — نموذج V5',": "title: 'العقار',",
    "seedColor: navy": "seedColor: teal",
    "minimumSize: const Size(48, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))": "minimumSize: const Size(48, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))",
    "borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none": "borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none",
    "borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: line)": "borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: line)",
    "borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: navy, width: 1.4)": "borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: teal, width: 1.4)",
    "تم الانتقال إلى موقعك الحالي — بيانات تجريبية.": "تم تحديد موقعك الحالي.",
    "إضافة عقار تتطلب حساب نشر موثق في التطبيق الحقيقي.": "إضافة العقار متاحة للحسابات المؤهلة للنشر.",
    "كل عناصر الفلتر الموجودة في مشروعك الحقيقي.": "اختر المواصفات التي تناسبك، ثم اعرض النتائج.",
    "عقار بموقع مميز وتشطيب حديث، قريب من الخدمات والطرق الرئيسية. هذا النص تجريبي لعرض شكل المحتوى.": "عقار بموقع مميز وتشطيب حديث، قريب من الخدمات والطرق الرئيسية، مع توزيع عملي للمساحات وإضاءة طبيعية جيدة.",
    "borderRadius:BorderRadius.vertical(top:Radius.circular(30))": "borderRadius:BorderRadius.vertical(top:Radius.circular(20))",
}
for old, new in replacements.items():
    text = text.replace(old, new)


def replace_between(source: str, start: str, end: str, replacement: str) -> str:
    a = source.find(start)
    if a < 0:
        raise SystemExit(f'missing start marker: {start}')
    b = source.find(end, a)
    if b < 0:
        raise SystemExit(f'missing end marker: {end}')
    return source[:a] + replacement.rstrip() + '\n\n' + source[b:]

# Integrated bottom navigation. No floating AI/prototype capsule.
shell = r'''class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int i = 0;
  final pages = const [Discovery(), Messages(), Bookings(), Account()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: IndexedStack(index: i, children: pages),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: line)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 66,
            child: Row(children: [
              _nav(0, 'العقارات', Icons.home_work_outlined),
              _nav(1, 'الرسائل', Icons.chat_bubble_outline_rounded),
              _nav(2, 'المعاينات', Icons.calendar_month_outlined),
              _nav(3, 'حسابي', Icons.person_outline_rounded),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _nav(int index, String label, IconData icon) {
    final selected = i == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => i = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 28,
              height: 3,
              decoration: BoxDecoration(
                color: selected ? teal : Colors.transparent,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 7),
            Icon(icon, size: 24, color: selected ? teal : muted),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                height: 1,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected ? teal : muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}'''
text = replace_between(text, 'class Shell extends StatefulWidget', 'class Discovery extends StatefulWidget', shell)

# Fix the root layout bug: the discovery stack must fill the available body.
lines = text.splitlines()
for idx, line in enumerate(lines):
    if '@override Widget build(BuildContext c){ if(list) return _list(c);' in line:
        lines[idx] = r'''  @override
  Widget build(BuildContext c) {
    if (list) return _list(c);
    return Stack(
      fit: StackFit.expand,
      children: [
        const MapArt(),
        if (!drawing)
          PositionedDirectional(
            start: 12,
            end: 12,
            top: 0,
            child: SafeArea(
              bottom: false,
              child: _QuickPanel(
                purpose: purpose,
                type: type,
                search: search,
                filterCount: filters,
                onPurpose: (v) => setState(() => purpose = purpose == v ? null : v),
                onType: (v) => setState(() => type = type == v ? null : v),
                onSearch: () => _search(c),
                onMore: () => _filter(c),
              ),
            ),
          ),
        if (area && !drawing)
          PositionedDirectional(
            top: 166,
            start: 14,
            child: InputChip(
              avatar: const Icon(Icons.gesture_rounded, size: 18),
              label: const Text('منطقة محددة'),
              onDeleted: () => setState(() => area = false),
            ),
          ),
        if (!drawing) ...[
          _pin(285, 58, '85 مليون', teal, 0),
          _pin(410, null, '320 ألف', coral, 1, right: 58),
          _pin(520, 205, '42.5 مليون', navy2, 2),
        ],
        if (!drawing)
          PositionedDirectional(
            end: 12,
            bottom: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _MapCtl(Icons.notifications_none_rounded, 'حفظ البحث', () => go(c, SavedSearchBuilder(purpose: purpose, type: type, area: area, search: search))),
                const SizedBox(height: 8),
                _MapCtl(Icons.gesture_rounded, 'رسم منطقة', () => setState(() => drawing = true)),
                const SizedBox(height: 8),
                _MapCtl(Icons.my_location_rounded, 'موقعي الحالي', () => ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content: Text('تم تحديد موقعك الحالي.')))),
              ],
            ),
          ),
        if (!drawing)
          Positioned(left: 12, right: 12, bottom: 78, child: SelectedCard(p: ps[selected], onTap: () => go(c, Details(ps[selected])))),
        if (!drawing)
          Positioned(left: 12, right: 12, bottom: 12, child: _SwitchBar(count: '18 نتيجة', map: true, onSwitch: () => setState(() => list = true), onAdd: () => ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content: Text('إضافة العقار متاحة للحسابات المؤهلة للنشر.'))))),
        if (drawing) _drawOverlay(c),
      ],
    );
  }'''
        break
else:
    raise SystemExit('Discovery build marker not found')
text = '\n'.join(lines) + '\n'

quick_panel = r'''class _QuickPanel extends StatelessWidget {
  final String? purpose, type;
  final String search;
  final int filterCount;
  final ValueChanged<String> onPurpose;
  final ValueChanged<String?> onType;
  final VoidCallback onSearch, onMore;

  const _QuickPanel({
    required this.purpose,
    required this.type,
    required this.search,
    required this.filterCount,
    required this.onPurpose,
    required this.onType,
    required this.onSearch,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: const Color(0x18000000),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              Expanded(
                child: InkWell(
                  onTap: onSearch,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: cream,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: line),
                    ),
                    child: Row(children: [
                      const Icon(Icons.search_rounded, color: muted, size: 22),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          search.isEmpty ? 'ابحث بالحي، الشارع أو اسم العقار' : search,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: search.isEmpty ? muted : ink,
                            fontWeight: search.isEmpty ? FontWeight.w500 : FontWeight.w700,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 48,
                height: 48,
                child: OutlinedButton(
                  onPressed: onMore,
                  style: OutlinedButton.styleFrom(padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: Stack(alignment: Alignment.center, children: [
                    const Icon(Icons.tune_rounded, size: 22),
                    if (filterCount > 0)
                      PositionedDirectional(
                        top: 5,
                        end: 5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(color: teal, borderRadius: BorderRadius.circular(99)),
                          child: Text('$filterCount', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                        ),
                      ),
                  ]),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _Purpose('للبيع', Icons.sell_outlined, purpose == 'sale', () => onPurpose('sale'))),
              const SizedBox(width: 8),
              Expanded(child: _Purpose('للإيجار', Icons.key_outlined, purpose == 'rent', () => onPurpose('rent'))),
            ]),
            const SizedBox(height: 10),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _chip('الكل', type == null, () => onType(null)),
                  _chip('شقة', type == 'apartment', () => onType('apartment')),
                  _chip('فيلا', type == 'villa', () => onType('villa')),
                  _chip('منزل', type == 'house', () => onType('house')),
                  _chip('أرض', type == 'land', () => onType('land')),
                  _chip('محل', type == 'shop', () => onType('shop')),
                  _chip('مكتب', type == 'office', () => onType('office')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 7),
        child: ChoiceChip(label: Text(label), selected: selected, onSelected: (_) => onTap()),
      );
}

class _Purpose extends StatelessWidget {
  final String t;
  final IconData ic;
  final bool s;
  final VoidCallback f;
  const _Purpose(this.t, this.ic, this.s, this.f);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: f,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 42,
        decoration: BoxDecoration(
          color: s ? sky : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: s ? teal : line, width: s ? 1.3 : 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(ic, size: 18, color: s ? teal : muted),
            const SizedBox(width: 6),
            Text(t, style: TextStyle(fontWeight: FontWeight.w800, color: s ? teal : ink)),
          ],
        ),
      ),
    );
  }
}'''
text = replace_between(text, 'class _QuickPanel extends StatelessWidget', 'class FullFilter extends StatefulWidget', quick_panel)

map_ctl = r'''class _MapCtl extends StatelessWidget {
  final IconData ic;
  final String t;
  final VoidCallback f;
  const _MapCtl(this.ic, this.t, this.f);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1,
      shadowColor: const Color(0x16000000),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: f,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 42,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
          decoration: BoxDecoration(border: Border.all(color: line), borderRadius: BorderRadius.circular(12)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(ic, color: teal, size: 19),
            const SizedBox(width: 7),
            Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
    );
  }
}'''
text = replace_between(text, 'class _MapCtl extends StatelessWidget', 'class _SwitchBar extends StatelessWidget', map_ctl)

switch_bar = r'''class _SwitchBar extends StatelessWidget {
  final String count;
  final bool map;
  final VoidCallback onSwitch, onAdd;
  const _SwitchBar({required this.count, required this.map, required this.onSwitch, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1,
      shadowColor: const Color(0x12000000),
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 54,
        decoration: BoxDecoration(border: Border.all(color: line), borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Expanded(
            child: InkWell(
              onTap: onSwitch,
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(map ? Icons.view_list_outlined : Icons.map_outlined, size: 21, color: ink),
                const SizedBox(width: 7),
                Text(map ? 'قائمة' : 'خريطة', style: const TextStyle(fontWeight: FontWeight.w800)),
              ]),
            ),
          ),
          const SizedBox(height: 28, child: VerticalDivider(width: 1, color: line)),
          Expanded(child: Center(child: Text(count, style: const TextStyle(fontWeight: FontWeight.w800, color: ink)))),
          const SizedBox(height: 28, child: VerticalDivider(width: 1, color: line)),
          Expanded(
            child: InkWell(
              onTap: onAdd,
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.add_rounded, size: 23, color: teal),
                SizedBox(width: 5),
                Text('إضافة', style: TextStyle(color: teal, fontWeight: FontWeight.w800)),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}'''
text = replace_between(text, 'class _SwitchBar extends StatelessWidget', 'class MapArt extends StatelessWidget', switch_bar)

selected_card = r'''class SelectedCard extends StatelessWidget {
  final P p;
  final VoidCallback onTap;
  const SelectedCard({super.key, required this.p, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: const Color(0x16000000),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 124,
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(border: Border.all(color: line), borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            Img(p.img, w: 112, h: 106, r: BorderRadius.circular(12)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(p.t, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800))),
                  const SizedBox(width: 6),
                  _Badge(p.purpose),
                ]),
                const SizedBox(height: 5),
                Text(p.p, style: const TextStyle(color: teal, fontSize: 16, fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                Text(p.loc, style: const TextStyle(color: muted, fontSize: 11)),
                const Spacer(),
                Row(children: [
                  const Icon(Icons.square_foot, size: 15, color: muted),
                  Text('${p.area.toInt()} م²', style: const TextStyle(fontSize: 11, color: muted)),
                  const SizedBox(width: 12),
                  const Icon(Icons.bed_outlined, size: 15, color: muted),
                  Text('${p.beds} غرف', style: const TextStyle(fontSize: 11, color: muted)),
                ]),
              ]),
            ),
            const Icon(Icons.chevron_left_rounded, color: muted),
          ]),
        ),
      ),
    );
  }
}'''
text = replace_between(text, 'class SelectedCard extends StatelessWidget', 'class PropertyResult extends StatelessWidget', selected_card)

property_result = r'''class PropertyResult extends StatelessWidget {
  final P p;
  final VoidCallback onDetails, onMap;
  const PropertyResult({super.key, required this.p, required this.onDetails, required this.onMap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onDetails,
        child: Container(
          height: 150,
          decoration: BoxDecoration(border: Border.all(color: line), borderRadius: BorderRadius.circular(14)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(
              width: 126,
              child: Stack(fit: StackFit.expand, children: [
                Img(p.img),
                PositionedDirectional(
                  top: 8,
                  start: 8,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border_rounded, size: 20), visualDensity: VisualDensity.compact),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 11, 10, 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    _Badge(p.purpose),
                    const SizedBox(width: 6),
                    _Badge(p.type),
                    const Spacer(),
                    IconButton(onPressed: onMap, icon: const Icon(Icons.location_on_outlined, size: 19), visualDensity: VisualDensity.compact),
                  ]),
                  Text(p.t, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(p.p, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: teal, fontSize: 15, fontWeight: FontWeight.w900)),
                  const Spacer(),
                  Row(children: [
                    const Icon(Icons.square_foot, size: 15, color: muted),
                    Text('${p.area.toInt()} م²', style: const TextStyle(fontSize: 10, color: muted)),
                    if (p.beds > 0) ...[
                      const SizedBox(width: 9),
                      const Icon(Icons.bed_outlined, size: 15, color: muted),
                      Text('${p.beds}', style: const TextStyle(fontSize: 10, color: muted)),
                    ],
                    if (p.baths > 0) ...[
                      const SizedBox(width: 9),
                      const Icon(Icons.bathtub_outlined, size: 15, color: muted),
                      Text('${p.baths}', style: const TextStyle(fontSize: 10, color: muted)),
                    ],
                  ]),
                  const SizedBox(height: 5),
                  Text(p.loc, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 10)),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}'''
text = replace_between(text, 'class PropertyResult extends StatelessWidget', 'class _Badge extends StatelessWidget', property_result)

badge = r'''class _Badge extends StatelessWidget {
  final String t;
  const _Badge(this.t);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(color: sky, borderRadius: BorderRadius.circular(6)),
        child: Text(t, style: const TextStyle(color: navy, fontSize: 9, fontWeight: FontWeight.w700)),
      );
}'''
text = replace_between(text, 'class _Badge extends StatelessWidget', 'class Details extends StatelessWidget', badge)

# Make the map itself visually quieter and more product-like.
text = text.replace("const Color(0xFFBDE7F2)", "const Color(0xFFDDEBED)")
text = text.replace("const Color(0xFFF3EFE6)", "const Color(0xFFF3F1EA)")
text = text.replace("const Color(0xFF77746F)", "const Color(0xFF9AA39F)")
text = text.replace("const Color(0xFFE0D9CF)", "const Color(0xFFD8DCD8)")

# Refine location picking: full screen, clear current-location control, no oversized floating decoration.
location = r'''class _LocationPickerState extends State<LocationPicker> {
  Offset pin = const Offset(190, 360);
  String msg = 'حرّك الدبوس إلى الموقع المطلوب، أو استخدم موقعك الحالي.';
  bool resolving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحديد الموقع')),
      body: LayoutBuilder(builder: (context, k) {
        return Stack(fit: StackFit.expand, children: [
          const MapArt(),
          PositionedDirectional(
            start: 12,
            end: 12,
            top: 12,
            child: SafeArea(
              bottom: false,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    const Icon(Icons.location_on_outlined, color: teal),
                    const SizedBox(width: 8),
                    Expanded(child: Text(msg, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
                  ]),
                ),
              ),
            ),
          ),
          Positioned(
            left: pin.dx - 28,
            top: pin.dy - 58,
            child: GestureDetector(
              onPanUpdate: (d) => setState(() => pin = Offset((pin.dx + d.delta.dx).clamp(32.0, k.maxWidth - 32), (pin.dy + d.delta.dy).clamp(100.0, k.maxHeight - 190))),
              onPanEnd: (_) => setState(() => msg = 'تم تحديث الموقع. راجعه ثم اضغط تأكيد.'),
              child: const SizedBox(width: 56, height: 64, child: Icon(Icons.location_pin, size: 54, color: teal)),
            ),
          ),
          PositionedDirectional(
            end: 12,
            bottom: 164,
            child: FilledButton.tonalIcon(
              onPressed: () => setState(() {
                pin = Offset(k.maxWidth / 2, k.maxHeight / 2);
                msg = 'تم تحديد موقعك الحالي. يمكنك تعديل الدبوس يدويًا.';
              }),
              icon: const Icon(Icons.my_location_rounded),
              label: const Text('موقعي الحالي'),
            ),
          ),
          PositionedDirectional(
            start: 12,
            end: 12,
            bottom: 12,
            child: SafeArea(
              top: false,
              child: Material(
                color: Colors.white,
                elevation: 2,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    const Text('الموقع المحدد', style: TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(resolving ? 'جارٍ قراءة المحافظة والحي والشارع…' : 'بعد التأكيد سنحاول تعبئة المحافظة والحي والشارع تلقائيًا، ويمكن تعديلها لاحقًا.', style: const TextStyle(color: muted, fontSize: 11)),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: resolving ? null : () {
                        setState(() => resolving = true);
                        Future.delayed(const Duration(milliseconds: 700), () {
                          if (!mounted) return;
                          setState(() => resolving = false);
                          Navigator.pop(context);
                        });
                      },
                      icon: resolving ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check_rounded),
                      label: Text(resolving ? 'جارٍ قراءة العنوان…' : 'تأكيد الموقع'),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ]);
      }),
    );
  }
}'''
start = text.find('class _LocationPickerState extends State<LocationPicker>')
if start < 0:
    raise SystemExit('Location picker state not found')
text = text[:start] + location + '\n'

path.write_text(text)
