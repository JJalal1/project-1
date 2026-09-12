from pathlib import Path
import sys

path = Path(sys.argv[1] if len(sys.argv) > 1 else 'buildapp/lib/main.dart')
text = path.read_text()

# Rebuild the public UI in the visual language of eBroker without copying its paid source/assets.
replacements = {
    "const ink = Color(0xFF111827);": "const ink = Color(0xFF202828);",
    "const ink2 = Color(0xFF1F2937);": "const ink2 = Color(0xFF344141);",
    "const coral = Color(0xFFF15D49);": "const coral = Color(0xFF0B8F88);",
    "const sand = Color(0xFFF1EEE9);": "const sand = Color(0xFFF1F7F6);",
    "const cream = Color(0xFFFAF9F6);": "const cream = Color(0xFFF9FBFB);",
    "const lavender = Color(0xFFF0F2F7);": "const lavender = Color(0xFFE9F6F4);",
    "const blue = Color(0xFF5167D9);": "const blue = Color(0xFF0B8F88);",
    "const muted = Color(0xFF747A86);": "const muted = Color(0xFF7B8887);",
    "const line = Color(0xFFE5E7EB);": "const line = Color(0xFFE4ECEB);",
    "colorScheme: ColorScheme.fromSeed(seedColor: coral, brightness: Brightness.light)": "colorScheme: ColorScheme.fromSeed(seedColor: coral, brightness: Brightness.light)",
    "backgroundColor: coral,": "backgroundColor: coral,",
    "BorderRadius.circular(22)": "BorderRadius.circular(16)",
    "BorderRadius.circular(20)": "BorderRadius.circular(15)",
}
for old, new in replacements.items():
    text = text.replace(old, new)


def replace_between(src, start, end, replacement):
    a = src.find(start)
    if a < 0:
        raise SystemExit('missing start marker: ' + start)
    b = src.find(end, a)
    if b < 0:
        raise SystemExit('missing end marker: ' + end)
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 58,
        height: 58,
        child: FloatingActionButton(
          heroTag: 'main_map_action',
          elevation: 3,
          backgroundColor: coral,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          onPressed: () => go(context, const MapPage()),
          child: const Icon(Icons.map_outlined, size: 26),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 72,
        padding: EdgeInsets.zero,
        color: Colors.white,
        elevation: 10,
        shadowColor: const Color(0x24000000),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SafeArea(
          top: false,
          child: Row(children: [
            _EBNav(active: index == 0, icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'العقارات', onTap: () => setState(() => index = 0)),
            _EBNav(active: index == 1, icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded, label: 'الرسائل', onTap: () => setState(() => index = 1)),
            const SizedBox(width: 66),
            _EBNav(active: index == 2, icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month_rounded, label: 'المعاينات', onTap: () => setState(() => index = 2)),
            _EBNav(active: index == 3, icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'حسابي', onTap: () => setState(() => index = 3)),
          ]),
        ),
      ),
    );
  }
}

