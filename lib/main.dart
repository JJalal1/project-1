import 'package:flutter/material.dart';

void main() => runApp(const PreviewApp());

const _brand = Color(0xFF0B7A5B);
const _brandDark = Color(0xFF075B45);
const _surface = Color(0xFFF6F8F7);

class PreviewApp extends StatelessWidget {
  const PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'عقارات - تصور تجريبي',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans',
        colorScheme: ColorScheme.fromSeed(seedColor: _brand, brightness: Brightness.light),
        scaffoldBackgroundColor: _surface,
        appBarTheme: const AppBarTheme(backgroundColor: _surface, surfaceTintColor: Colors.transparent),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
      ),
      builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const RegularUserShell(),
    );
  }
}

class RegularUserShell extends StatefulWidget {
  const RegularUserShell({super.key});

  @override
  State<RegularUserShell> createState() => _RegularUserShellState();
}

class _RegularUserShellState extends State<RegularUserShell> {
  int index = 0;

  final pages = const [PropertiesHome(), MessagesPage(), ViewingsPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'العقارات'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline_rounded), selectedIcon: Icon(Icons.chat_bubble_rounded), label: 'الرسائل'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month_rounded), label: 'المعاينات'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'حسابي'),
        ],
      ),
    );
  }
}

class PropertiesHome extends StatelessWidget {
  const PropertiesHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('اكتشف عقارك المناسب', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Text('بحث واضح، تفاصيل أهم، وقرارات أسرع', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())),
                      icon: const Icon(Icons.notifications_none_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    builder: (_) => const SearchSheet(),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                    child: const Row(children: [Icon(Icons.search_rounded), SizedBox(width: 10), Expanded(child: Text('ابحث عن عقار، منطقة أو نوع...')), Icon(Icons.tune_rounded)]),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: _SegmentButton(label: 'للبيع', icon: Icons.sell_outlined, active: true)),
                    const SizedBox(width: 10),
                    Expanded(child: _SegmentButton(label: 'للإيجار', icon: Icons.key_outlined)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MapSearchPage())),
                        icon: const Icon(Icons.map_outlined),
                        label: const Text('الخريطة'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _HeroBanner(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JourneyPage()))),
                const SizedBox(height: 22),
                const _SectionTitle(title: 'اختصاراتك', subtitle: 'كل أدوات القرار من مكان واحد'),
                const SizedBox(height: 12),
                _QuickActions(),
                const SizedBox(height: 24),
                const _SectionTitle(title: 'عقارات مناسبة لك', subtitle: 'من الإعلانات المنشورة فقط', trailing: 'عرض الكل'),
                const SizedBox(height: 12),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 290,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                scrollDirection: Axis.horizontal,
                reverse: true,
                itemCount: properties.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => SizedBox(width: 255, child: PropertyCard(property: properties[i])),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _SectionTitle(title: 'بحث محفوظ', subtitle: 'تابع ما يهمك بدون إعادة الفلاتر'),
                const SizedBox(height: 12),
                const _SavedSearchCard(),
                const SizedBox(height: 22),
                const _SectionTitle(title: 'آخر عمليات البحث', subtitle: 'ارجع لها بسرعة'),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8, children: ['شقق للإيجار - صنعاء', 'أراضي للبيع - حدة', 'فلل - 3 غرف+'].map((e) => ActionChip(label: Text(e), onPressed: () {})).toList()),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  const _SegmentButton({required this.label, required this.icon, this.active = false});

  @override
  Widget build(BuildContext context) {
    return active
        ? FilledButton.icon(style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), onPressed: () {}, icon: Icon(icon), label: Text(label))
        : FilledButton.tonalIcon(style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), onPressed: () {}, icon: Icon(icon), label: Text(label));
  }
}

