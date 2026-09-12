from pathlib import Path
import sys

path = Path(sys.argv[1] if len(sys.argv) > 1 else 'buildapp/lib/main.dart')
text = path.read_text()

# V7: Hoolis/Houzi map behaviour + Sare filter + Nestora cards + Aura details.
# Restrained luxury palette: forest, warm ivory, copper accent.
replacements = {
    "const navy = Color(0xFF17352F);": "const navy = Color(0xFF071D12);",
    "const navy2 = Color(0xFF294B44);": "const navy2 = Color(0xFF214536);",
    "const teal = Color(0xFF176B58);": "const teal = Color(0xFF155E49);",
    "const coral = Color(0xFF9B6A3D);": "const coral = Color(0xFF9C6943);",
    "const cream = Color(0xFFF7F7F4);": "const cream = Color(0xFFF7F5EF);",
    "const sand = Color(0xFFEFEEE9);": "const sand = Color(0xFFEEE6DA);",
    "const sky = Color(0xFFE8F1EE);": "const sky = Color(0xFFEAF0EC);",
    "const ink = Color(0xFF18211E);": "const ink = Color(0xFF18201C);",
    "const muted = Color(0xFF66716D);": "const muted = Color(0xFF758078);",
    "const line = Color(0xFFDDE2DE);": "const line = Color(0xFFE3E1DC);",
}
for old, new in replacements.items():
    text = text.replace(old, new)

# Premium property imagery: still royalty-free network photos, not copied paid-template assets.
image_swaps = {
    'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=1200': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1400',
    'https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?w=1200': 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=1400',
    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=1200': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=1400',
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1200': 'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=1400',
}
for old, new in image_swaps.items():
    text = text.replace(old, new)


def replace_between(source: str, start: str, end: str, replacement: str) -> str:
    a = source.find(start)
    if a < 0:
        raise SystemExit(f'missing start marker: {start}')
    b = source.find(end, a)
    if b < 0:
        raise SystemExit(f'missing end marker: {end}')
    return source[:a] + replacement.rstrip() + '\n\n' + source[b:]

# Main map search surface: compact, content-first, inspired by polished property apps.
quick = r'''class _QuickPanel extends StatelessWidget {
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
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: line),
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 18, offset: Offset(0, 5))],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Expanded(
            child: InkWell(
              onTap: onSearch,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 46,
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 13),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: line)),
                child: Row(children: [
                  const Icon(Icons.search_rounded, color: ink, size: 21),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      search.isEmpty ? 'ابحث بالحي أو الشارع أو اسم العقار' : search,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: search.isEmpty ? muted : ink, fontSize: 12, fontWeight: search.isEmpty ? FontWeight.w500 : FontWeight.w700),
                    ),
                  ),
                ]),
              ),
            ),
          ),
          const SizedBox(width: 7),
          InkWell(
            onTap: onMore,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(10)),
              child: Stack(alignment: Alignment.center, children: [
                const Icon(Icons.tune_rounded, color: Colors.white, size: 21),
                if (filterCount > 0)
                  PositionedDirectional(
                    top: 4,
                    end: 4,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(color: coral, borderRadius: BorderRadius.circular(20)),
                      child: Text('$filterCount', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900)),
                    ),
                  ),
              ]),
            ),
          ),
        ]),
        const SizedBox(height: 9),
        Row(children: [
          Expanded(child: _Purpose('للبيع', Icons.sell_outlined, purpose == 'sale', () => onPurpose('sale'))),
          const SizedBox(width: 7),
          Expanded(child: _Purpose('للإيجار', Icons.key_outlined, purpose == 'rent', () => onPurpose('rent'))),
        ]),
        const SizedBox(height: 9),
        SizedBox(
          height: 34,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            _chip('الكل', type == null, () => onType(null)),
            _chip('شقة', type == 'apartment', () => onType('apartment')),
            _chip('فيلا', type == 'villa', () => onType('villa')),
            _chip('منزل', type == 'house', () => onType('house')),
            _chip('أرض', type == 'land', () => onType('land')),
            _chip('محل', type == 'shop', () => onType('shop')),
            _chip('مكتب', type == 'office', () => onType('office')),
          ]),
        ),
      ]),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 6),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          showCheckmark: false,
          side: BorderSide(color: selected ? teal : line),
          backgroundColor: Colors.white,
          selectedColor: sky,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          labelStyle: TextStyle(fontSize: 11, fontWeight: selected ? FontWeight.w800 : FontWeight.w600, color: selected ? teal : ink),
          onSelected: (_) => onTap(),
        ),
      );
}

class _Purpose extends StatelessWidget {
  final String t;
  final IconData ic;
  final bool s;
  final VoidCallback f;
  const _Purpose(this.t, this.ic, this.s, this.f);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: f,
        borderRadius: BorderRadius.circular(9),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 38,
          decoration: BoxDecoration(
            color: s ? navy : Colors.white,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: s ? navy : line),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(ic, size: 17, color: s ? Colors.white : muted),
            const SizedBox(width: 5),
            Text(t, style: TextStyle(fontSize: 12, color: s ? Colors.white : ink, fontWeight: FontWeight.w800)),
          ]),
        ),
      );
}'''
text = replace_between(text, 'class _QuickPanel extends StatelessWidget', 'class FullFilter extends StatefulWidget', quick)

