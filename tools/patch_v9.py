from pathlib import Path
import sys

path = Path(sys.argv[1] if len(sys.argv) > 1 else 'buildapp/lib/main.dart')
text = path.read_text()

# eBroker-inspired design system using our own implementation/assets.
# Keep product content/flows; change only visual composition and interaction style.
replacements = {
    "const ink = Color(0xFF111827);": "const ink = Color(0xFF202B2A);",
    "const ink2 = Color(0xFF1F2937);": "const ink2 = Color(0xFF31403E);",
    "const coral = Color(0xFFF15D49);": "const coral = Color(0xFF0B9188);",
    "const sand = Color(0xFFF1EEE9);": "const sand = Color(0xFFF1F6F5);",
    "const cream = Color(0xFFFAF9F6);": "const cream = Color(0xFFF8FAFA);",
    "const lavender = Color(0xFFF0F2F7);": "const lavender = Color(0xFFE9F5F3);",
    "const blue = Color(0xFF5167D9);": "const blue = Color(0xFF117B73);",
    "const muted = Color(0xFF747A86);": "const muted = Color(0xFF7A8583);",
    "const line = Color(0xFFE5E7EB);": "const line = Color(0xFFE4EBE9);",
}
for old, new in replacements.items():
    text = text.replace(old, new)


def replace_between(src, start, end, replacement):
    a = src.find(start)
    if a < 0:
        raise SystemExit('missing start ' + start)
    b = src.find(end, a)
    if b < 0:
        raise SystemExit('missing end ' + end)
    return src[:a] + replacement.rstrip() + '\n\n' + src[b:]

shell = r'''class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;
  final pages = const [HomePage(), MessagesPage(), ViewingsPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 68,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: line)),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Row(children: [
                _navItem(0, Icons.home_outlined, 'العقارات'),
                _navItem(1, Icons.chat_bubble_outline_rounded, 'الرسائل'),
                const SizedBox(width: 74),
                _navItem(2, Icons.calendar_month_outlined, 'المعاينات'),
                _navItem(3, Icons.person_outline_rounded, 'حسابي'),
              ]),
              Positioned(
                top: -20,
                child: InkWell(
                  onTap: () => go(context, const DiscoveryMapPage()),
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: coral,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 5),
                      boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 12, offset: Offset(0, 5))],
                    ),
                    child: const Icon(Icons.map_outlined, color: Colors.white, size: 27),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int i, IconData icon, String label) {
    final active = index == i;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => index = i),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 21, color: active ? coral : muted),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 9.5, fontWeight: active ? FontWeight.w800 : FontWeight.w600, color: active ? coral : muted)),
        ]),
      ),
    );
  }
}'''
text = replace_between(text, 'class Shell extends StatefulWidget', 'class _NavItem extends StatelessWidget', shell)

# Remove legacy nav class left after replacing Shell.
a = text.find('class _NavItem extends StatelessWidget')
b = text.find('class HomePage extends StatelessWidget', a)
if a >= 0 and b >= 0:
    text = text[:a] + text[b:]