class _HeroBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _HeroBanner({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_brandDark, _brand], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('رحلتك العقارية في مكان واحد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
              const SizedBox(height: 8),
              const Text('تابع المفضلة، المعاينات، الرسائل والاتفاقات من مسار واضح.', style: TextStyle(color: Colors.white70, height: 1.5)),
              const SizedBox(height: 14),
              FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: _brandDark), onPressed: onTap, child: const Text('فتح رحلتي')),
            ]),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(radius: 38, backgroundColor: Colors.white12, child: Icon(Icons.route_rounded, size: 40, color: Colors.white)),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      ('المفضلة', Icons.favorite_border_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage()))),
      ('المقارنة', Icons.compare_arrows_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComparePage()))),
      ('مؤشرات الأسعار', Icons.insights_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketContextPage()))),
      ('الخريطة', Icons.map_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MapSearchPage()))),
    ];
    return Row(
      children: items
          .map((item) => Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: item.$3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                      child: Column(children: [Icon(item.$2, color: _brand), const SizedBox(height: 8), Text(item.$1, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))]),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? trailing;
  const _SectionTitle({required this.title, required this.subtitle, this.trailing});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)), const SizedBox(height: 2), Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12))])),
      if (trailing != null) TextButton(onPressed: () {}, child: Text(trailing!)),
    ]);
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PropertyDetailsPage(property: property))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            SizedBox(height: 148, width: double.infinity, child: Image.network(property.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE8EEEB), child: const Icon(Icons.home_work_outlined, size: 50, color: _brand)))),
            Positioned(top: 10, right: 10, child: _StatusPill(text: property.purpose)),
            Positioned(top: 10, left: 10, child: CircleAvatar(backgroundColor: Colors.white.withOpacity(.92), child: const Icon(Icons.favorite_border_rounded, color: _brand))),
          ]),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(property.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              const SizedBox(height: 4),
              Text(property.price, style: const TextStyle(color: _brandDark, fontWeight: FontWeight.w900, fontSize: 17)),
              const SizedBox(height: 5),
              Row(children: [const Icon(Icons.location_on_outlined, size: 16, color: Colors.black45), const SizedBox(width: 3), Expanded(child: Text(property.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54, fontSize: 12)))]),
              const SizedBox(height: 8),
              Row(children: [Text('${property.beds} غرف', style: const TextStyle(fontSize: 12)), const Spacer(), Text('${property.area} لبنة', style: const TextStyle(fontSize: 12)), const Spacer(), Text('السعي ${property.sai}', style: const TextStyle(fontSize: 12, color: _brand))]),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;
  const _StatusPill({required this.text});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: _brand, borderRadius: BorderRadius.circular(30)), child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11)));
}

class _SavedSearchCard extends StatelessWidget {
  const _SavedSearchCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        const CircleAvatar(backgroundColor: Color(0xFFE7F3EF), foregroundColor: _brand, child: Icon(Icons.notifications_active_outlined)),
        const SizedBox(width: 12),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('شقق للإيجار في صنعاء', style: TextStyle(fontWeight: FontWeight.w900)), SizedBox(height: 4), Text('2–4 غرف • حتى 350,000 ر.ي', style: TextStyle(color: Colors.black54, fontSize: 12))])),
        TextButton(onPressed: () {}, child: const Text('تعديل')),
      ]),
    );
  }
}

class SearchSheet extends StatelessWidget {
  const SearchSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('ابحث عن عقارك', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
          const SizedBox(height: 14),
          const TextField(autofocus: true, decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'منطقة، نوع عقار، كلمة مفتاحية', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))))),
          const SizedBox(height: 16),
          const Text('الغرض', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [FilterChip(selected: true, label: const Text('بيع'), onSelected: (_) {}), FilterChip(selected: false, label: const Text('إيجار'), onSelected: (_) {})]),
          const SizedBox(height: 12),
          const Text('نوع العقار', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: ['شقة', 'فيلا', 'بيت', 'أرض'].map((e) => ChoiceChip(selected: e == 'شقة', label: Text(e))).toList()),
          const SizedBox(height: 18),
          FilledButton(onPressed: () => Navigator.pop(context), style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)), child: const Text('عرض النتائج')),
        ]),
      ),
    );
  }
}

