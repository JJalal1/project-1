from pathlib import Path
import sys

path = Path(sys.argv[1] if len(sys.argv) > 1 else 'buildapp/lib/main.dart')
text = path.read_text()

# Keep the V3 visual identity the user liked, but make it more deliberate and professional.
replacements = {
    "const ink = Color(0xFF171A2C);": "const ink = Color(0xFF111827);",
    "const ink2 = Color(0xFF23273B);": "const ink2 = Color(0xFF1F2937);",
    "const coral = Color(0xFFFF6B5E);": "const coral = Color(0xFFF15D49);",
    "const sand = Color(0xFFF3EEE6);": "const sand = Color(0xFFF1EEE9);",
    "const cream = Color(0xFFFFFBF6);": "const cream = Color(0xFFFAF9F6);",
    "const lavender = Color(0xFFE9E9FF);": "const lavender = Color(0xFFF0F2F7);",
    "const blue = Color(0xFF6D83F2);": "const blue = Color(0xFF5167D9);",
    "const muted = Color(0xFF777987);": "const muted = Color(0xFF747A86);",
    "const line = Color(0xFFE7E0D6);": "const line = Color(0xFFE5E7EB);",
    "title: 'العقار — تصور بصري V3',": "title: 'العقار',",
    "borderRadius: BorderRadius.circular(28)": "borderRadius: BorderRadius.circular(22)",
    "borderRadius: BorderRadius.circular(30)": "borderRadius: BorderRadius.circular(22)",
}
for old, new in replacements.items():
    text = text.replace(old, new)

# More premium royalty-free imagery.
image_swaps = {
    'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=1200': 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=1400',
    'https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?w=1200': 'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=1400',
    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=1200': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=1400',
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1200': 'https://images.unsplash.com/photo-1600585152915-d208bec867a1?w=1400',
}
for old, new in image_swaps.items():
    text = text.replace(old, new)


def replace_between(src, start, end, replacement):
    a = src.find(start)
    if a < 0:
        raise SystemExit('missing start ' + start)
    b = src.find(end, a)
    if b < 0:
        raise SystemExit('missing end ' + end)
    return src[:a] + replacement.rstrip() + '\n\n' + src[b:]

# Professional home page, preserving the liked composition exactly.
home = r'''class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 52, 20, 28),
          decoration: const BoxDecoration(
            color: ink,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(34), bottomRight: Radius.circular(34)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('مرحبًا بك', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w600)),
                SizedBox(height: 5),
                Text('وين تبحث عن عقارك؟', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28, height: 1.25)),
              ])),
              _RoundIcon(icon: Icons.notifications_none_rounded, color: Colors.white, bg: Colors.white10, onTap: () => go(context, const NotificationsPage())),
            ]),
            const SizedBox(height: 22),
            InkWell(
              onTap: () => go(context, const SearchPage()),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                height: 58,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(18)),
                child: const Row(children: [
                  Icon(Icons.search_rounded, color: ink, size: 24),
                  SizedBox(width: 10),
                  Expanded(child: Text('ابحث بمدينة، حي، شارع أو نوع العقار', style: TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 12))),
                  Icon(Icons.tune_rounded, color: coral, size: 23),
                ]),
              ),
            ),
            const SizedBox(height: 14),
            Row(children: [
              _HomeMode(label: 'شراء', active: true),
              const SizedBox(width: 8),
              _HomeMode(label: 'إيجار', active: false),
              const Spacer(),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  minimumSize: const Size(116, 48),
                ),
                onPressed: () => go(context, const MapPage()),
                icon: const Icon(Icons.map_outlined, size: 19),
                label: const Text('الخريطة', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ]),
          ]),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 112),
        sliver: SliverList.list(children: [
          _SectionHeader('مختارات لك', 'عرض الكل', () => go(context, const SearchPage())),
          const SizedBox(height: 12),
          SizedBox(
            height: 320,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: props.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => SizedBox(width: 294, child: PropertyCard(props[i], hero: true)),
            ),
          ),
          const SizedBox(height: 28),
          _SectionHeader('أدواتك', '', () {}),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _ActionTile(Icons.favorite_border_rounded, 'المفضلة', '3 عقارات', const FavoritesPage())),
            const SizedBox(width: 10),
            Expanded(child: _ActionTile(Icons.bookmark_border_rounded, 'بحث محفوظ', 'تنبيهات المطابقة', const SavedSearchesPage())),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _ActionTile(Icons.compare_arrows_rounded, 'المقارنة', '2–4 عقارات', const ComparePage())),
            const SizedBox(width: 10),
            Expanded(child: _ActionTile(Icons.route_outlined, 'رحلتي', 'الخطوة التالية', const JourneyPage())),
          ]),
          const SizedBox(height: 28),
          _SectionHeader('قريب من بحثك', '', () {}),
          const SizedBox(height: 12),
          ...props.reversed.take(3).map((p) => Padding(padding: const EdgeInsets.only(bottom: 12), child: PropertyCard(p))),
        ]),
      ),
    ]);
  }
}

class _HomeMode extends StatelessWidget {
  final String label;
  final bool active;
  const _HomeMode({required this.label, required this.active});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 12),
        decoration: BoxDecoration(
          color: active ? coral : Colors.white10,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(label, style: TextStyle(color: Colors.white, fontWeight: active ? FontWeight.w900 : FontWeight.w700)),
      );
}'''
text = replace_between(text, 'class HomePage extends StatelessWidget', 'class _DarkChip extends StatelessWidget', home)