# Sare-inspired filter: clear hierarchy, same product fields, no lost content.
filter_block = r'''class FullFilter extends StatefulWidget {
  final String? initialPurpose, initialType;
  const FullFilter({super.key, this.initialPurpose, this.initialType});
  @override
  State<FullFilter> createState() => _FullFilterState();
}

class _FullFilterState extends State<FullFilter> {
  String? purpose, type;
  int? beds, baths;
  final minPrice = TextEditingController();
  final maxPrice = TextEditingController();
  final minArea = TextEditingController();
  final maxArea = TextEditingController();

  @override
  void initState() {
    super.initState();
    purpose = widget.initialPurpose;
    type = widget.initialType;
  }

  @override
  void dispose() {
    for (final c in [minPrice, maxPrice, minArea, maxArea]) c.dispose();
    super.dispose();
  }

  int get count {
    var n = 0;
    if (purpose != null) n++;
    if (type != null) n++;
    if (minPrice.text.isNotEmpty || maxPrice.text.isNotEmpty) n++;
    if (beds != null) n++;
    if (baths != null) n++;
    if (minArea.text.isNotEmpty || maxArea.text.isNotEmpty) n++;
    return n;
  }

  bool get rooms => ['apartment', 'house', 'villa'].contains(type);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .92),
      decoration: const BoxDecoration(color: Color(0xFFFFFDF9), borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      child: Column(children: [
        const SizedBox(height: 9),
        Container(width: 36, height: 4, decoration: BoxDecoration(color: line, borderRadius: BorderRadius.circular(99))),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 13, 18, 9),
          child: Row(children: [
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('تصفية العقارات', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: ink)),
              SizedBox(height: 2),
              Text('حدد ما يناسبك بدقة', style: TextStyle(color: muted, fontSize: 11)),
            ])),
            TextButton(
              onPressed: () => setState(() {
                purpose = type = null;
                beds = baths = null;
                minPrice.clear(); maxPrice.clear(); minArea.clear(); maxArea.clear();
              }),
              child: const Text('إعادة ضبط', style: TextStyle(color: coral, fontWeight: FontWeight.w800)),
            ),
          ]),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(18, 18, 18, MediaQuery.viewInsetsOf(context).bottom + 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const _FilterLabel('الغرض'),
              const SizedBox(height: 9),
              _FilterSegment(
                labels: const ['الكل', 'للبيع', 'للإيجار'],
                selected: purpose == null ? 0 : purpose == 'sale' ? 1 : 2,
                onChanged: (i) => setState(() => purpose = i == 0 ? null : i == 1 ? 'sale' : 'rent'),
              ),
              const SizedBox(height: 22),
              const _FilterLabel('نوع العقار'),
              const SizedBox(height: 9),
              Wrap(spacing: 7, runSpacing: 7, children: [
                _type('الكل', null), _type('شقة', 'apartment'), _type('منزل', 'house'), _type('فيلا', 'villa'),
                _type('أرض', 'land'), _type('محل', 'shop'), _type('مكتب', 'office'), _type('مزرعة', 'farm'),
              ]),
              if (rooms) ...[
                const SizedBox(height: 22),
                const _FilterLabel('غرف النوم'),
                const SizedBox(height: 9),
                Wrap(spacing: 7, runSpacing: 7, children: [for (final n in [1, 2, 3, 4, 5]) _number('$n+', beds == n, () => setState(() => beds = beds == n ? null : n))]),
                const SizedBox(height: 20),
                const _FilterLabel('الحمامات'),
                const SizedBox(height: 9),
                Wrap(spacing: 7, runSpacing: 7, children: [for (final n in [1, 2, 3, 4]) _number('$n+', baths == n, () => setState(() => baths = baths == n ? null : n))]),
              ],
              const SizedBox(height: 22),
              const _FilterLabel('المساحة'),
              const SizedBox(height: 9),
              Row(children: [
                Expanded(child: TextField(controller: minArea, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'من', suffixText: 'م²'))),
                const SizedBox(width: 9),
                Expanded(child: TextField(controller: maxArea, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'إلى', suffixText: 'م²'))),
              ]),
              const SizedBox(height: 22),
              const _FilterLabel('السعر'),
              const SizedBox(height: 9),
              Row(children: [
                Expanded(child: TextField(controller: minPrice, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'أقل سعر'))),
                const SizedBox(width: 9),
                Expanded(child: TextField(controller: maxPrice, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'أعلى سعر'))),
              ]),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(context, count),
                  icon: const Icon(Icons.search_rounded),
                  label: Text(count == 0 ? 'عرض النتائج' : 'عرض النتائج · $count فلاتر'),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _type(String label, String? value) {
    final selected = type == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      selectedColor: sky,
      side: BorderSide(color: selected ? teal : line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (_) => setState(() => type = value),
    );
  }

  Widget _number(String label, bool selected, VoidCallback onTap) => ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        selectedColor: sky,
        side: BorderSide(color: selected ? teal : line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onSelected: (_) => onTap(),
      );
}

class _FilterLabel extends StatelessWidget {
  final String text;
  const _FilterLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: ink));
}

class _FilterSegment extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  const _FilterSegment({required this.labels, required this.selected, required this.onChanged});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(color: sand, borderRadius: BorderRadius.circular(10)),
        child: Row(children: List.generate(labels.length, (i) => Expanded(
          child: InkWell(
            onTap: () => onChanged(i),
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              height: 39,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: selected == i ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(8), boxShadow: selected == i ? const [BoxShadow(color: Color(0x10000000), blurRadius: 6)] : null),
              child: Text(labels[i], style: TextStyle(fontWeight: FontWeight.w800, color: selected == i ? navy : muted)),
            ),
          ),
        ))),
      );
}'''
text = replace_between(text, 'class FullFilter extends StatefulWidget', 'class SearchSheet extends StatefulWidget', filter_block)