class MapSearchPage extends StatelessWidget {
  const MapSearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الخريطة والبحث'), actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.tune_rounded))]),
      body: Column(children: [
        Expanded(
          flex: 5,
          child: Stack(children: [
            Container(color: const Color(0xFFEAF0ED)),
            Positioned.fill(child: CustomPaint(painter: _MapPainter())),
            ...const [
              _MapMarker(top: 90, right: 45, label: '52م'),
              _MapMarker(top: 150, left: 45, label: '68م'),
              _MapMarker(top: 225, right: 120, label: '95م'),
              _MapMarker(top: 280, left: 90, label: '120م'),
            ],
            Positioned(left: 16, bottom: 16, child: FloatingActionButton.small(onPressed: () {}, child: const Icon(Icons.my_location_rounded))),
          ]),
        ),
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            decoration: const BoxDecoration(color: _surface, borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
            child: Column(children: [
              Row(children: [const Expanded(child: Text('6 عقارات في هذه المنطقة', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18))), OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.sort_rounded), label: const Text('ترتيب'))]),
              const SizedBox(height: 8),
              Expanded(child: ListView.separated(itemCount: 3, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (_, i) => _CompactPropertyCard(property: properties[i]))),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()..color = Colors.white..strokeWidth = 10..style = PaintingStyle.stroke;
    final minor = Paint()..color = Colors.white70..strokeWidth = 4..style = PaintingStyle.stroke;
    for (int i = 0; i < 7; i++) {
      final y = (i + 1) * size.height / 8;
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 35), i % 2 == 0 ? road : minor);
    }
    for (int i = 0; i < 5; i++) {
      final x = (i + 1) * size.width / 6;
      canvas.drawLine(Offset(x, 0), Offset(x + 45, size.height), i % 2 == 0 ? road : minor);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapMarker extends StatelessWidget {
  final double? top, left, right;
  final String label;
  const _MapMarker({this.top, this.left, this.right, required this.label});
  @override
  Widget build(BuildContext context) => Positioned(top: top, left: left, right: right, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), decoration: BoxDecoration(color: _brandDark, borderRadius: BorderRadius.circular(16)), child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))));
}

class _CompactPropertyCard extends StatelessWidget {
  final Property property;
  const _CompactPropertyCard({required this.property});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PropertyDetailsPage(property: property))),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Row(children: [
          ClipRRect(borderRadius: BorderRadius.circular(14), child: SizedBox(width: 92, height: 78, child: Image.network(property.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE7EFEB), child: const Icon(Icons.home_work_outlined))))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(property.title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(property.price, style: const TextStyle(color: _brandDark, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(property.location, style: const TextStyle(color: Colors.black54, fontSize: 12))])),
          const Icon(Icons.chevron_left_rounded),
        ]),
      ),
    );
  }
}