class _EBNav extends StatelessWidget {
  final bool active;
  final IconData icon, activeIcon;
  final String label;
  final VoidCallback onTap;
  const _EBNav({required this.active, required this.icon, required this.activeIcon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
        child: InkWell(
          onTap: onTap,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(active ? activeIcon : icon, size: 23, color: active ? coral : muted),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(fontSize: 9.5, fontWeight: active ? FontWeight.w800 : FontWeight.w600, color: active ? coral : muted)),
          ]),
        ),
      );
}'''
text = replace_between(text, 'class Shell extends StatefulWidget', 'class HomePage extends StatelessWidget', shell)

home = r'''class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const categories = [
      ('فيلا', Icons.villa_outlined),
      ('شقة', Icons.apartment_outlined),
      ('منزل', Icons.home_work_outlined),
      ('أرض', Icons.landscape_outlined),
      ('محل', Icons.storefront_outlined),
      ('مكتب', Icons.business_outlined),
    ];

    return SafeArea(
      bottom: false,
      child: CustomScrollView(slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 108),
          sliver: SliverList.list(children: [
            Row(children: [
              Expanded(
                child: InkWell(
                  onTap: () => go(context, const LocationPickerPage()),
                  borderRadius: BorderRadius.circular(10),
                  child: const Row(children: [
                    Icon(Icons.location_on_outlined, color: coral, size: 21),
                    SizedBox(width: 6),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('الموقع', style: TextStyle(color: muted, fontSize: 9.5)),
                      SizedBox(height: 1),
                      Row(children: [Text('صنعاء · حدة', style: TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 13)), SizedBox(width: 3), Icon(Icons.keyboard_arrow_down_rounded, size: 17, color: muted)]),
                    ]),
                  ]),
                ),
              ),
              _RoundIcon(icon: Icons.notifications_none_rounded, color: ink, bg: Colors.white, onTap: () => go(context, const NotificationsPage())),
            ]),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => go(context, const SearchPage()),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: line)),
                child: const Row(children: [
                  Icon(Icons.search_rounded, color: muted, size: 22),
                  SizedBox(width: 9),
                  Expanded(child: Text('ابحث عن حي، شارع أو نوع عقار', style: TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w500))),
                  Icon(Icons.tune_rounded, color: coral, size: 21),
                ]),
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 174,
                child: Stack(fit: StackFit.expand, children: [
                  NetImage(props[0].image),
                  const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerRight, end: Alignment.centerLeft, colors: [Color(0xBB102524), Color(0x1A102524)]))),
                  PositionedDirectional(
                    start: 16,
                    top: 18,
                    bottom: 18,
                    child: SizedBox(
                      width: 185,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: coral, borderRadius: BorderRadius.circular(6)), child: const Text('اكتشف', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800))),
                        const SizedBox(height: 8),
                        const Text('اعثر على عقارك المناسب', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 21, height: 1.25)),
                        const SizedBox(height: 5),
                        const Text('ابحث بالخريطة أو صفِّ النتائج حسب احتياجك', style: TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.45)),
                        const SizedBox(height: 10),
                        SizedBox(height: 35, child: FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: ink, padding: const EdgeInsets.symmetric(horizontal: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))), onPressed: () => go(context, const SearchPage()), child: const Text('ابدأ البحث', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800)))),
                      ]),
                    ),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => _EBCategory(label: categories[i].$1, icon: categories[i].$2, onTap: () => go(context, const SearchPage())),
              ),
            ),
            const SizedBox(height: 22),
            _SectionHeader('قريب منك', 'عرض الكل', () => go(context, const SearchPage())),
            const SizedBox(height: 11),
            SizedBox(
              height: 264,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: props.length,
                separatorBuilder: (_, __) => const SizedBox(width: 11),
                itemBuilder: (_, i) => SizedBox(width: 245, child: PropertyCard(props[i], hero: true)),
              ),
            ),
            const SizedBox(height: 24),
            _SectionHeader('أدواتك', '', () {}),
            const SizedBox(height: 11),
            Row(children: [
              Expanded(child: _ActionTile(Icons.favorite_border_rounded, 'المفضلة', 'العقارات المحفوظة', const FavoritesPage())),
              const SizedBox(width: 9),
              Expanded(child: _ActionTile(Icons.bookmark_border_rounded, 'بحث محفوظ', 'تنبيهات المطابقة', const SavedSearchesPage())),
            ]),
            const SizedBox(height: 9),
            Row(children: [
              Expanded(child: _ActionTile(Icons.compare_arrows_rounded, 'المقارنة', 'قارن 2–4 عقارات', const ComparePage())),
              const SizedBox(width: 9),
              Expanded(child: _ActionTile(Icons.route_outlined, 'رحلتي', 'تابع خطوتك التالية', const JourneyPage())),
            ]),
            const SizedBox(height: 24),
            _SectionHeader('مختارات لك', 'عرض الكل', () => go(context, const SearchPage())),
            const SizedBox(height: 11),
            ...props.reversed.take(3).map((p) => Padding(padding: const EdgeInsets.only(bottom: 10), child: PropertyCard(p))),
          ]),
        ),
      ]),
    );
  }
}