home = r'''class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          sliver: SliverList.list(children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('موقع البحث', style: TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w600)),
                SizedBox(height: 2),
                Row(children: [
                  Icon(Icons.location_on_outlined, color: coral, size: 17),
                  SizedBox(width: 3),
                  Text('صنعاء، اليمن', style: TextStyle(color: ink, fontSize: 13, fontWeight: FontWeight.w900)),
                  SizedBox(width: 3),
                  Icon(Icons.keyboard_arrow_down_rounded, color: muted, size: 18),
                ]),
              ])),
              InkWell(
                onTap: () => go(context, const NotificationsPage()),
                borderRadius: BorderRadius.circular(22),
                child: Container(width: 42, height: 42, decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(21)), child: const Icon(Icons.notifications_none_rounded, color: coral, size: 21)),
              ),
            ]),
            const SizedBox(height: 14),
            InkWell(
              onTap: () => go(context, const SearchPage()),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: line)),
                child: const Row(children: [
                  Icon(Icons.search_rounded, size: 20, color: muted),
                  SizedBox(width: 8),
                  Expanded(child: Text('ابحث عن عقار أو حي أو شارع', style: TextStyle(color: muted, fontSize: 11.5, fontWeight: FontWeight.w600))),
                  Icon(Icons.tune_rounded, size: 21, color: coral),
                ]),
              ),
            ),
            const SizedBox(height: 14),
            _HeroBanner(onTap: () => go(context, DetailsPage(props[0]))),
            const SizedBox(height: 17),
            SizedBox(
              height: 72,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _Category(Icons.apartment_rounded, 'شقة'),
                  _Category(Icons.villa_outlined, 'فيلا'),
                  _Category(Icons.home_work_outlined, 'منزل'),
                  _Category(Icons.landscape_outlined, 'أرض'),
                  _Category(Icons.storefront_outlined, 'محل'),
                  _Category(Icons.business_center_outlined, 'مكتب'),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _SectionHeader('قريب منك', 'عرض الكل', () => go(context, const SearchPage())),
            const SizedBox(height: 10),
            SizedBox(
              height: 250,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: props.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => SizedBox(width: 214, child: PropertyCard(props[i], hero: true)),
              ),
            ),
            const SizedBox(height: 20),
            _SavedSearchStrip(onTap: () => go(context, const SavedSearchesPage())),
            const SizedBox(height: 22),
            _SectionHeader('مختارات لك', 'عرض الكل', () => go(context, const SearchPage())),
            const SizedBox(height: 10),
            ...props.reversed.take(3).map((p) => Padding(padding: const EdgeInsets.only(bottom: 10), child: PropertyCard(p))),
            const SizedBox(height: 14),
            _SectionHeader('أدواتك', '', () {}),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _ToolTile(Icons.favorite_border_rounded, 'المفضلة', () => go(context, const FavoritesPage()))),
              const SizedBox(width: 8),
              Expanded(child: _ToolTile(Icons.compare_arrows_rounded, 'المقارنة', () => go(context, const ComparePage()))),
              const SizedBox(width: 8),
              Expanded(child: _ToolTile(Icons.route_outlined, 'رحلتي', () => go(context, const JourneyPage()))),
            ]),
          ]),
        ),
      ]),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _HeroBanner({required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 148,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(fit: StackFit.expand, children: [
              NetImage(props[0].image),
              const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xCC183432), Color(0x99183432), Color(0x22183432)]))),
              PositionedDirectional(
                start: 16,
                top: 18,
                bottom: 16,
                child: SizedBox(
                  width: 190,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: coral, borderRadius: BorderRadius.circular(6)), child: const Text('للبيع', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900))),
                    const Spacer(),
                    const Text('ابحث عن بيتك القادم', style: TextStyle(color: Colors.white, fontSize: 20, height: 1.25, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 5),
                    const Text('عقارات موثوقة ومعلومات واضحة لاتخاذ قرار أفضل', maxLines: 2, style: TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.4)),
                  ]),
                ),
              ),
            ]),
          ),
        ),
      );
}

class _Category extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Category(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 10),
        child: SizedBox(
          width: 62,
          child: Column(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: coral, size: 21)),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(color: ink, fontSize: 9.5, fontWeight: FontWeight.w700)),
          ]),
        ),
      );
}

class _SavedSearchStrip extends StatelessWidget {
  final VoidCallback onTap;
  const _SavedSearchStrip({required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(12)),
          child: const Row(children: [
            CircleAvatar(radius: 19, backgroundColor: Colors.white, child: Icon(Icons.bookmark_added_outlined, color: coral, size: 20)),
            SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('بحثك المحفوظ وجد نتائج جديدة', style: TextStyle(color: ink, fontSize: 12, fontWeight: FontWeight.w900)),
              SizedBox(height: 3),
              Text('5 عقارات جديدة تطابق بحثك في حدة', style: TextStyle(color: muted, fontSize: 9.5)),
            ])),
            Icon(Icons.chevron_left_rounded, color: coral),
          ]),
        ),
      );
}

class _ToolTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ToolTile(this.icon, this.label, this.onTap);
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 76,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: line)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: coral, size: 22),
            const SizedBox(height: 7),
            Text(label, style: const TextStyle(color: ink, fontSize: 10.5, fontWeight: FontWeight.w800)),
          ]),
        ),
      );
}'''
text = replace_between(text, 'class HomePage extends StatelessWidget', 'class _HomeMode extends StatelessWidget', home)

