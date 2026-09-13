from pathlib import Path
import sys

path = Path(sys.argv[1] if len(sys.argv) > 1 else 'buildapp/lib/main.dart')
text = path.read_text()

# Clean-room visual implementation inspired by publicly visible eBroker UI.
# No proprietary eBroker source/assets are used.
repls = {
    "const ink = Color(0xFF111827);": "const ink = Color(0xFF1E2A2A);",
    "const ink2 = Color(0xFF1F2937);": "const ink2 = Color(0xFF2B3B3B);",
    "const coral = Color(0xFFF15D49);": "const coral = Color(0xFF11998E);",
    "const sand = Color(0xFFF1EEE9);": "const sand = Color(0xFFF2F7F6);",
    "const cream = Color(0xFFFAF9F6);": "const cream = Color(0xFFF8FBFA);",
    "const lavender = Color(0xFFF0F2F7);": "const lavender = Color(0xFFEAF4F2);",
    "const blue = Color(0xFF5167D9);": "const blue = Color(0xFF16A394);",
    "const muted = Color(0xFF747A86);": "const muted = Color(0xFF72807D);",
    "const line = Color(0xFFE5E7EB);": "const line = Color(0xFFE1E9E7);",
}
for a,b in repls.items():
    text = text.replace(a,b)


def replace_between(src, start, end, replacement):
    a = src.find(start)
    if a < 0:
        raise SystemExit('missing start: '+start)
    b = src.find(end, a)
    if b < 0:
        raise SystemExit('missing end: '+end)
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
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: line)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 72,
            child: Row(children: [
              _EbrokerNav(label: 'العقارات', icon: Icons.home_outlined, active: index == 0, onTap: () => setState(() => index = 0)),
              _EbrokerNav(label: 'الرسائل', icon: Icons.chat_bubble_outline_rounded, active: index == 1, onTap: () => setState(() => index = 1)),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, -18),
                  child: InkWell(
                    onTap: () => go(context, const DiscoveryMapPage()),
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(color: coral, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0x2A11998E), blurRadius: 14, offset: Offset(0, 6))]),
                      child: const Icon(Icons.map_outlined, color: Colors.white, size: 27),
                    ),
                  ),
                ),
              ),
              _EbrokerNav(label: 'المعاينات', icon: Icons.calendar_month_outlined, active: index == 2, onTap: () => setState(() => index = 2)),
              _EbrokerNav(label: 'حسابي', icon: Icons.person_outline_rounded, active: index == 3, onTap: () => setState(() => index = 3)),
            ]),
          ),
        ),
      ),
    );
  }
}