class _EBCategory extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _EBCategory({required this.label, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 92,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: line)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: coral, size: 20),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: ink, fontSize: 11, fontWeight: FontWeight.w700)),
          ]),
        ),
      );
}'''
text = replace_between(text, 'class HomePage extends StatelessWidget', 'class _RoundIcon extends StatelessWidget', home)

section = r'''class _SectionHeader extends StatelessWidget {
  final String title, action;
  final VoidCallback onTap;
  const _SectionHeader(this.title, this.action, this.onTap);
  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: ink))),
        if (action.isNotEmpty) TextButton(onPressed: onTap, child: Text(action, style: const TextStyle(color: coral, fontSize: 11, fontWeight: FontWeight.w800))),
      ]);
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Widget page;
  const _ActionTile(this.icon, this.title, this.subtitle, this.page);
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => go(context, page),
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), border: Border.all(color: line)),
          child: Row(children: [
            Container(width: 38, height: 38, decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: coral, size: 20)),
            const SizedBox(width: 9),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: ink, fontSize: 12)),
              const SizedBox(height: 2),
              Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 9.5)),
            ])),
          ]),
        ),
      );
}'''
text = replace_between(text, 'class _SectionHeader extends StatelessWidget', 'class PropertyCard extends StatelessWidget', section)

property_card = r'''class PropertyCard extends StatelessWidget {
  final P p;
  final bool hero;
  const PropertyCard(this.p, {super.key, this.hero = false});

  @override
  Widget build(BuildContext context) {
    if (hero) {
      return InkWell(
        onTap: () => go(context, DetailsPage(p)),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 145,
              child: Stack(fit: StackFit.expand, children: [
                NetImage(p.image),
                PositionedDirectional(top: 9, start: 9, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: coral, borderRadius: BorderRadius.circular(6)), child: Text(p.purpose, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)))),
                PositionedDirectional(top: 8, end: 8, child: Container(width: 34, height: 34, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .94), shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 7)]), child: const Icon(Icons.favorite_border_rounded, color: coral, size: 19))),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Icon(_typeIcon(p.type), size: 16, color: coral), const SizedBox(width: 5), Text(p.type, style: const TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w600))]),
                const SizedBox(height: 5),
                Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ink, fontSize: 14, fontWeight: FontWeight.w800)),
                const SizedBox(height: 5),
                Row(children: [const Icon(Icons.location_on_outlined, size: 14, color: muted), const SizedBox(width: 3), Expanded(child: Text(p.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 10)))]),
                const SizedBox(height: 8),
                Text(p.price, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: coral, fontSize: 15, fontWeight: FontWeight.w900)),
              ]),
            ),
          ]),
        ),
      );
    }

    return InkWell(
      onTap: () => go(context, DetailsPage(p)),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 126,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: line)),
        child: Row(children: [
          ClipRRect(borderRadius: BorderRadius.circular(11), child: NetImage(p.image, width: 108, height: 108)),
          const SizedBox(width: 11),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Icon(_typeIcon(p.type), color: coral, size: 15), const SizedBox(width: 4), Text(p.type, style: const TextStyle(color: muted, fontSize: 9.5)), const Spacer(), Container(width: 30, height: 30, decoration: BoxDecoration(color: lavender, shape: BoxShape.circle), child: const Icon(Icons.favorite_border_rounded, color: coral, size: 17))]),
            const SizedBox(height: 5),
            Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 13)),
            const SizedBox(height: 4),
            Text(p.price, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: coral, fontWeight: FontWeight.w900, fontSize: 13.5)),
            const Spacer(),
            Row(children: [const Icon(Icons.location_on_outlined, color: muted, size: 13), const SizedBox(width: 3), Expanded(child: Text(p.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 9.5)))]),
          ])),
        ]),
      ),
    );
  }

  IconData _typeIcon(String type) {
    if (type.contains('فيلا')) return Icons.villa_outlined;
    if (type.contains('شقة')) return Icons.apartment_outlined;
    if (type.contains('أرض')) return Icons.landscape_outlined;
    if (type.contains('منزل')) return Icons.home_work_outlined;
    if (type.contains('مكتب')) return Icons.business_outlined;
    return Icons.storefront_outlined;
  }
}'''
text = replace_between(text, 'class PropertyCard extends StatelessWidget', 'class SearchPage extends StatefulWidget', property_card)

# eBroker-like property details: image first, white surface, teal information hierarchy.
details = r'''class DetailsPage extends StatelessWidget {
  final P p;
  const DetailsPage(this.p, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: cream,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text('تفاصيل العقار', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border_rounded)), IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined))],
        ),
        body: ListView(padding: const EdgeInsets.only(bottom: 110), children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: ClipRRect(borderRadius: BorderRadius.circular(15), child: SizedBox(height: 228, child: Stack(fit: StackFit.expand, children: [
              NetImage(p.image),
              PositionedDirectional(top: 10, start: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: coral, borderRadius: BorderRadius.circular(6)), child: Text(p.purpose, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)))),
              PositionedDirectional(bottom: 10, end: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: const Color(0xC9202828), borderRadius: BorderRadius.circular(7)), child: const Row(children: [Icon(Icons.photo_library_outlined, color: Colors.white, size: 14), SizedBox(width: 4), Text('1 / 8', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700))]))),
            ]))),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(_detailTypeIcon(p.type), color: coral, size: 18), const SizedBox(width: 5), Text(p.type, style: const TextStyle(color: muted, fontSize: 11))]),
              const SizedBox(height: 6),
              Text(p.title, style: const TextStyle(color: ink, fontWeight: FontWeight.w900, fontSize: 20, height: 1.3)),
              const SizedBox(height: 5),
              Row(children: [const Icon(Icons.location_on_outlined, color: muted, size: 16), const SizedBox(width: 3), Text(p.location, style: const TextStyle(color: muted, fontSize: 11))]),
              const SizedBox(height: 12),
              Text(p.price, style: const TextStyle(color: coral, fontWeight: FontWeight.w900, fontSize: 22)),
              const SizedBox(height: 16),
              Row(children: const [
                Expanded(child: _EBFact(Icons.square_foot_rounded, '12 لبنة', 'المساحة')),
                SizedBox(width: 7),
                Expanded(child: _EBFact(Icons.bed_outlined, '5', 'غرف')),
                SizedBox(width: 7),
                Expanded(child: _EBFact(Icons.bathtub_outlined, '4', 'حمامات')),
              ]),
              const SizedBox(height: 18),
              const _H2('السعي'),
              const SizedBox(height: 8),
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.handshake_outlined, color: coral, size: 21), const SizedBox(width: 9), Expanded(child: Text(p.sai, style: const TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 12)))])),
              const SizedBox(height: 18),
              const _H2('المعلن'),
              const SizedBox(height: 8),
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), border: Border.all(color: line)), child: const Row(children: [
                CircleAvatar(radius: 21, backgroundColor: lavender, child: Icon(Icons.business_rounded, color: coral)),
                SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text('مكتب النخبة العقاري', style: TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 12)), SizedBox(width: 4), Icon(Icons.verified_rounded, color: coral, size: 16)]), SizedBox(height: 3), Text('مكتب موثق · تقييم 4.7', style: TextStyle(color: muted, fontSize: 9.5))])),
                Icon(Icons.chevron_left_rounded, color: muted),
              ])),
              const SizedBox(height: 18),
              const _H2('أدوات القرار'),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: _MiniAction(Icons.insights_outlined, 'مؤشرات الأسعار', () => go(context, const MarketPage()))),
                const SizedBox(width: 8),
                Expanded(child: _MiniAction(Icons.compare_arrows_rounded, 'المقارنة', () => go(context, const ComparePage()))),
              ]),
              const SizedBox(height: 18),
              const _H2('عن العقار'),
              const SizedBox(height: 7),
              const Text('عقار بموقع مميز وتشطيب حديث، قريب من الخدمات والطرق الرئيسية، مع توزيع عملي للمساحات وإضاءة طبيعية جيدة.', style: TextStyle(color: muted, fontSize: 12, height: 1.65)),
              const SizedBox(height: 18),
              const _H2('الموقع'),
              const SizedBox(height: 8),
              ClipRRect(borderRadius: BorderRadius.circular(13), child: SizedBox(height: 145, child: Stack(children: [const Positioned.fill(child: MapCanvasBase()), Center(child: Container(width: 38, height: 38, decoration: const BoxDecoration(color: coral, shape: BoxShape.circle), child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 21)))]))),
              const SizedBox(height: 18),
              const _H2('عقارات مشابهة'),
              const SizedBox(height: 8),
              ...props.skip(1).take(2).map((x) => Padding(padding: const EdgeInsets.only(bottom: 9), child: PropertyCard(x))),
            ]),
          ),
        ]),
        bottomSheet: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(12, 9, 12, 10),
          child: SafeArea(top: false, child: Row(children: [
            Expanded(child: OutlinedButton.icon(style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48), side: const BorderSide(color: coral), foregroundColor: coral, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), onPressed: () => go(context, ChatPage(p)), icon: const Icon(Icons.chat_bubble_outline_rounded, size: 19), label: const Text('مراسلة'))),
            const SizedBox(width: 8),
            Expanded(flex: 2, child: FilledButton.icon(style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), onPressed: () => go(context, BookingPage(p)), icon: const Icon(Icons.calendar_month_outlined, size: 19), label: const Text('طلب معاينة'))),
          ])),
        ),
      );

  static IconData _detailTypeIcon(String type) {
    if (type.contains('فيلا')) return Icons.villa_outlined;
    if (type.contains('شقة')) return Icons.apartment_outlined;
    if (type.contains('أرض')) return Icons.landscape_outlined;
    if (type.contains('منزل')) return Icons.home_work_outlined;
    return Icons.business_outlined;
  }
}

class _EBFact extends StatelessWidget {
  final IconData icon;
  final String value, label;
  const _EBFact(this.icon, this.value, this.label);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 5),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11), border: Border.all(color: line)),
        child: Column(children: [Icon(icon, color: coral, size: 20), const SizedBox(height: 4), Text(value, style: const TextStyle(color: ink, fontSize: 11, fontWeight: FontWeight.w900)), const SizedBox(height: 1), Text(label, style: const TextStyle(color: muted, fontSize: 8.5))]),
      );
}'''
text = replace_between(text, 'class DetailsPage extends StatelessWidget', 'class _Fact extends StatelessWidget', details)

# Adjust V8 filter/map controls into the same teal/white template language.
text = text.replace("color: active ? ink : Colors.white", "color: active ? coral : Colors.white")
text = text.replace("border: Border.all(color: active ? ink : line)", "border: Border.all(color: active ? coral : line)")
text = text.replace("color: active ? Colors.white : ink", "color: active ? Colors.white : ink")
text = text.replace("color: const Color(0xFFE6E4DF)", "color: const Color(0xFFE9F0EF)")
text = text.replace("Paint()..color = const Color(0xFFCFCBC4)", "Paint()..color = const Color(0xFFD4DFDE)")

path.write_text(text)