# Remove V8-only mode class after replacing home.
a = text.find('class _HomeMode extends StatelessWidget')
b = text.find('class _RoundIcon extends StatelessWidget', a)
if a >= 0 and b >= 0:
    text = text[:a] + text[b:]

# Section headers: eBroker-like compact typography.
section = r'''class _SectionHeader extends StatelessWidget {
  final String title, action;
  final VoidCallback onTap;
  const _SectionHeader(this.title, this.action, this.onTap);
  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15.5, color: ink))),
        if (action.isNotEmpty) TextButton(onPressed: onTap, child: Text(action, style: const TextStyle(color: muted, fontSize: 10.5, fontWeight: FontWeight.w700))),
      ]);
}'''
text = replace_between(text, 'class _SectionHeader extends StatelessWidget', 'class _ActionTile extends StatelessWidget', section)

# Property cards: compact image-first eBroker treatment.
card = r'''class PropertyCard extends StatelessWidget {
  final P p;
  final bool hero;
  const PropertyCard(this.p, {super.key, this.hero = false});

  @override
  Widget build(BuildContext context) {
    if (hero) {
      return InkWell(
        onTap: () => go(context, DetailsPage(p)),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Stack(children: [
                Positioned.fill(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(12)), child: NetImage(p.image))),
                PositionedDirectional(top: 9, start: 9, child: Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4), decoration: BoxDecoration(color: coral, borderRadius: BorderRadius.circular(6)), child: Text(p.purpose, style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w900)))),
                PositionedDirectional(top: 8, end: 8, child: Container(width: 32, height: 32, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.favorite_border_rounded, color: coral, size: 18))),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(11, 9, 11, 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Icon(_typeIcon(p.type), size: 14, color: coral), const SizedBox(width: 5), Text(p.type, style: const TextStyle(color: muted, fontSize: 9.5, fontWeight: FontWeight.w700))]),
                const SizedBox(height: 4),
                Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ink, fontSize: 12.5, fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                Text(p.price, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: coral, fontSize: 12.5, fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Row(children: [const Icon(Icons.location_on_outlined, size: 13, color: muted), const SizedBox(width: 2), Expanded(child: Text(p.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 9.5)))]),
              ]),
            ),
          ]),
        ),
      );
    }

    return InkWell(
      onTap: () => go(context, DetailsPage(p)),
      borderRadius: BorderRadius.circular(11),
      child: Container(
        height: 116,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11), border: Border.all(color: line)),
        child: Row(children: [
          Stack(children: [
            ClipRRect(borderRadius: BorderRadius.circular(9), child: NetImage(p.image, width: 104, height: 100)),
            PositionedDirectional(top: 6, start: 6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), decoration: BoxDecoration(color: coral, borderRadius: BorderRadius.circular(5)), child: Text(p.purpose, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800)))),
          ]),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Icon(_typeIcon(p.type), size: 13, color: coral), const SizedBox(width: 4), Text(p.type, style: const TextStyle(color: muted, fontSize: 9)), const Spacer(), const Icon(Icons.favorite_border_rounded, size: 17, color: muted)]),
            const SizedBox(height: 5),
            Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ink, fontSize: 12, fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            Text(p.price, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: coral, fontSize: 12, fontWeight: FontWeight.w900)),
            const Spacer(),
            Row(children: [const Icon(Icons.location_on_outlined, size: 13, color: muted), const SizedBox(width: 2), Expanded(child: Text(p.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 9.5)))]),
          ])),
        ]),
      ),
    );
  }

  static IconData _typeIcon(String type) {
    if (type.contains('فيلا')) return Icons.villa_outlined;
    if (type.contains('شقة')) return Icons.apartment_rounded;
    if (type.contains('أرض')) return Icons.landscape_outlined;
    if (type.contains('محل')) return Icons.storefront_outlined;
    return Icons.home_work_outlined;
  }
}'''
text = replace_between(text, 'class PropertyCard extends StatelessWidget', 'class SearchPage extends StatefulWidget', card)