class _EbrokerNav extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  const _EbrokerNav({required this.label, required this.icon, required this.active, required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 23, color: active ? coral : muted),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.w800 : FontWeight.w600, color: active ? coral : muted)),
      ]),
    ),
  );
}'''
text = replace_between(text, 'class Shell extends StatefulWidget', 'class _NavItem extends StatelessWidget', shell)

home = r'''class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
          sliver: SliverList.list(children: [
            Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(13)), child: const Icon(Icons.location_on_outlined, color: coral)),
              const SizedBox(width: 10),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('الموقع', style: TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w600)),
                SizedBox(height: 2),
                Text('صنعاء، اليمن', style: TextStyle(color: ink, fontSize: 14, fontWeight: FontWeight.w900)),
              ])),
              IconButton(onPressed: () => go(context, const NotificationsPage()), icon: const Icon(Icons.notifications_none_rounded, color: ink)),
            ]),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(
                child: InkWell(
                  onTap: () => go(context, const SearchPage()),
                  borderRadius: BorderRadius.circular(13),
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), border: Border.all(color: line)),
                    child: const Row(children: [
                      Icon(Icons.search_rounded, color: coral, size: 22),
                      SizedBox(width: 9),
                      Expanded(child: Text('ابحث عن عقارك...', style: TextStyle(color: muted, fontWeight: FontWeight.w600))),
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => showFullFilter(context),
                borderRadius: BorderRadius.circular(13),
                child: Container(width: 52, height: 52, decoration: BoxDecoration(color: coral, borderRadius: BorderRadius.circular(13)), child: const Icon(Icons.tune_rounded, color: Colors.white)),
              ),
            ]),
            const SizedBox(height: 14),
            Container(
              height: 170,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
              child: Stack(fit: StackFit.expand, children: [
                const NetImage('https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1400'),
                const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xB7000000), Color(0x16000000)]))),
                PositionedDirectional(
                  start: 18,
                  top: 24,
                  bottom: 24,
                  child: SizedBox(
                    width: 205,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('ابحث بسهولة\nواختر عقارك بثقة', style: TextStyle(color: Colors.white, fontSize: 22, height: 1.35, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      FilledButton.tonal(
                        style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: ink, minimumSize: const Size(118, 38), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: () => go(context, const SearchPage()),
                        child: const Text('استكشف الآن', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 54,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                _CategoryPill(Icons.apartment_outlined, 'شقة'), const SizedBox(width: 8),
                _CategoryPill(Icons.villa_outlined, 'فيلا'), const SizedBox(width: 8),
                _CategoryPill(Icons.home_work_outlined, 'منزل'), const SizedBox(width: 8),
                _CategoryPill(Icons.landscape_outlined, 'أرض'), const SizedBox(width: 8),
                _CategoryPill(Icons.storefront_outlined, 'محل'), const SizedBox(width: 8),
                _CategoryPill(Icons.business_outlined, 'مكتب'),
              ]),
            ),
            const SizedBox(height: 22),
            _SectionHeader('عقارات قريبة منك', 'عرض الكل', () => go(context, const SearchPage())),
            const SizedBox(height: 10),
            SizedBox(
              height: 250,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: props.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => SizedBox(width: 265, child: PropertyCard(props[i], hero: true)),
              ),
            ),
            const SizedBox(height: 22),
            _SectionHeader('الأكثر إعجابًا', 'عرض الكل', () => go(context, const FavoritesPage())),
            const SizedBox(height: 10),
            ...props.reversed.take(3).map((p) => Padding(padding: const EdgeInsets.only(bottom: 10), child: PropertyCard(p))),
            const SizedBox(height: 18),
            _SectionHeader('أدواتك', '', () {}),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _ActionTile(Icons.bookmark_border_rounded, 'بحث محفوظ', 'تنبيهات المطابقة', const SavedSearchesPage())),
              const SizedBox(width: 8),
              Expanded(child: _ActionTile(Icons.compare_arrows_rounded, 'المقارنة', '2–4 عقارات', const ComparePage())),
              const SizedBox(width: 8),
              Expanded(child: _ActionTile(Icons.route_outlined, 'رحلتي', 'الخطوة التالية', const JourneyPage())),
            ]),
          ]),
        ),
      ]),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CategoryPill(this.icon, this.label);
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => go(context, const SearchPage()),
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: line)),
      child: Row(children: [Icon(icon, color: coral, size: 18), const SizedBox(width: 6), Text(label, style: const TextStyle(color: ink, fontSize: 11, fontWeight: FontWeight.w800))]),
    ),
  );
}'''
text = replace_between(text, 'class HomePage extends StatelessWidget', 'class _HomeMode extends StatelessWidget', home)

card = r'''class PropertyCard extends StatelessWidget {
  final P p;
  final bool hero;
  const PropertyCard(this.p, {super.key, this.hero = false});
  @override
  Widget build(BuildContext context) {
    if (hero) {
      return InkWell(
        onTap: () => go(context, DetailsPage(p)),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: NetImage(p.image, width: 265, height: 132)),
              PositionedDirectional(top: 9, start: 9, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: coral, borderRadius: BorderRadius.circular(8)), child: Text(p.purpose, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)))),
              PositionedDirectional(top: 9, end: 9, child: Container(width: 34, height: 34, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.favorite_border_rounded, color: coral, size: 19))),
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Icon(_typeIcon(p.type), color: coral, size: 16), const SizedBox(width: 5), Text(p.type, style: const TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w700))]),
                const SizedBox(height: 5),
                Text(p.price, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: coral, fontSize: 16, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ink, fontSize: 14, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Row(children: [const Icon(Icons.location_on_outlined, color: muted, size: 14), const SizedBox(width: 3), Expanded(child: Text(p.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 10)))]),
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
        height: 120,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: line)),
        child: Row(children: [
          ClipRRect(borderRadius: BorderRadius.circular(11), child: NetImage(p.image, width: 108, height: 104)),
          const SizedBox(width: 11),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ink, fontWeight: FontWeight.w900, fontSize: 13))), const Icon(Icons.favorite_border_rounded, color: coral, size: 18)]),
            const SizedBox(height: 5),
            Text(p.price, style: const TextStyle(color: coral, fontWeight: FontWeight.w900, fontSize: 14)),
            const SizedBox(height: 4),
            Row(children: [Icon(_typeIcon(p.type), color: coral, size: 14), const SizedBox(width: 4), Text(p.type, style: const TextStyle(color: muted, fontSize: 10)), const SizedBox(width: 8), const Icon(Icons.location_on_outlined, color: muted, size: 14), const SizedBox(width: 2), Expanded(child: Text(p.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 10)))]),
          ])),
        ]),
      ),
    );
  }
}