class PropertyDetailsPage extends StatelessWidget {
  final Property property;
  const PropertyDetailsPage({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          leading: Padding(padding: const EdgeInsets.all(8), child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)))),
          actions: [Padding(padding: const EdgeInsets.all(8), child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(icon: const Icon(Icons.favorite_border_rounded), onPressed: () {}))), Padding(padding: const EdgeInsetsDirectional.only(end: 8), child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {})))],
          flexibleSpace: FlexibleSpaceBar(background: Image.network(property.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE5ECE8), child: const Icon(Icons.home_work_outlined, size: 80)))),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 120),
          sliver: SliverList(delegate: SliverChildListDelegate([
            Row(children: [_StatusPill(text: property.purpose), const Spacer(), Text(property.price, style: const TextStyle(color: _brandDark, fontSize: 24, fontWeight: FontWeight.w900))]),
            const SizedBox(height: 8),
            Text(property.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Row(children: [const Icon(Icons.location_on_outlined, size: 18, color: Colors.black45), const SizedBox(width: 4), Text(property.location, style: const TextStyle(color: Colors.black54))]),
            const SizedBox(height: 18),
            Row(children: [Expanded(child: _Fact(icon: Icons.bed_outlined, value: '${property.beds}', label: 'غرف')), const SizedBox(width: 8), const Expanded(child: _Fact(icon: Icons.bathtub_outlined, value: '3', label: 'حمامات')), const SizedBox(width: 8), Expanded(child: _Fact(icon: Icons.grid_view_rounded, value: '${property.area}', label: 'لبنة'))]),
            const SizedBox(height: 18),
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFE9F4F0), borderRadius: BorderRadius.circular(18)), child: Row(children: [const Icon(Icons.handshake_outlined, color: _brand), const SizedBox(width: 10), Expanded(child: Text('السعي: ${property.sai} • يدفعه ${property.payer}', style: const TextStyle(fontWeight: FontWeight.w800))), const Icon(Icons.info_outline_rounded, size: 20)])),
            const SizedBox(height: 24),
            const _SectionTitle(title: 'عن العقار', subtitle: 'المعلومات المنشورة من المعلن'),
            const SizedBox(height: 10),
            const Text('عقار سكني مرتب في موقع مميز، بتوزيع عملي ومساحات واضحة. هذا النص تجريبي لعرض شكل التفاصيل فقط، وليس إعلانًا حقيقيًا.', style: TextStyle(height: 1.7, color: Colors.black87)),
            const SizedBox(height: 24),
            InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketContextPage())), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: const Row(children: [CircleAvatar(backgroundColor: Color(0xFFE7F3EF), child: Icon(Icons.insights_rounded, color: _brand)), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('مؤشرات الأسعار', style: TextStyle(fontWeight: FontWeight.w900)), SizedBox(height: 3), Text('قارن السعر بعقارات منشورة مشابهة', style: TextStyle(color: Colors.black54, fontSize: 12))])), Icon(Icons.chevron_left_rounded)]))),
            const SizedBox(height: 24),
            const _SectionTitle(title: 'الموقع', subtitle: 'الموقع التقريبي للعقار'),
            const SizedBox(height: 10),
            Container(height: 160, decoration: BoxDecoration(color: const Color(0xFFEAF0ED), borderRadius: BorderRadius.circular(22)), child: Stack(children: [Positioned.fill(child: CustomPaint(painter: _MapPainter())), const Center(child: CircleAvatar(backgroundColor: _brand, foregroundColor: Colors.white, child: Icon(Icons.location_on_rounded)))])),
          ])),
        )
      ]),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(children: [Expanded(child: OutlinedButton.icon(style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(54)), onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline_rounded), label: const Text('مراسلة'))), const SizedBox(width: 10), Expanded(child: FilledButton.icon(style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BookingPage())), icon: const Icon(Icons.calendar_month_rounded), label: const Text('طلب معاينة')))]),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _Fact({required this.icon, required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)), child: Column(children: [Icon(icon, color: _brand), const SizedBox(height: 6), Text(value, style: const TextStyle(fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(color: Colors.black54, fontSize: 11))]));
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final chats = [('فيلا سكنية - حدة', 'تم تأكيد موعد المعاينة غدًا', '10:42', 2), ('شقة للإيجار - شارع الجزائر', 'هل يناسبك الموعد المسائي؟', 'أمس', 0), ('أرض سكنية - بيت بوس', 'وصلتني رسالتك، شكرًا', 'السبت', 0)];
    return SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(18, 18, 18, 110), children: [
      const Text('الرسائل', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28)),
      const SizedBox(height: 5),
      const Text('محادثات مرتبطة بعقارات محددة', style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 18),
      const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'بحث في المحادثات', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(17))))),
      const SizedBox(height: 18),
      ...chats.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Row(children: [CircleAvatar(radius: 25, backgroundColor: const Color(0xFFE7F3EF), child: const Icon(Icons.home_work_outlined, color: _brand)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(c.$1, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 5), Text(c.$2, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54, fontSize: 12))])), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(c.$3, style: const TextStyle(color: Colors.black45, fontSize: 11)), const SizedBox(height: 6), if (c.$4 > 0) CircleAvatar(radius: 10, backgroundColor: _brand, child: Text('${c.$4}', style: const TextStyle(color: Colors.white, fontSize: 10)))])])))),
    ]));
  }
}

class ViewingsPage extends StatelessWidget {
  const ViewingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(18, 18, 18, 110), children: [
      const Text('المعاينات', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28)),
      const SizedBox(height: 5),
      const Text('مواعيدك وخطواتك القادمة بشكل واضح', style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 18),
      _ViewingCard(title: 'فيلا سكنية - حدة', time: 'غدًا • 4:30 مساءً', status: 'تحتاج تأكيد', primary: 'تأكيد', secondary: 'طلب تغيير'),
      const SizedBox(height: 12),
      _ViewingCard(title: 'شقة - شارع الجزائر', time: '15 سبتمبر • 11:00 صباحًا', status: 'مؤكدة', primary: 'فتح المحادثة', secondary: 'إلغاء'),
      const SizedBox(height: 12),
      _ViewingCard(title: 'أرض - بيت بوس', time: '10 سبتمبر • 1:00 ظهرًا', status: 'مكتملة', primary: 'عرض العقار', secondary: 'إخفاء'),
    ]));
  }
}