# Search list header: segmented sale/rent and clean list/map controls.
search_marker = "class _SearchPageState extends State<SearchPage> {"
a = text.find(search_marker)
b = text.find('class _FilterChipLabel extends StatelessWidget', a)
if a < 0 or b < 0:
    raise SystemExit('search block markers missing')
search_block = r'''class _SearchPageState extends State<SearchPage> {
  bool map = false;
  String sort = 'الأحدث';
  String purpose = 'بيع';

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: cream,
        appBar: AppBar(title: const Text('العقارات')),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search_rounded), hintText: 'ابحث عن عقار أو منطقة', suffixIcon: IconButton(onPressed: () => showFullFilter(context), icon: const Icon(Icons.tune_rounded, color: coral)))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 42,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Expanded(child: _PurposeSegment('بيع', purpose == 'بيع', () => setState(() => purpose = 'بيع'))),
                Expanded(child: _PurposeSegment('إيجار', purpose == 'إيجار', () => setState(() => purpose = 'إيجار'))),
              ]),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), children: const [
              _FilterChipLabel('فيلا'), SizedBox(width: 7), _FilterChipLabel('3+ غرف'), SizedBox(width: 7), _FilterChipLabel('60–100م'),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 7),
            child: Row(children: [
              const Expanded(child: Text('18 عقار', style: TextStyle(color: ink, fontSize: 13, fontWeight: FontWeight.w900))),
              PopupMenuButton<String>(
                onSelected: (v) => setState(() => sort = v),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'الأحدث', child: Text('الأحدث')),
                  PopupMenuItem(value: 'السعر الأقل', child: Text('السعر الأقل')),
                  PopupMenuItem(value: 'السعر الأعلى', child: Text('السعر الأعلى')),
                  PopupMenuItem(value: 'الأقرب', child: Text('الأقرب')),
                ],
                child: Row(children: [const Icon(Icons.sort_rounded, size: 17, color: muted), const SizedBox(width: 4), Text(sort, style: const TextStyle(color: muted, fontSize: 10.5, fontWeight: FontWeight.w700))]),
              ),
              const SizedBox(width: 14),
              InkWell(onTap: () => setState(() => map = !map), child: Row(children: [Icon(map ? Icons.view_list_outlined : Icons.map_outlined, size: 18, color: coral), const SizedBox(width: 4), Text(map ? 'قائمة' : 'خريطة', style: const TextStyle(color: coral, fontSize: 10.5, fontWeight: FontWeight.w800))])),
            ]),
          ),
          Expanded(child: map ? const DiscoveryMapPage(embedded: true) : ListView.separated(padding: const EdgeInsets.fromLTRB(16, 5, 16, 24), itemCount: props.length, separatorBuilder: (_, __) => const SizedBox(height: 9), itemBuilder: (_, i) => PropertyCard(props[i]))),
        ]),
      );
}

class _PurposeSegment extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _PurposeSegment(this.label, this.active, this.onTap);
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: active ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(8), boxShadow: active ? const [BoxShadow(color: Color(0x10000000), blurRadius: 5)] : null),
          child: Text(label, style: TextStyle(color: active ? coral : muted, fontSize: 11, fontWeight: FontWeight.w900)),
        ),
      );
}'''
text = text[:a] + search_block + '\n\n' + text[b:]

# Global refinements to match eBroker's flatter, smaller-radius visual system.
text = text.replace('BorderRadius.circular(24)', 'BorderRadius.circular(12)')
text = text.replace('BorderRadius.circular(22)', 'BorderRadius.circular(12)')
text = text.replace('BorderRadius.circular(20)', 'BorderRadius.circular(11)')
text = text.replace('BorderRadius.circular(18)', 'BorderRadius.circular(11)')
text = text.replace('BorderRadius.circular(16)', 'BorderRadius.circular(10)')
text = text.replace('backgroundColor: ink,', 'backgroundColor: cream,')
text = text.replace("Text('الرسائل', style: TextStyle(fontSize: 28", "Text('الرسائل', style: TextStyle(fontSize: 22")
text = text.replace("Text('المعاينات', style: TextStyle(fontSize: 28", "Text('المعاينات', style: TextStyle(fontSize: 22")
text = text.replace("Text('حسابي', style: TextStyle(fontSize: 28", "Text('حسابي', style: TextStyle(fontSize: 22")

path.write_text(text)