IconData _typeIcon(String type) {
  if (type == 'شقة') return Icons.apartment_outlined;
  if (type == 'فيلا') return Icons.villa_outlined;
  if (type == 'أرض') return Icons.landscape_outlined;
  if (type == 'منزل') return Icons.home_work_outlined;
  return Icons.real_estate_agent_outlined;
}'''
text = replace_between(text, 'class PropertyCard extends StatelessWidget', 'class SearchPage extends StatefulWidget', card)

# eBroker-like section header and tiles
section = r'''class _SectionHeader extends StatelessWidget {
  final String title, action;
  final VoidCallback onTap;
  const _SectionHeader(this.title, this.action, this.onTap);
  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Text(title, style: const TextStyle(color: ink, fontSize: 18, fontWeight: FontWeight.w900))),
    if (action.isNotEmpty) TextButton(onPressed: onTap, child: Text(action, style: const TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w700))),
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), border: Border.all(color: line)),
      child: Column(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: coral, size: 19)),
        const SizedBox(height: 8),
        Text(title, textAlign: TextAlign.center, style: const TextStyle(color: ink, fontSize: 11, fontWeight: FontWeight.w900)),
        const SizedBox(height: 2),
        Text(subtitle, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 8)),
      ]),
    ),
  );
}'''
text = replace_between(text, 'class _SectionHeader extends StatelessWidget', 'class PropertyCard extends StatelessWidget', section)

# Refine map pins/cards toward eBroker while keeping our functions.
text = text.replace("color: coral, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x22FF6B5E), blurRadius: 10)]", "color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: coral), boxShadow: const [BoxShadow(color: Color(0x1811998E), blurRadius: 8)]")
text = text.replace("style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)", "style: const TextStyle(color: coral, fontWeight: FontWeight.w900)")

# Details page in the same visual language: big image, teal accents, icon grid, listed by, decision tools.
details = r'''class DetailsPage extends StatelessWidget {
  final P p;
  const DetailsPage(this.p, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScrollView(slivers: [
      SliverAppBar(
        pinned: true,
        expandedHeight: 300,
        backgroundColor: cream,
        foregroundColor: ink,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        ],
        flexibleSpace: FlexibleSpaceBar(background: Stack(fit: StackFit.expand, children: [
          NetImage(p.image),
          const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x33000000), Colors.transparent, Color(0x22000000)]))),
          PositionedDirectional(start: 14, bottom: 14, child: Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: coral, borderRadius: BorderRadius.circular(8)), child: Text(p.purpose, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)))),
        ])),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 120),
        sliver: SliverList.list(children: [
          Text(p.title, style: const TextStyle(color: ink, fontSize: 23, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Row(children: [const Icon(Icons.location_on_outlined, color: muted, size: 17), const SizedBox(width: 4), Text(p.location, style: const TextStyle(color: muted, fontSize: 12))]),
          const SizedBox(height: 12),
          Text(p.price, style: const TextStyle(color: coral, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          Row(children: const [
            Expanded(child: _EFeature(Icons.square_foot_outlined, '12 لبنة', 'المساحة')),
            SizedBox(width: 8),
            Expanded(child: _EFeature(Icons.bed_outlined, '5', 'غرف')),
            SizedBox(width: 8),
            Expanded(child: _EFeature(Icons.bathtub_outlined, '4', 'حمامات')),
          ]),
          const SizedBox(height: 20),
          const _H2('السعي'),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.handshake_outlined, color: coral), const SizedBox(width: 9), Expanded(child: Text(p.sai, style: const TextStyle(color: ink, fontWeight: FontWeight.w800)))])),
          const SizedBox(height: 20),
          const _H2('عن العقار'),
          const SizedBox(height: 8),
          const Text('عقار بموقع مميز وتشطيب حديث، قريب من الخدمات والطرق الرئيسية، مع توزيع عملي للمساحات وإضاءة طبيعية جيدة.', style: TextStyle(color: muted, height: 1.7, fontSize: 12)),
          const SizedBox(height: 20),
          const _H2('المعلن'),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), border: Border.all(color: line)), child: const Row(children: [CircleAvatar(radius: 22, backgroundColor: lavender, child: Icon(Icons.business_outlined, color: coral)), SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text('مكتب النخبة العقاري', style: TextStyle(color: ink, fontWeight: FontWeight.w900)), SizedBox(width: 4), Icon(Icons.verified_rounded, color: coral, size: 16)]), SizedBox(height: 3), Text('مكتب موثق · تقييم 4.7', style: TextStyle(color: muted, fontSize: 10))])), Icon(Icons.chevron_left_rounded, color: muted)])),
          const SizedBox(height: 20),
          const _H2('أدوات القرار'),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _MiniAction(Icons.insights_outlined, 'مؤشرات الأسعار', () => go(context, const MarketPage()))),
            const SizedBox(width: 8),
            Expanded(child: _MiniAction(Icons.compare_arrows_rounded, 'المقارنة', () => go(context, const ComparePage()))),
          ]),
          const SizedBox(height: 20),
          const _H2('قريب من العقار'),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: const [
            _Facility(Icons.school_outlined, 'مدرسة', '1.2 كم'),
            _Facility(Icons.local_hospital_outlined, 'مستشفى', '2.1 كم'),
            _Facility(Icons.shopping_cart_outlined, 'بقالة', '600 م'),
            _Facility(Icons.local_gas_station_outlined, 'محطة', '1.8 كم'),
          ]),
          const SizedBox(height: 20),
          const _H2('عقارات مشابهة'),
          const SizedBox(height: 8),
          ...props.skip(1).take(2).map((x) => Padding(padding: const EdgeInsets.only(bottom: 9), child: PropertyCard(x))),
        ]),
      ),
    ]),
    bottomSheet: Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 12),
      child: SafeArea(top: false, child: Row(children: [
        Expanded(child: OutlinedButton.icon(style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50), foregroundColor: coral, side: const BorderSide(color: coral), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))), onPressed: () => go(context, ChatPage(p)), icon: const Icon(Icons.chat_bubble_outline_rounded), label: const Text('مراسلة', style: TextStyle(fontWeight: FontWeight.w900)))),
        const SizedBox(width: 8),
        Expanded(child: FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: coral, minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))), onPressed: () => go(context, BookingPage(p)), icon: const Icon(Icons.calendar_month_outlined), label: const Text('طلب معاينة'))),
      ])),
    ),
  );
}