class _ViewingCard extends StatelessWidget {
  final String title, time, status, primary, secondary;
  const _ViewingCard({required this.title, required this.time, required this.status, required this.primary, required this.secondary});
  @override
  Widget build(BuildContext context) {
    final isAction = status == 'تحتاج تأكيد';
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17))), Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: isAction ? const Color(0xFFFFF3D8) : const Color(0xFFE7F3EF), borderRadius: BorderRadius.circular(12)), child: Text(status, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: isAction ? const Color(0xFF8A6100) : _brandDark)))]),
      const SizedBox(height: 8),
      Row(children: [const Icon(Icons.schedule_rounded, size: 18, color: Colors.black45), const SizedBox(width: 5), Text(time, style: const TextStyle(color: Colors.black54))]),
      const SizedBox(height: 14),
      Row(children: [Expanded(child: FilledButton(onPressed: () {}, child: Text(primary))), const SizedBox(width: 8), Expanded(child: OutlinedButton(onPressed: () {}, child: Text(secondary)))]),
    ]));
  }
}

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('طلب معاينة')), body: ListView(padding: const EdgeInsets.all(18), children: [
      const Text('اختر الموعد المناسب', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
      const SizedBox(height: 6),
      const Text('المعاينة مرتبطة بهذا العقار والمحادثة الخاصة به.', style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 20),
      Row(children: ['الأحد 13', 'الاثنين 14', 'الثلاثاء 15'].map((e) => Expanded(child: Padding(padding: const EdgeInsetsDirectional.only(end: 8), child: ChoiceChip(selected: e.startsWith('الاثنين'), label: SizedBox(width: double.infinity, child: Text(e, textAlign: TextAlign.center))))).toList()),
      const SizedBox(height: 18),
      Wrap(spacing: 8, runSpacing: 8, children: ['10:00 ص', '12:30 م', '4:30 م', '6:00 م'].map((e) => ChoiceChip(selected: e == '4:30 م', label: Text(e))).toList()),
      const SizedBox(height: 24),
      const TextField(maxLines: 3, decoration: InputDecoration(labelText: 'ملاحظة اختيارية', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))))),
      const SizedBox(height: 24),
      FilledButton(style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)), onPressed: () => Navigator.pop(context), child: const Text('إرسال طلب المعاينة')),
    ]));
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    final items = [
      ('رحلتي العقارية', Icons.route_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JourneyPage()))),
      ('المفضلة', Icons.favorite_border_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage()))),
      ('المقارنة', Icons.compare_arrows_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComparePage()))),
      ('الإشعارات', Icons.notifications_none_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage()))),
      ('تفضيلات الإشعارات', Icons.tune_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationPreferencesPage()))),
      ('المساعدة والدعم', Icons.help_outline_rounded, () {}),
    ];
    return SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(18, 18, 18, 110), children: [
      const Text('حسابي', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28)),
      const SizedBox(height: 18),
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(gradient: const LinearGradient(colors: [_brandDark, _brand]), borderRadius: BorderRadius.circular(24)), child: const Row(children: [CircleAvatar(radius: 30, backgroundColor: Colors.white, foregroundColor: _brand, child: Icon(Icons.person_rounded, size: 30)), SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('مستخدم تجريبي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)), SizedBox(height: 4), Text('حساب مستخدم عادي', style: TextStyle(color: Colors.white70))])), Icon(Icons.edit_outlined, color: Colors.white)])),
      const SizedBox(height: 18),
      ...items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 9), child: ListTile(tileColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), leading: CircleAvatar(backgroundColor: const Color(0xFFE7F3EF), child: Icon(item.$2, color: _brand)), title: Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w800)), trailing: const Icon(Icons.chevron_left_rounded), onTap: item.$3))),
    ]));
  }
}

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key});
  @override
  Widget build(BuildContext context) {
    final steps = [('بحث محفوظ', '3 عمليات بحث نشطة', Icons.search_rounded), ('المفضلة', '4 عقارات للمراجعة', Icons.favorite_rounded), ('المعاينات', 'موعد واحد يحتاج تأكيد', Icons.calendar_month_rounded), ('المحادثات', 'رسالتان غير مقروءتين', Icons.chat_bubble_rounded), ('الاتفاقات', 'لا يوجد إجراء مطلوب الآن', Icons.handshake_outlined)];
    return Scaffold(appBar: AppBar(title: const Text('رحلتي العقارية')), body: ListView(padding: const EdgeInsets.all(18), children: [
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFFE7F3EF), borderRadius: BorderRadius.circular(22)), child: const Row(children: [Icon(Icons.route_rounded, size: 34, color: _brand), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ملخص رحلتك', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)), SizedBox(height: 4), Text('ركز على الخطوة القادمة بدل التنقل بين الشاشات.', style: TextStyle(color: Colors.black54))]))])),
      const SizedBox(height: 18),
      ...steps.asMap().entries.map((entry) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Row(children: [CircleAvatar(backgroundColor: const Color(0xFFE7F3EF), child: Icon(entry.value.$3, color: _brand)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(entry.value.$1, style: const TextStyle(fontWeight: FontWeight.w900)), Text(entry.value.$2, style: const TextStyle(color: Colors.black54, fontSize: 12))])), if (entry.key == 2) const _StatusPill(text: 'إجراء') else const Icon(Icons.chevron_left_rounded)])))),
    ]));
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('المفضلة'), actions: [TextButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComparePage())), icon: const Icon(Icons.compare_arrows_rounded), label: const Text('مقارنة'))]), body: ListView.separated(padding: const EdgeInsets.all(18), itemCount: properties.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (_, i) => _CompactPropertyCard(property: properties[i])));
}