# Full search experience using the actual product fields.
search = r'''class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool map = false;
  String sort = 'الأحدث';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('البحث عن عقار')),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: 'ابحث بمدينة، حي، شارع أو نوع العقار',
                suffixIcon: IconButton(onPressed: () => showFullFilter(context), icon: const Icon(Icons.tune_rounded, color: coral)),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), children: const [
              _FilterChipLabel('بيع'), SizedBox(width: 7), _FilterChipLabel('فيلا'), SizedBox(width: 7), _FilterChipLabel('3+ غرف'), SizedBox(width: 7), _FilterChipLabel('60–100م'),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(children: [
              Expanded(child: _SwitchButton('قائمة', !map, Icons.view_agenda_outlined, () => setState(() => map = false))),
              const SizedBox(width: 8),
              Expanded(child: _SwitchButton('خريطة', map, Icons.map_outlined, () => setState(() => map = true))),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                onSelected: (v) => setState(() => sort = v),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'الأحدث', child: Text('الأحدث')),
                  PopupMenuItem(value: 'السعر الأقل', child: Text('السعر الأقل')),
                  PopupMenuItem(value: 'السعر الأعلى', child: Text('السعر الأعلى')),
                  PopupMenuItem(value: 'الأقرب', child: Text('الأقرب')),
                ],
                child: Container(height: 46, padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: line)), child: Row(children: [const Icon(Icons.sort_rounded, size: 18), const SizedBox(width: 5), Text(sort, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11))])),
              ),
            ]),
          ),
          Expanded(child: map ? const DiscoveryMapPage(embedded: true) : ListView.separated(padding: const EdgeInsets.fromLTRB(16, 8, 16, 24), itemCount: props.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (_, i) => PropertyCard(props[i]))),
        ]),
      );
}

class _FilterChipLabel extends StatelessWidget {
  final String label;
  const _FilterChipLabel(this.label);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8), decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(12)), child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ink)));
}

Future<void> showFullFilter(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: cream,
    builder: (_) => const FullFilterSheet(),
  );
}

class FullFilterSheet extends StatefulWidget {
  const FullFilterSheet({super.key});
  @override
  State<FullFilterSheet> createState() => _FullFilterSheetState();
}

class _FullFilterSheetState extends State<FullFilterSheet> {
  String purpose = 'بيع';
  String type = 'الكل';
  int? beds;
  int? baths;
  final minPrice = TextEditingController();
  final maxPrice = TextEditingController();
  final minArea = TextEditingController();
  final maxArea = TextEditingController();

  @override
  void dispose() {
    minPrice.dispose(); maxPrice.dispose(); minArea.dispose(); maxArea.dispose();
    super.dispose();
  }

  Widget choice(String label, bool active, VoidCallback tap) => InkWell(
        onTap: tap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
          decoration: BoxDecoration(color: active ? ink : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: active ? ink : line)),
          child: Text(label, style: TextStyle(color: active ? Colors.white : ink, fontWeight: FontWeight.w800)),
        ),
      );

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        heightFactor: .94,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
            child: Row(children: [
              const Expanded(child: Text('تصفية العقارات', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900))),
              TextButton(onPressed: () => setState(() { purpose = 'بيع'; type = 'الكل'; beds = baths = null; minPrice.clear(); maxPrice.clear(); minArea.clear(); maxArea.clear(); }), child: const Text('إعادة ضبط', style: TextStyle(color: coral, fontWeight: FontWeight.w800))),
            ]),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(padding: const EdgeInsets.fromLTRB(18, 18, 18, 24), children: [
              const _H2('الغرض'),
              const SizedBox(height: 10),
              Row(children: [Expanded(child: choice('بيع', purpose == 'بيع', () => setState(() => purpose = 'بيع'))), const SizedBox(width: 8), Expanded(child: choice('إيجار', purpose == 'إيجار', () => setState(() => purpose = 'إيجار')))]),
              const SizedBox(height: 22),
              const _H2('نوع العقار'),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 8, children: ['الكل','شقة','فيلا','منزل','أرض','محل','مكتب','مزرعة'].map((x) => choice(x, type == x, () => setState(() => type = x))).toList()),
              const SizedBox(height: 22),
              const _H2('غرف النوم'),
              const SizedBox(height: 10),
              Wrap(spacing: 8, children: [1,2,3,4,5].map((n) => choice('$n+', beds == n, () => setState(() => beds = beds == n ? null : n))).toList()),
              const SizedBox(height: 22),
              const _H2('الحمامات'),
              const SizedBox(height: 10),
              Wrap(spacing: 8, children: [1,2,3,4].map((n) => choice('$n+', baths == n, () => setState(() => baths = baths == n ? null : n))).toList()),
              const SizedBox(height: 22),
              const _H2('المساحة'),
              const SizedBox(height: 10),
              Row(children: [Expanded(child: TextField(controller: minArea, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'من', suffixText: 'م²'))), const SizedBox(width: 8), Expanded(child: TextField(controller: maxArea, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'إلى', suffixText: 'م²')))]),
              const SizedBox(height: 22),
              const _H2('السعر'),
              const SizedBox(height: 10),
              Row(children: [Expanded(child: TextField(controller: minPrice, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'أقل سعر'))), const SizedBox(width: 8), Expanded(child: TextField(controller: maxPrice, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'أعلى سعر')))]),
            ]),
          ),
          SafeArea(top: false, child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء'))), const SizedBox(width: 8), Expanded(flex: 2, child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('عرض 18 نتيجة')))]))),
        ]),
      );
}'''
text = replace_between(text, 'class SearchPage extends StatefulWidget', 'class MapPage extends StatelessWidget', search)