class _EFeature extends StatelessWidget {
  final IconData icon;
  final String value, label;
  const _EFeature(this.icon, this.value, this.label);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: line)), child: Column(children: [Icon(icon, color: coral, size: 19), const SizedBox(height: 5), Text(value, style: const TextStyle(color: ink, fontWeight: FontWeight.w900, fontSize: 12)), const SizedBox(height: 2), Text(label, style: const TextStyle(color: muted, fontSize: 9))]));
}

class _Facility extends StatelessWidget {
  final IconData icon;
  final String title, dist;
  const _Facility(this.icon, this.title, this.dist);
  @override
  Widget build(BuildContext context) => Container(width: 112, padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8), decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(11)), child: Column(children: [Icon(icon, color: coral, size: 19), const SizedBox(height: 4), Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 10)), Text(dist, style: const TextStyle(color: muted, fontSize: 8))]));
}'''
text = replace_between(text, 'class DetailsPage extends StatelessWidget', 'class _Fact extends StatelessWidget', details)

# Normalize rounded corners/teal actions through the rest of V8 without changing content.
text = text.replace('borderRadius: BorderRadius.circular(22)', 'borderRadius: BorderRadius.circular(14)')
text = text.replace('borderRadius: BorderRadius.circular(24)', 'borderRadius: BorderRadius.circular(14)')
text = text.replace('borderRadius: BorderRadius.circular(28)', 'borderRadius: BorderRadius.circular(16)')
text = text.replace('backgroundColor: ink, borderRadius: BorderRadius.circular(30)', 'backgroundColor: coral, borderRadius: BorderRadius.circular(16)')

path.write_text(text)