class ComparePage extends StatelessWidget {
  const ComparePage({super.key});
  @override
  Widget build(BuildContext context) {
    final a = properties[0], b = properties[1];
    return Scaffold(appBar: AppBar(title: const Text('مقارنة العقارات')), body: ListView(padding: const EdgeInsets.all(16), children: [
      Row(children: [Expanded(child: _CompareHead(p: a)), const SizedBox(width: 8), Expanded(child: _CompareHead(p: b))]),
      const SizedBox(height: 16),
      _CompareRow(label: 'السعر', a: a.price, b: b.price),
      _CompareRow(label: 'الموقع', a: a.location, b: b.location),
      _CompareRow(label: 'عدد اللبن', a: '${a.area}', b: '${b.area}'),
      _CompareRow(label: 'الغرف', a: '${a.beds}', b: '${b.beds}'),
      _CompareRow(label: 'السعي', a: a.sai, b: b.sai),
    ]));
  }
}

class _CompareHead extends StatelessWidget { final Property p; const _CompareHead({required this.p}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Column(children: [ClipRRect(borderRadius: BorderRadius.circular(14), child: SizedBox(height: 110, width: double.infinity, child: Image.network(p.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE7EFEB), child: const Icon(Icons.home_work_outlined))))), const SizedBox(height: 8), Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)), Text(p.price, style: const TextStyle(color: _brandDark, fontWeight: FontWeight.w800))])); }
class _CompareRow extends StatelessWidget { final String label, a, b; const _CompareRow({required this.label, required this.a, required this.b}); @override Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Row(children: [SizedBox(width: 74, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900))), Expanded(child: Text(a, textAlign: TextAlign.center)), Expanded(child: Text(b, textAlign: TextAlign.center))])); }