# Full map tools + current location + area drawing, while keeping visual language restrained.
mapblock = r'''class MapPage extends StatelessWidget {
  const MapPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: DiscoveryMapPage());
}

class DiscoveryMapPage extends StatefulWidget {
  final bool embedded;
  const DiscoveryMapPage({super.key, this.embedded = false});
  @override
  State<DiscoveryMapPage> createState() => _DiscoveryMapPageState();
}

class _DiscoveryMapPageState extends State<DiscoveryMapPage> {
  int selected = 0;
  bool drawing = false;
  Offset? a, b;

  @override
  Widget build(BuildContext context) => Stack(children: [
        const Positioned.fill(child: MapCanvasBase()),
        if (!drawing)
          PositionedDirectional(
            start: 14,
            end: 14,
            top: widget.embedded ? 10 : MediaQuery.paddingOf(context).top + 10,
            child: Row(children: [
              if (!widget.embedded) _MapCircle(Icons.arrow_back_rounded, () => Navigator.pop(context)),
              if (!widget.embedded) const SizedBox(width: 8),
              Expanded(child: InkWell(onTap: () => go(context, const SearchPage()), borderRadius: BorderRadius.circular(16), child: Container(height: 50, padding: const EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 15, offset: Offset(0, 5))]), child: const Row(children: [Icon(Icons.search_rounded), SizedBox(width: 8), Expanded(child: Text('ابحث في هذه المنطقة', style: TextStyle(color: muted, fontWeight: FontWeight.w700))), Icon(Icons.tune_rounded, color: coral)]))))
            ]),
          ),
        if (!drawing) ...[
          Positioned(top: 180, right: 70, child: _PricePin('85م', selected == 0, () => setState(() => selected = 0))),
          Positioned(top: 300, left: 60, child: _PricePin('320ألف', selected == 1, () => setState(() => selected = 1))),
          Positioned(top: 405, right: 135, child: _PricePin('42.5م', selected == 2, () => setState(() => selected = 2))),
        ],
        if (!drawing)
          PositionedDirectional(
            end: 14,
            bottom: widget.embedded ? 150 : 218,
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              _MapTool(Icons.bookmark_add_outlined, 'حفظ البحث', () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ البحث')))),
              const SizedBox(height: 7),
              _MapTool(Icons.gesture_rounded, 'رسم منطقة', () => setState(() => drawing = true)),
              const SizedBox(height: 7),
              _MapTool(Icons.my_location_rounded, 'موقعي الحالي', () => go(context, const LocationPickerPage())),
            ]),
          ),
        if (!drawing)
          Positioned(left: 14, right: 14, bottom: widget.embedded ? 12 : 86, child: PropertyCard(props[selected])),
        if (!drawing && !widget.embedded)
          Positioned(left: 14, right: 14, bottom: 16, child: Container(height: 54, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x18000000), blurRadius: 16)]), child: Row(children: [
            Expanded(child: InkWell(onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SearchPage())), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.view_list_outlined), SizedBox(width: 6), Text('قائمة', style: TextStyle(fontWeight: FontWeight.w900))]))),
            Container(width: 1, height: 30, color: line),
            const Expanded(child: Center(child: Text('18 نتيجة', style: TextStyle(fontWeight: FontWeight.w900)))),
          ]))),
        if (drawing)
          Positioned.fill(
            child: GestureDetector(
              onPanStart: (d) => setState(() => a = d.localPosition),
              onPanUpdate: (d) => setState(() => b = d.localPosition),
              child: CustomPaint(painter: _AreaPainter(a, b)),
            ),
          ),
        if (drawing)
          PositionedDirectional(
            start: 16,
            end: 16,
            bottom: 24,
            child: SafeArea(top: false, child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(18)), child: Row(children: [
              const Expanded(child: Text('ارسم بإصبعك المنطقة التي تريد البحث داخلها', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12))),
              TextButton(onPressed: () => setState(() { drawing = false; a = b = null; }), child: const Text('إلغاء', style: TextStyle(color: Colors.white70))),
              FilledButton(style: FilledButton.styleFrom(backgroundColor: coral), onPressed: () => setState(() => drawing = false), child: const Text('اعتماد')),
            ]))),
          ),
      ]);
}

class _PricePin extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;
  const _PricePin(this.text, this.active, this.onTap);
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7), decoration: BoxDecoration(color: active ? coral : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: active ? coral : line), boxShadow: const [BoxShadow(color: Color(0x16000000), blurRadius: 8)]), child: Text(text, style: TextStyle(color: active ? Colors.white : ink, fontWeight: FontWeight.w900, fontSize: 11))));
}

class _MapCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _MapCircle(this.icon, this.onTap);
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x16000000), blurRadius: 12)]), child: Icon(icon, color: ink)));
}

class _MapTool extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MapTool(this.icon, this.label, this.onTap);
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14), child: Container(height: 42, padding: const EdgeInsets.symmetric(horizontal: 11), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 9)]), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 18, color: ink), const SizedBox(width: 6), Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800))])));
}

class _AreaPainter extends CustomPainter {
  final Offset? a, b;
  _AreaPainter(this.a, this.b);
  @override
  void paint(Canvas canvas, Size size) {
    if (a == null || b == null) return;
    final rect = Rect.fromPoints(a!, b!);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20)), Paint()..color = coral.withValues(alpha: .15));
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20)), Paint()..color = coral..style = PaintingStyle.stroke..strokeWidth = 3);
  }
  @override
  bool shouldRepaint(covariant _AreaPainter oldDelegate) => true;
}

class MapCanvasBase extends StatelessWidget {
  const MapCanvasBase({super.key});
  @override
  Widget build(BuildContext context) => Container(color: const Color(0xFFE6E4DF), child: CustomPaint(painter: _MapPainter(), child: const SizedBox.expand()));
}

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});
  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  Offset pin = const Offset(190, 360);
  String status = 'حرّك الدبوس أو استخدم موقعك الحالي';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('تحديد الموقع')),
        body: LayoutBuilder(builder: (context, box) => Stack(children: [
          const Positioned.fill(child: MapCanvasBase()),
          Positioned(
            left: pin.dx - 26,
            top: pin.dy - 52,
            child: GestureDetector(
              onPanUpdate: (d) => setState(() => pin = Offset((pin.dx + d.delta.dx).clamp(30.0, box.maxWidth - 30), (pin.dy + d.delta.dy).clamp(90.0, box.maxHeight - 190))),
              onPanEnd: (_) => setState(() => status = 'تم تحديث الموقع المحدد'),
              child: const Icon(Icons.location_pin, size: 54, color: coral),
            ),
          ),
          PositionedDirectional(
            end: 14,
            bottom: 178,
            child: FilledButton.tonalIcon(onPressed: () => setState(() { pin = Offset(box.maxWidth / 2, box.maxHeight / 2); status = 'تم تحديد موقعك الحالي'; }), icon: const Icon(Icons.my_location_rounded), label: const Text('موقعي الحالي')),
          ),
          PositionedDirectional(
            start: 14,
            end: 14,
            bottom: 14,
            child: SafeArea(top: false, child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 18)]), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(status, style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 5),
              const Text('بعد التأكيد سيتم تعبئة المحافظة والحي والشارع تلقائيًا متى توفرت بيانات الموقع.', style: TextStyle(color: muted, fontSize: 11, height: 1.5)),
              const SizedBox(height: 12),
              FilledButton(onPressed: () => Navigator.pop(context), child: const Text('تأكيد الموقع')),
            ]))),
          ),
        ])),
      );

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()..color = Colors.white..strokeWidth = 7..strokeCap = StrokeCap.round;
    final minor = Paint()..color = const Color(0xFFCFCBC4)..strokeWidth = 2;
    for (int i = 1; i < 7; i++) canvas.drawLine(Offset(0, size.height * i / 7), Offset(size.width, size.height * i / 7 - 26), road);
    for (int i = 1; i < 6; i++) canvas.drawLine(Offset(size.width * i / 6, 0), Offset(size.width * i / 6 + 28, size.height), road);
    for (int i = 1; i < 10; i++) canvas.drawCircle(Offset(size.width * (i % 5) / 5 + 20, size.height * i / 11), 2, minor);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}'''
text = replace_between(text, 'class MapPage extends StatelessWidget', 'class DetailsPage extends StatelessWidget', mapblock)

# Tone down overly rounded/AI-ish visuals across the rest, without changing content.
text = text.replace('BorderRadius.circular(24)', 'BorderRadius.circular(18)')
text = text.replace('BorderRadius.circular(22)', 'BorderRadius.circular(18)')
text = text.replace('BorderRadius.circular(20)', 'BorderRadius.circular(16)')
text = text.replace('BorderRadius.circular(18)', 'BorderRadius.circular(16)')

path.write_text(text)