# Houzi-style map price pins: smaller and quieter.
a = text.find('  Widget _pin(')
b = text.find('\n  Widget _drawOverlay', a)
if a < 0 or b < 0:
    raise SystemExit('pin function markers missing')
pin = r'''  Widget _pin(double top, double? left, String label, Color color, int idx, {double? right}) => Positioned(
        top: top,
        left: left,
        right: right,
        child: InkWell(
          onTap: () => setState(() => selected = idx),
          borderRadius: BorderRadius.circular(8),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withValues(alpha: .55)),
                boxShadow: const [BoxShadow(color: Color(0x16000000), blurRadius: 8, offset: Offset(0, 3))],
              ),
              child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 10)),
            ),
            Container(width: 2, height: 5, color: color),
            Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5))),
          ]),
        ),
      );'''
text = text[:a] + pin + text[b:]

# Aura/Nestora detail composition. Content remains project-faithful.
details = r'''class Details extends StatelessWidget {
  final P p;
  const Details(this.p, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 330,
          pinned: true,
          backgroundColor: const Color(0xFFFFFDF9),
          foregroundColor: ink,
          actions: [
            _DetailAction(Icons.favorite_border_rounded, () {}),
            const SizedBox(width: 4),
            _DetailAction(Icons.ios_share_outlined, () {}),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(fit: StackFit.expand, children: [
              Img(p.img),
              const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x33000000), Colors.transparent, Color(0x33000000)]))),
              PositionedDirectional(
                start: 16,
                bottom: 18,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xD9071D12), borderRadius: BorderRadius.circular(8)),
                  child: const Row(children: [Icon(Icons.photo_library_outlined, color: Colors.white, size: 15), SizedBox(width: 5), Text('1 / 8', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800))]),
                ),
              ),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 122),
          sliver: SliverList.list(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.t, style: const TextStyle(fontSize: 23, height: 1.35, fontWeight: FontWeight.w900, color: ink)),
                const SizedBox(height: 6),
                Row(children: [const Icon(Icons.location_on_outlined, size: 17, color: muted), const SizedBox(width: 4), Text(p.loc, style: const TextStyle(color: muted, fontSize: 12))]),
              ])),
              _Badge(p.purpose),
            ]),
            const SizedBox(height: 16),
            Text(p.p, style: const TextStyle(color: navy, fontSize: 25, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _FeatureBox(Icons.square_foot_rounded, '${p.area.toInt()} م²', 'المساحة')),
              if (p.beds > 0) ...[const SizedBox(width: 8), Expanded(child: _FeatureBox(Icons.bed_outlined, '${p.beds}', 'غرف'))],
              if (p.baths > 0) ...[const SizedBox(width: 8), Expanded(child: _FeatureBox(Icons.bathtub_outlined, '${p.baths}', 'حمامات'))],
            ]),
            const SizedBox(height: 22),
            _SectionTitle('السعي'),
            const SizedBox(height: 9),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFF4ECE4), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE6D4C4))),
              child: Row(children: [
                Container(width: 38, height: 38, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.handshake_outlined, color: coral, size: 20)),
                const SizedBox(width: 10),
                Expanded(child: Text(p.sai, style: const TextStyle(fontWeight: FontWeight.w800, color: ink))),
              ]),
            ),
            const SizedBox(height: 24),
            _SectionTitle('المعلن'),
            const SizedBox(height: 9),
            InkWell(
              onTap: () => go(context, const Community()),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: line)),
                child: const Row(children: [
                  CircleAvatar(radius: 23, backgroundColor: sky, child: Icon(Icons.apartment_rounded, color: navy)),
                  SizedBox(width: 11),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [Text('مكتب النخبة العقاري', style: TextStyle(fontWeight: FontWeight.w900)), SizedBox(width: 5), Icon(Icons.verified_rounded, color: teal, size: 17)]),
                    SizedBox(height: 3),
                    Text('مكتب موثق · تقييم 4.7 من 5 · 18 تقييمًا', style: TextStyle(color: muted, fontSize: 11)),
                  ])),
                  Icon(Icons.chevron_left_rounded, color: muted),
                ]),
              ),
            ),
            const SizedBox(height: 24),
            _SectionTitle('أدوات القرار'),
            const SizedBox(height: 9),
            Row(children: [
              Expanded(child: _DecisionTile(Icons.insights_outlined, 'مؤشرات الأسعار', 'قارن بالسوق', () => go(context, const Market()))),
              const SizedBox(width: 9),
              Expanded(child: _DecisionTile(Icons.compare_arrows_rounded, 'المقارنة', 'مع المفضلة', () => go(context, const Favorites(compare: true)))),
            ]),
            const SizedBox(height: 24),
            _SectionTitle('عن العقار'),
            const SizedBox(height: 9),
            const Text('عقار بموقع مميز وتشطيب حديث، قريب من الخدمات والطرق الرئيسية، مع توزيع عملي للمساحات وإضاءة طبيعية جيدة.', style: TextStyle(color: muted, fontSize: 13, height: 1.8)),
            const SizedBox(height: 24),
            _SectionTitle('مزايا إضافية'),
            const SizedBox(height: 9),
            Wrap(spacing: 8, runSpacing: 8, children: const [
              _Amenity(Icons.local_parking_outlined, 'موقف سيارة'),
              _Amenity(Icons.account_balance_outlined, 'حر'),
              _Amenity(Icons.explore_outlined, 'واجهة شمالية'),
            ]),
            const SizedBox(height: 24),
            _SectionTitle('الموقع'),
            const SizedBox(height: 9),
            Container(
              height: 150,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: line)),
              child: Stack(children: [
                const Positioned.fill(child: MapArt()),
                Center(child: Container(width: 38, height: 38, decoration: const BoxDecoration(color: navy, shape: BoxShape.circle), child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 21))),
                PositionedDirectional(start: 10, end: 10, bottom: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .94), borderRadius: BorderRadius.circular(8)), child: Text(p.loc, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)))),
              ]),
            ),
            const SizedBox(height: 24),
            _SectionTitle('عقارات مشابهة'),
            const SizedBox(height: 9),
            ...ps.skip(1).take(2).map((x) => Padding(padding: const EdgeInsets.only(bottom: 10), child: PropertyResult(p: x, onDetails: () => go(context, Details(x)), onMap: () {}))),
          ]),
        ),
      ]),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: line))),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 9, 12, 10),
            child: Row(children: [
              Expanded(child: OutlinedButton.icon(style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), onPressed: () => go(context, Chat(p)), icon: const Icon(Icons.chat_bubble_outline_rounded), label: const Text('مراسلة'))),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: FilledButton.icon(style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), onPressed: () => BookingRequest.show(context, p), icon: const Icon(Icons.calendar_month_outlined), label: const Text('طلب معاينة'))),
            ]),
          ),
        ),
      ),
    );
  }
}

class _DetailAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _DetailAction(this.icon, this.onTap);
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .92), shape: BoxShape.circle), child: IconButton(onPressed: onTap, icon: Icon(icon, size: 20)));
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: ink));
}

class _FeatureBox extends StatelessWidget {
  final IconData icon;
  final String value, label;
  const _FeatureBox(this.icon, this.value, this.label);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: line)),
        child: Column(children: [Icon(icon, size: 20, color: navy), const SizedBox(height: 6), Text(value, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 2), Text(label, style: const TextStyle(color: muted, fontSize: 9))]),
      );
}

class _DecisionTile extends StatelessWidget {
  final IconData icon;
  final String title, sub;
  final VoidCallback onTap;
  const _DecisionTile(this.icon, this.title, this.sub, this.onTap);
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: line)),
          child: Row(children: [
            Container(width: 37, height: 37, decoration: BoxDecoration(color: sky, borderRadius: BorderRadius.circular(9)), child: Icon(icon, size: 19, color: navy)),
            const SizedBox(width: 9),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)), const SizedBox(height: 2), Text(sub, style: const TextStyle(fontSize: 9, color: muted))])),
          ]),
        ),
      );
}

class _Amenity extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Amenity(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: line)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 16, color: muted), const SizedBox(width: 5), Text(label, style: const TextStyle(fontSize: 11, color: ink))]));
}

class _Sec extends StatelessWidget {
  final String t;
  const _Sec(this.t);
  @override
  Widget build(BuildContext context) => Text(t, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17));
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: line)), child: child);
}

class _Fact extends StatelessWidget {
  final IconData i;
  final String t;
  const _Fact(this.i, this.t);
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [Icon(i, size: 17, color: muted), const SizedBox(width: 4), Text(t, style: const TextStyle(color: muted, fontSize: 11))]);
}'''
text = replace_between(text, 'class Details extends StatelessWidget', 'class Market extends StatelessWidget', details)

# Global restraint across remaining screens: smaller radii, lighter surfaces, no oversized visual treatment.
text = text.replace('BorderRadius.circular(24)', 'BorderRadius.circular(14)')
text = text.replace('BorderRadius.circular(22)', 'BorderRadius.circular(13)')
text = text.replace('BorderRadius.circular(20)', 'BorderRadius.circular(12)')
text = text.replace('BorderRadius.circular(18)', 'BorderRadius.circular(11)')
text = text.replace('fontSize:28,fontWeight:FontWeight.w900', 'fontSize:25,fontWeight:FontWeight.w900')

path.write_text(text)