class MarketContextPage extends StatelessWidget {
  const MarketContextPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('مؤشرات الأسعار')), body: ListView(padding: const EdgeInsets.all(18), children: [
    const Text('سياق السوق', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)), const SizedBox(height: 5), const Text('مقارنة تقريبية بعقارات منشورة مشابهة فقط.', style: TextStyle(color: Colors.black54)), const SizedBox(height: 18),
    Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)), child: Column(children: [const Row(children: [Expanded(child: _Metric(value: '8', label: 'عقارات مشابهة')), Expanded(child: _Metric(value: '91م', label: 'متوسط السعر')), Expanded(child: _Metric(value: '76–110م', label: 'النطاق'))]), const SizedBox(height: 24), SizedBox(height: 160, child: CustomPaint(painter: _ChartPainter()))])),
    const SizedBox(height: 14), Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFFFF7E3), borderRadius: BorderRadius.circular(18)), child: const Row(children: [Icon(Icons.info_outline_rounded, color: Color(0xFF8A6100)), SizedBox(width: 10), Expanded(child: Text('هذه مؤشرات مساعدة وليست تقييمًا رسميًا للعقار.'))]))
  ]));
}
class _Metric extends StatelessWidget { final String value,label; const _Metric({required this.value,required this.label}); @override Widget build(BuildContext context)=>Column(children:[Text(value,style:const TextStyle(fontWeight:FontWeight.w900,fontSize:18,color:_brandDark)),const SizedBox(height:4),Text(label,textAlign:TextAlign.center,style:const TextStyle(fontSize:11,color:Colors.black54))]);}
class _ChartPainter extends CustomPainter { @override void paint(Canvas canvas, Size size){final axis=Paint()..color=Colors.black12..strokeWidth=1; for(int i=1;i<5;i++){final y=size.height*i/5;canvas.drawLine(Offset(0,y),Offset(size.width,y),axis);} final line=Paint()..color=_brand..strokeWidth=4..style=PaintingStyle.stroke..strokeCap=StrokeCap.round; final path=Path()..moveTo(0,size.height*.75)..cubicTo(size.width*.2,size.height*.55,size.width*.35,size.height*.62,size.width*.5,size.height*.35)..cubicTo(size.width*.68,size.height*.12,size.width*.82,size.height*.48,size.width,size.height*.25);canvas.drawPath(path,line);} @override bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الإشعارات')), body: ListView(padding: const EdgeInsets.all(18), children: const [
    _NotificationTile(icon: Icons.price_change_outlined, title: 'تغير سعر عقار في المفضلة', body: 'انخفض سعر شقة شارع الجزائر.', time: 'منذ 20 دقيقة'),
    _NotificationTile(icon: Icons.search_rounded, title: 'عقار جديد يطابق بحثك', body: 'تم نشر عقار جديد ضمن بحثك المحفوظ.', time: 'اليوم'),
    _NotificationTile(icon: Icons.calendar_month_outlined, title: 'المعاينة تحتاج تأكيد', body: 'أكد موعد معاينة فيلا حدة.', time: 'أمس'),
  ]));
}
class _NotificationTile extends StatelessWidget {final IconData icon;final String title,body,time;const _NotificationTile({required this.icon,required this.title,required this.body,required this.time});@override Widget build(BuildContext context)=>Container(margin:const EdgeInsets.only(bottom:10),padding:const EdgeInsets.all(15),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(20)),child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[CircleAvatar(backgroundColor:const Color(0xFFE7F3EF),child:Icon(icon,color:_brand)),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontWeight:FontWeight.w900)),const SizedBox(height:4),Text(body,style:const TextStyle(color:Colors.black54,height:1.4)),const SizedBox(height:5),Text(time,style:const TextStyle(color:Colors.black38,fontSize:11))]))]));}

class NotificationPreferencesPage extends StatelessWidget {
  const NotificationPreferencesPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('تفضيلات الإشعارات')), body: ListView(padding: const EdgeInsets.all(18), children: [
    SwitchListTile(value: true, onChanged: (_) {}, title: const Text('نتائج البحث المحفوظ'), subtitle: const Text('عند نشر عقار مطابق')),
    SwitchListTile(value: true, onChanged: (_) {}, title: const Text('تغيرات الأسعار'), subtitle: const Text('للعقارات الموجودة في المفضلة')),
    SwitchListTile(value: true, onChanged: null, title: const Text('الإشعارات الأمنية والحرجة'), subtitle: const Text('لا يمكن تعطيلها')),
  ]));
}

class Property {
  final String title, price, location, purpose, image, sai, payer;
  final int beds, area;
  const Property({required this.title, required this.price, required this.location, required this.purpose, required this.image, required this.sai, required this.payer, required this.beds, required this.area});
}

const properties = [
  Property(title: 'فيلا سكنية بواجهة حديثة', price: '95,000,000 ر.ي', location: 'صنعاء • حدة', purpose: 'للبيع', image: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80', sai: '1%', payer: 'البائع', beds: 5, area: 28),
  Property(title: 'شقة مرتبة قريبة من الخدمات', price: '320,000 ر.ي / شهريًا', location: 'صنعاء • شارع الجزائر', purpose: 'للإيجار', image: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=1200&q=80', sai: '20% من أول شهر', payer: 'المستأجر', beds: 3, area: 8),
  Property(title: 'أرض سكنية على شارع', price: '68,000,000 ر.ي', location: 'صنعاء • بيت بوس', purpose: 'للبيع', image: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1200&q=80', sai: '1%', payer: 'المشتري', beds: 0, area: 35),
];
