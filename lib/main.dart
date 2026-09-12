import 'package:flutter/material.dart';

void main() => runApp(const DemoApp());

const ink = Color(0xFF171A2C);
const ink2 = Color(0xFF23273B);
const coral = Color(0xFFFF6B5E);
const sand = Color(0xFFF3EEE6);
const cream = Color(0xFFFFFBF6);
const lavender = Color(0xFFE9E9FF);
const blue = Color(0xFF6D83F2);
const muted = Color(0xFF777987);
const line = Color(0xFFE7E0D6);

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'العقار — تصور بصري V3',
      locale: const Locale('ar'),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: coral, brightness: Brightness.light),
        appBarTheme: const AppBarTheme(backgroundColor: cream, foregroundColor: ink, elevation: 0, centerTitle: false),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: coral,
            foregroundColor: Colors.white,
            minimumSize: const Size(48, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            textStyle: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: line)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: blue, width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        cardTheme: CardThemeData(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28), side: const BorderSide(color: line)),
        ),
      ),
      home: const Shell(),
    );
  }
}

class P {
  final String title, price, location, type, purpose, sai, image;
  const P(this.title, this.price, this.location, this.type, this.purpose, this.sai, this.image);
}

const props = <P>[
  P('فيلا عصرية بواجهة حجر', '85,000,000 ر.ي', 'صنعاء · حدة', 'فيلا', 'بيع', 'السعي 1% · على البائع', 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=1200'),
  P('شقة هادئة قريبة من الخدمات', '320,000 ر.ي / شهر', 'صنعاء · الستين', 'شقة', 'إيجار', 'السعي 20% من شهر · على المستأجر', 'https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?w=1200'),
  P('أرض سكنية في موقع مميز', '42,500,000 ر.ي', 'صنعاء · شملان', 'أرض', 'بيع', 'السعي 1% · على المشتري', 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=1200'),
  P('منزل عائلي واسع', '58,000,000 ر.ي', 'صنعاء · بيت بوس', 'منزل', 'بيع', 'السعي 1% · على البائع', 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1200'),
];

void go(BuildContext context, Widget page) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

class NetImage extends StatelessWidget {
  final String url;
  final double? width, height;
  const NetImage(this.url, {super.key, this.width, this.height});
  @override
  Widget build(BuildContext context) => Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: sand,
          alignment: Alignment.center,
          child: const Icon(Icons.home_work_outlined, color: muted, size: 40),
        ),
      );
}

class Shell extends StatefulWidget {
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
      extendBody: true,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: ink,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [BoxShadow(color: Color(0x33171A2C), blurRadius: 24, offset: Offset(0, 10))],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _NavItem(index: 0, active: index == 0, icon: Icons.explore_outlined, label: 'العقارات', onTap: () => setState(() => index = 0)),
              _NavItem(index: 1, active: index == 1, icon: Icons.chat_bubble_outline_rounded, label: 'الرسائل', onTap: () => setState(() => index = 1)),
              _NavItem(index: 2, active: index == 2, icon: Icons.calendar_month_outlined, label: 'المعاينات', onTap: () => setState(() => index = 2)),
              _NavItem(index: 3, active: index == 3, icon: Icons.person_outline_rounded, label: 'حسابي', onTap: () => setState(() => index = 3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final bool active;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _NavItem({required this.index, required this.active, required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 9),
          decoration: BoxDecoration(color: active ? coral : Colors.transparent, borderRadius: BorderRadius.circular(20)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 21, color: active ? Colors.white : Colors.white70),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: active ? Colors.white : Colors.white70)),
          ]),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 30),
            decoration: const BoxDecoration(
              color: ink,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(42), bottomRight: Radius.circular(42)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('مرحبًا بك', style: TextStyle(color: Colors.white60, fontSize: 13)),
                  SizedBox(height: 2),
                  Text('وين تبحث عن عقارك؟', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 27)),
                ])),
                _RoundIcon(icon: Icons.notifications_none_rounded, color: Colors.white, bg: Colors.white12, onTap: () => go(context, const NotificationsPage())),
              ]),
              const SizedBox(height: 22),
              InkWell(
                onTap: () => go(context, const SearchPage()),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: cream, borderRadius: BorderRadius.circular(24)),
                  child: const Row(children: [
                    Icon(Icons.search_rounded, color: ink),
                    SizedBox(width: 10),
                    Expanded(child: Text('ابحث بمدينة، حي، أو نوع العقار', style: TextStyle(color: muted, fontWeight: FontWeight.w700))),
                    Icon(Icons.tune_rounded, color: coral),
                  ]),
                ),
              ),
              const SizedBox(height: 16),
              Row(children: [
                _DarkChip('شراء', true),
                const SizedBox(width: 8),
                _DarkChip('إيجار', false),
                const Spacer(),
                InkWell(
                  onTap: () => go(context, const MapPage()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white24)),
                    child: const Row(children: [Icon(Icons.map_outlined, color: Colors.white, size: 18), SizedBox(width: 6), Text('الخريطة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800))]),
                  ),
                ),
              ]),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 110),
          sliver: SliverList.list(children: [
            _SectionHeader('مختارات لك', 'عرض الكل', () => go(context, const SearchPage())),
            const SizedBox(height: 12),
            SizedBox(
              height: 310,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: props.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => SizedBox(width: 290, child: PropertyCard(props[i], hero: true)),
              ),
            ),
            const SizedBox(height: 28),
            _SectionHeader('أدواتك', '', () {}),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _ActionTile(Icons.favorite_border_rounded, 'المفضلة', '3 عقارات', const FavoritesPage())),
              const SizedBox(width: 10),
              Expanded(child: _ActionTile(Icons.bookmark_border_rounded, 'بحث محفوظ', 'تنبيهات فورية', const SavedSearchesPage())),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _ActionTile(Icons.compare_arrows_rounded, 'المقارنة', 'عقاران', const ComparePage())),
              const SizedBox(width: 10),
              Expanded(child: _ActionTile(Icons.route_outlined, 'رحلتي', 'خطوتك الحالية', const JourneyPage())),
            ]),
            const SizedBox(height: 28),
            _SectionHeader('قريب من بحثك', '', () {}),
            const SizedBox(height: 12),
            ...props.reversed.take(3).map((p) => Padding(padding: const EdgeInsets.only(bottom: 12), child: PropertyCard(p))),
          ]),
        ),
      ],
    );
  }
}

class _DarkChip extends StatelessWidget {
  final String label;
  final bool active;
  const _DarkChip(this.label, this.active);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: active ? coral : Colors.white10, borderRadius: BorderRadius.circular(18)),
        child: Text(label, style: TextStyle(color: Colors.white, fontWeight: active ? FontWeight.w900 : FontWeight.w700)),
      );
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final Color color, bg;
  final VoidCallback onTap;
  const _RoundIcon({required this.icon, required this.color, required this.bg, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(width: 46, height: 46, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18)), child: Icon(icon, color: color)),
      );
}

class _SectionHeader extends StatelessWidget {
  final String title, action;
  final VoidCallback onTap;
  const _SectionHeader(this.title, this.action, this.onTap);
  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: ink))),
        if (action.isNotEmpty) TextButton(onPressed: onTap, child: Text(action, style: const TextStyle(color: coral, fontWeight: FontWeight.w900))),
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
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: ink)),
            const SizedBox(height: 14),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(color: muted, fontSize: 11)),
          ]),
        ),
      );
}

class PropertyCard extends StatelessWidget {
  final P p;
  final bool hero;
  const PropertyCard(this.p, {super.key, this.hero = false});
  @override
  Widget build(BuildContext context) {
    if (hero) {
      return InkWell(
        onTap: () => go(context, DetailsPage(p)),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(30)), child: NetImage(p.image, width: 290, height: 178)),
              Positioned(top: 12, right: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(14)), child: Text(p.purpose, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11)))),
              Positioned(top: 12, left: 12, child: Container(width: 38, height: 38, decoration: BoxDecoration(color: cream.withValues(alpha: .94), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.favorite_border_rounded, color: ink, size: 20))),
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: ink)),
                const SizedBox(height: 5),
                Text(p.location, style: const TextStyle(color: muted, fontSize: 12)),
                const SizedBox(height: 10),
                Row(children: [Expanded(child: Text(p.price, style: const TextStyle(color: coral, fontWeight: FontWeight.w900, fontSize: 15))), Text(p.type, style: const TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 11))]),
              ]),
            ),
          ]),
        ),
      );
    }
    return InkWell(
      onTap: () => go(context, DetailsPage(p)),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: line)),
        child: Row(children: [
          ClipRRect(borderRadius: BorderRadius.circular(18), child: NetImage(p.image, width: 110, height: 104)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)),
            const SizedBox(height: 5),
            Text(p.location, style: const TextStyle(color: muted, fontSize: 11)),
            const SizedBox(height: 8),
            Text(p.price, style: const TextStyle(color: coral, fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            Text('${p.type} · ${p.purpose}', style: const TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w700)),
          ])),
        ]),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool map = false;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('البحث')),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search_rounded), hintText: 'مثال: فيلا في حدة', suffixIcon: IconButton(onPressed: () => _filters(context), icon: const Icon(Icons.tune_rounded, color: coral)))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Expanded(child: _SwitchButton('قائمة', !map, Icons.view_agenda_outlined, () => setState(() => map = false))),
              const SizedBox(width: 8),
              Expanded(child: _SwitchButton('خريطة', map, Icons.map_outlined, () => setState(() => map = true))),
            ]),
          ),
          const SizedBox(height: 10),
          Expanded(child: map ? const MapCanvas() : ListView.separated(padding: const EdgeInsets.fromLTRB(16, 10, 16, 24), itemCount: props.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (_, i) => PropertyCard(props[i]))),
        ]),
      );
}

class _SwitchButton extends StatelessWidget {
  final String t;
  final bool active;
  final IconData icon;
  final VoidCallback tap;
  const _SwitchButton(this.t, this.active, this.icon, this.tap);
  @override
  Widget build(BuildContext context) => InkWell(onTap: tap, borderRadius: BorderRadius.circular(18), child: Container(height: 46, decoration: BoxDecoration(color: active ? ink : Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: active ? ink : line)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 18, color: active ? Colors.white : ink), const SizedBox(width: 6), Text(t, style: TextStyle(color: active ? Colors.white : ink, fontWeight: FontWeight.w900))])));
}

void _filters(BuildContext context) => showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: cream,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('تصفية النتائج', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: ink)),
          const SizedBox(height: 18),
          const Text('الغرض', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Wrap(spacing: 8, children: [Chip(label: Text('بيع')), Chip(label: Text('إيجار')), Chip(label: Text('الكل'))]),
          const SizedBox(height: 16),
          const Text('نوع العقار', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Wrap(spacing: 8, runSpacing: 8, children: [Chip(label: Text('فيلا')), Chip(label: Text('شقة')), Chip(label: Text('منزل')), Chip(label: Text('أرض'))]),
          const SizedBox(height: 16),
          const Text('نطاق السعر', style: TextStyle(fontWeight: FontWeight.w900)),
          RangeSlider(values: const RangeValues(20, 85), min: 0, max: 100, onChanged: (_) {}),
          const SizedBox(height: 8),
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('عرض 18 نتيجة')),
        ]),
      ),
    );

class MapPage extends StatelessWidget {
  const MapPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الخريطة')), body: const MapCanvas());
}

class MapCanvas extends StatelessWidget {
  const MapCanvas({super.key});
  @override
  Widget build(BuildContext context) => Stack(children: [
        Container(color: const Color(0xFFE8E2D8), child: CustomPaint(painter: _MapPainter(), child: const SizedBox.expand())),
        const Positioned(top: 100, right: 46, child: _MapPrice('85م')),
        const Positioned(top: 210, left: 52, child: _MapPrice('320ألف')),
        const Positioned(top: 325, right: 110, child: _MapPrice('42.5م')),
        Positioned(bottom: 18, left: 16, right: 16, child: PropertyCard(props[0])),
      ]);
}

class _MapPrice extends StatelessWidget {
  final String t;
  const _MapPrice(this.t);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: coral, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x22FF6B5E), blurRadius: 10)]), child: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)));
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()..color = Colors.white..strokeWidth = 7..strokeCap = StrokeCap.round;
    final minor = Paint()..color = const Color(0xFFD3CBC0)..strokeWidth = 2;
    for (int i = 1; i < 7; i++) canvas.drawLine(Offset(0, size.height * i / 7), Offset(size.width, size.height * i / 7 - 26), road);
    for (int i = 1; i < 6; i++) canvas.drawLine(Offset(size.width * i / 6, 0), Offset(size.width * i / 6 + 28, size.height), road);
    for (int i = 1; i < 10; i++) canvas.drawCircle(Offset(size.width * (i % 5) / 5 + 20, size.height * i / 11), 2, minor);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DetailsPage extends StatelessWidget {
  final P p;
  const DetailsPage(this.p, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: ink,
        body: Stack(children: [
          Positioned.fill(top: 0, bottom: MediaQuery.of(context).size.height * .52, child: NetImage(p.image)),
          SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _RoundIcon(icon: Icons.arrow_back_rounded, color: ink, bg: cream.withValues(alpha: .92), onTap: () => Navigator.pop(context)),
            Row(children: [
              _RoundIcon(icon: Icons.favorite_border_rounded, color: ink, bg: cream.withValues(alpha: .92), onTap: () {}),
              const SizedBox(width: 8),
              _RoundIcon(icon: Icons.share_outlined, color: ink, bg: cream.withValues(alpha: .92), onTap: () {}),
            ]),
          ]))),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * .35,
            child: Container(
              decoration: const BoxDecoration(color: cream, borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38))),
              child: ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 130), children: [
                Row(children: [Expanded(child: Text(p.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: ink))), _Pill(p.purpose, coral, Colors.white)]),
                const SizedBox(height: 6),
                Text(p.location, style: const TextStyle(color: muted)),
                const SizedBox(height: 12),
                Text(p.price, style: const TextStyle(color: coral, fontWeight: FontWeight.w900, fontSize: 25)),
                const SizedBox(height: 18),
                Row(children: const [
                  Expanded(child: _Fact(Icons.square_foot_rounded, '12 لبنة')),
                  SizedBox(width: 8),
                  Expanded(child: _Fact(Icons.bed_outlined, '5 غرف')),
                  SizedBox(width: 8),
                  Expanded(child: _Fact(Icons.bathtub_outlined, '4 حمامات')),
                ]),
                const SizedBox(height: 18),
                Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(22)), child: Row(children: [const Icon(Icons.handshake_outlined, color: ink), const SizedBox(width: 10), Expanded(child: Text(p.sai, style: const TextStyle(color: ink, fontWeight: FontWeight.w900)))])),
                const SizedBox(height: 26),
                const _H2('عن العقار'),
                const SizedBox(height: 8),
                const Text('عقار بموقع مميز وتشطيب حديث، قريب من الخدمات والطرق الرئيسية. هذه البيانات تجريبية لعرض الشكل فقط.', style: TextStyle(color: muted, height: 1.8)),
                const SizedBox(height: 26),
                const _H2('أدوات القرار'),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: _MiniAction(Icons.insights_outlined, 'مؤشرات الأسعار', () => go(context, const MarketPage()))),
                  const SizedBox(width: 10),
                  Expanded(child: _MiniAction(Icons.compare_arrows_rounded, 'المقارنة', () => go(context, const ComparePage()))),
                ]),
                const SizedBox(height: 26),
                const _H2('عقارات مشابهة'),
                const SizedBox(height: 10),
                ...props.skip(1).take(2).map((x) => Padding(padding: const EdgeInsets.only(bottom: 10), child: PropertyCard(x))),
              ]),
            ),
          ),
        ]),
        bottomSheet: Container(
          color: cream,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: SafeArea(top: false, child: Row(children: [
            Expanded(child: OutlinedButton.icon(style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), side: const BorderSide(color: ink)), onPressed: () => go(context, ChatPage(p)), icon: const Icon(Icons.chat_bubble_outline_rounded, color: ink), label: const Text('مراسلة', style: TextStyle(color: ink, fontWeight: FontWeight.w900)))),
            const SizedBox(width: 10),
            Expanded(child: FilledButton.icon(onPressed: () => go(context, BookingPage(p)), icon: const Icon(Icons.calendar_month_outlined), label: const Text('طلب معاينة'))),
          ])),
        ),
      );
}

class _Fact extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Fact(this.icon, this.text);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(vertical: 13), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: line)), child: Column(children: [Icon(icon, color: blue), const SizedBox(height: 6), Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: ink))]));
}

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback tap;
  const _MiniAction(this.icon, this.text, this.tap);
  @override
  Widget build(BuildContext context) => InkWell(onTap: tap, borderRadius: BorderRadius.circular(22), child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: line)), child: Row(children: [Container(width: 38, height: 38, decoration: BoxDecoration(color: sand, borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: ink)), const SizedBox(width: 9), Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w900, color: ink, fontSize: 12)))])));
}

class _H2 extends StatelessWidget {
  final String t;
  const _H2(this.t);
  @override
  Widget build(BuildContext context) => Text(t, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: ink));
}

class _Pill extends StatelessWidget {
  final String t;
  final Color bg, fg;
  const _Pill(this.t, this.bg, this.fg);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(15)), child: Text(t, style: TextStyle(color: fg, fontWeight: FontWeight.w900, fontSize: 11)));
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('المفضلة'), actions: [TextButton(onPressed: () => go(context, const ComparePage()), child: const Text('مقارنة', style: TextStyle(color: coral, fontWeight: FontWeight.w900)))]), body: ListView.separated(padding: const EdgeInsets.all(16), itemCount: 3, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (_, i) => PropertyCard(props[i])));
}

class ComparePage extends StatelessWidget {
  const ComparePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('مقارنة العقارات')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Row(children: [Expanded(child: PropertyCard(props[0], hero: true)), const SizedBox(width: 8), Expanded(child: PropertyCard(props[3], hero: true))]),
          const SizedBox(height: 18),
          ...['السعر', 'الموقع', 'النوع', 'المساحة', 'الغرف', 'السعي'].map((x) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: line)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(x, style: const TextStyle(color: muted, fontSize: 11)), const SizedBox(height: 8), Row(children: [Expanded(child: Text(_compareValue(props[0], x), style: const TextStyle(fontWeight: FontWeight.w900, color: ink))), Expanded(child: Text(_compareValue(props[3], x), style: const TextStyle(fontWeight: FontWeight.w900, color: ink)))])]))),
        ]),
      );
}

String _compareValue(P p, String x) {
  if (x == 'السعر') return p.price;
  if (x == 'الموقع') return p.location;
  if (x == 'النوع') return p.type;
  if (x == 'المساحة') return '12 لبنة';
  if (x == 'الغرف') return '5';
  return p.sai;
}

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('مؤشرات الأسعار')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(30)),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('فلل للبيع · صنعاء · حدة', style: TextStyle(color: Colors.white60)),
              SizedBox(height: 12),
              Text('82,400,000 ر.ي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 30)),
              SizedBox(height: 4),
              Text('متوسط السعر في العينات المشابهة', style: TextStyle(color: Colors.white70)),
            ]),
          ),
          const SizedBox(height: 12),
          Row(children: const [Expanded(child: _StatCard('8', 'عقارات مقارنة')), SizedBox(width: 8), Expanded(child: _StatCard('76–92م', 'نطاق الأسعار')), SizedBox(width: 8), Expanded(child: _StatCard('10.5', 'متوسط اللبن'))]),
          const SizedBox(height: 20),
          const Text('بيانات تجريبية مبنية على عقارات منشورة ومتشابهة لعرض شكل الأداة فقط.', style: TextStyle(color: muted, height: 1.7)),
          const SizedBox(height: 14),
          ...props.take(3).map((p) => Padding(padding: const EdgeInsets.only(bottom: 10), child: PropertyCard(p))),
        ]),
      );
}

class _StatCard extends StatelessWidget {
  final String a, b;
  const _StatCard(this.a, this.b);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6), decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(20)), child: Column(children: [Text(a, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 4), Text(b, textAlign: TextAlign.center, style: const TextStyle(color: muted, fontSize: 10))]));
}

class SavedSearchesPage extends StatelessWidget {
  const SavedSearchesPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('البحث المحفوظ')), body: ListView(padding: const EdgeInsets.all(16), children: const [
        _SavedSearch('فلل للبيع في حدة', '60–100 مليون · 5 غرف أو أكثر', true),
        SizedBox(height: 10),
        _SavedSearch('شقق للإيجار', 'صنعاء · حتى 400 ألف · 3 غرف', true),
        SizedBox(height: 10),
        _SavedSearch('أراضي سكنية', 'شملان · 10 لبن أو أكثر', false),
      ]));
}

class _SavedSearch extends StatelessWidget {
  final String title, sub;
  final bool enabled;
  const _SavedSearch(this.title, this.sub, this.enabled);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: line)), child: Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: sand, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.bookmark_outline_rounded, color: ink)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 3), Text(sub, style: const TextStyle(color: muted, fontSize: 11))])), Switch(value: enabled, activeThumbColor: coral, onChanged: (_) {})]));
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [Expanded(child: Text('الرسائل', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink))), Icon(Icons.search_rounded, color: ink)]),
            const SizedBox(height: 18),
            Expanded(child: ListView.separated(itemCount: 3, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (context, i) {
              final names = ['مكتب النخبة العقاري', 'أحمد عبدالله', 'مؤسسة الأمانة'];
              final snippets = ['تم تأكيد معاينتك غدًا الساعة 4:30 م', 'هل يناسبك الموعد يوم الثلاثاء؟', 'أرسلت لك تفاصيل الموقع'];
              return InkWell(
                onTap: () => go(context, ChatPage(props[i])),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: i == 0 ? lavender : Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: i == 0 ? lavender : line)),
                  child: Row(children: [
                    ClipRRect(borderRadius: BorderRadius.circular(18), child: NetImage(props[i].image, width: 58, height: 58)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(names[i], style: const TextStyle(fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 5), Text(snippets[i], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 12))])),
                    if (i == 0) const CircleAvatar(radius: 12, backgroundColor: coral, child: Text('2', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900))),
                  ]),
                ),
              );
            })),
          ]),
        ),
      );
}

class ChatPage extends StatelessWidget {
  final P p;
  const ChatPage(this.p, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('مكتب النخبة العقاري', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)), Text('متصل الآن', style: TextStyle(color: muted, fontSize: 10))])),
        body: Column(children: [
          Container(margin: const EdgeInsets.fromLTRB(14, 8, 14, 0), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: sand, borderRadius: BorderRadius.circular(20)), child: Row(children: [ClipRRect(borderRadius: BorderRadius.circular(13), child: NetImage(p.image, width: 48, height: 48)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.title, style: const TextStyle(fontWeight: FontWeight.w900, color: ink, fontSize: 12)), Text(p.price, style: const TextStyle(color: coral, fontWeight: FontWeight.w900, fontSize: 11))]))])),
          Expanded(child: ListView(padding: const EdgeInsets.all(16), children: const [
            _Bubble('السلام عليكم، هل العقار ما زال متاحًا؟', true),
            _Bubble('وعليكم السلام، نعم متاح ويمكن ترتيب معاينة.', false),
            _Bubble('ممتاز. يناسبني الثلاثاء بعد العصر.', true),
            _Bubble('تم، أرسلت لك طلب معاينة الساعة 4:30 م.', false),
          ])),
          SafeArea(top: false, child: Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 12), child: Row(children: [Expanded(child: TextField(decoration: const InputDecoration(hintText: 'اكتب رسالتك...'))), const SizedBox(width: 8), Container(width: 52, height: 52, decoration: BoxDecoration(color: coral, borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.arrow_upward_rounded, color: Colors.white))]))),
        ]),
      );
}

class _Bubble extends StatelessWidget {
  final String t;
  final bool me;
  const _Bubble(this.t, this.me);
  @override
  Widget build(BuildContext context) => Align(
        alignment: me ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          constraints: const BoxConstraints(maxWidth: 285),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(color: me ? ink : lavender, borderRadius: BorderRadius.only(topLeft: const Radius.circular(20), topRight: const Radius.circular(20), bottomLeft: Radius.circular(me ? 6 : 20), bottomRight: Radius.circular(me ? 20 : 6))),
          child: Text(t, style: TextStyle(color: me ? Colors.white : ink, height: 1.5, fontWeight: FontWeight.w600)),
        ),
      );
}

class ViewingsPage extends StatelessWidget {
  const ViewingsPage({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
        child: ListView(padding: const EdgeInsets.fromLTRB(18, 22, 18, 110), children: [
          const Text('المعاينات', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink)),
          const SizedBox(height: 4),
          const Text('مواعيدك المرتبطة بالعقارات', style: TextStyle(color: muted)),
          const SizedBox(height: 20),
          _ViewingCard('الثلاثاء', '15', '4:30 م', 'مؤكدة', props[0], coral),
          const SizedBox(height: 12),
          _ViewingCard('الخميس', '17', '11:00 ص', 'بانتظار التأكيد', props[1], blue),
          const SizedBox(height: 12),
          _ViewingCard('السبت', '12', '5:00 م', 'مكتملة', props[3], ink2),
        ]),
      );
}

class _ViewingCard extends StatelessWidget {
  final String day, date, time, status;
  final P p;
  final Color color;
  const _ViewingCard(this.day, this.date, this.time, this.status, this.p, this.color);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), border: Border.all(color: line)),
        child: Row(children: [
          Container(width: 70, padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(22)), child: Column(children: [Text(day, style: const TextStyle(color: Colors.white70, fontSize: 11)), Text(date, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)), Text(time, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800))])),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ink, fontWeight: FontWeight.w900)), const SizedBox(height: 5), Text(p.location, style: const TextStyle(color: muted, fontSize: 11)), const SizedBox(height: 8), _Pill(status, sand, ink)])),
        ]),
      );
}

class BookingPage extends StatelessWidget {
  final P p;
  const BookingPage(this.p, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('طلب معاينة')),
        body: ListView(padding: const EdgeInsets.all(18), children: [
          PropertyCard(p),
          const SizedBox(height: 24),
          const _H2('اختر اليوم'),
          const SizedBox(height: 10),
          Row(children: const [Expanded(child: _DayChoice('الأحد', '13', false)), SizedBox(width: 8), Expanded(child: _DayChoice('الاثنين', '14', true)), SizedBox(width: 8), Expanded(child: _DayChoice('الثلاثاء', '15', false))]),
          const SizedBox(height: 22),
          const _H2('اختر الوقت'),
          const SizedBox(height: 10),
          const Wrap(spacing: 8, runSpacing: 8, children: [_TimeChoice('10:00 ص', false), _TimeChoice('12:30 م', false), _TimeChoice('4:30 م', true), _TimeChoice('6:00 م', false)]),
          const SizedBox(height: 22),
          const TextField(maxLines: 3, decoration: InputDecoration(hintText: 'ملاحظة اختيارية')),
          const SizedBox(height: 20),
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('إرسال طلب المعاينة')),
        ]),
      );
}

class _DayChoice extends StatelessWidget {
  final String day, num;
  final bool active;
  const _DayChoice(this.day, this.num, this.active);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: active ? ink : Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: active ? ink : line)), child: Column(children: [Text(day, style: TextStyle(color: active ? Colors.white70 : muted, fontSize: 11)), const SizedBox(height: 3), Text(num, style: TextStyle(color: active ? Colors.white : ink, fontSize: 22, fontWeight: FontWeight.w900))]));
}

class _TimeChoice extends StatelessWidget {
  final String t;
  final bool active;
  const _TimeChoice(this.t, this.active);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11), decoration: BoxDecoration(color: active ? coral : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: active ? coral : line)), child: Text(t, style: TextStyle(color: active ? Colors.white : ink, fontWeight: FontWeight.w900)));
}

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('رحلتي العقارية')),
        body: ListView(padding: const EdgeInsets.all(18), children: [
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(30)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('رحلتك الحالية', style: TextStyle(color: Colors.white60)), SizedBox(height: 5), Text('فيلا عصرية بواجهة حجر', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)), SizedBox(height: 8), Text('أنت الآن في مرحلة الاتفاق', style: TextStyle(color: Color(0xFFFFA097), fontWeight: FontWeight.w900))])),
          const SizedBox(height: 22),
          const _JourneyStep('1', 'تم حفظ العقار', 'أضفت العقار إلى المفضلة', true),
          const _JourneyStep('2', 'تمت المحادثة', 'بدأت التواصل مع مكتب النخبة', true),
          const _JourneyStep('3', 'تمت المعاينة', 'الثلاثاء 15 · الساعة 4:30 م', true),
          _JourneyStep('4', 'الاتفاق', 'عرض حالي بقيمة 82,000,000 ر.ي', true, tap: () => go(context, const AgreementPage())),
          const _JourneyStep('5', 'العقد', 'يظهر عند الوصول لهذه المرحلة', false),
        ]),
      );
}

class _JourneyStep extends StatelessWidget {
  final String n, title, sub;
  final bool done;
  final VoidCallback? tap;
  const _JourneyStep(this.n, this.title, this.sub, this.done, {this.tap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: tap,
        child: IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(width: 46, child: Column(children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: done ? coral : sand, borderRadius: BorderRadius.circular(14)), alignment: Alignment.center, child: Text(n, style: TextStyle(color: done ? Colors.white : muted, fontWeight: FontWeight.w900))), Expanded(child: Container(width: 2, color: line))])),
          const SizedBox(width: 10),
          Expanded(child: Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: line)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 4), Text(sub, style: const TextStyle(color: muted, fontSize: 12))]))),
        ])),
      );
}

class AgreementPage extends StatelessWidget {
  const AgreementPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الاتفاق')), body: ListView(padding: const EdgeInsets.all(18), children: [
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: lavender, borderRadius: BorderRadius.circular(28)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('العرض الحالي', style: TextStyle(color: muted)), SizedBox(height: 6), Text('82,000,000 ر.ي', style: TextStyle(color: ink, fontWeight: FontWeight.w900, fontSize: 28)), SizedBox(height: 6), Text('السعي حسب الشرط المحفوظ للعقار', style: TextStyle(color: muted, fontSize: 11))])),
        const SizedBox(height: 18),
        const _InfoCard('تفاصيل الاتفاق', [('السعر النهائي', '82,000,000 ر.ي'), ('السعي', '1% · على البائع'), ('الحالة', 'بانتظار قبول الطرف الآخر')]),
        const SizedBox(height: 12),
        const _InfoCard('سجل التعديلات', [('الإصدار 3', '82,000,000 ر.ي · اليوم'), ('الإصدار 2', '80,000,000 ر.ي · أمس'), ('الإصدار 1', '78,000,000 ر.ي · قبل يومين')]),
        const SizedBox(height: 18),
        FilledButton(onPressed: () => go(context, const RentalContractPage()), child: const Text('معاينة شكل العقد')),
      ]));
}

class RentalContractPage extends StatelessWidget {
  const RentalContractPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('عقد الإيجار')), body: ListView(padding: const EdgeInsets.all(18), children: const [
        _InfoCard('العقار', [('العنوان', 'شقة هادئة قريبة من الخدمات'), ('الموقع', 'صنعاء · الستين'), ('نوع العقد', 'إيجار سكني')]),
        SizedBox(height: 12),
        _InfoCard('الأطراف', [('المؤجر', 'محمد أحمد'), ('المستأجر', 'مستخدم تجريبي'), ('مدة العقد', '12 شهرًا')]),
        SizedBox(height: 12),
        _InfoCard('القيمة', [('الإيجار الشهري', '320,000 ر.ي'), ('السعي', '20% من شهر · على المستأجر')]),
        SizedBox(height: 14),
        Text('نموذج داخل التطبيق لأغراض العرض فقط، ولا يمثل وثيقة رسمية أو موثقة.', style: TextStyle(color: muted, height: 1.6)),
      ]));
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<(String, String)> rows;
  const _InfoCard(this.title, this.rows);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: line)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: ink)), const SizedBox(height: 8), ...rows.map((r) => Padding(padding: const EdgeInsets.symmetric(vertical: 7), child: Row(children: [Expanded(child: Text(r.$1, style: const TextStyle(color: muted, fontSize: 11))), Expanded(flex: 2, child: Text(r.$2, style: const TextStyle(fontWeight: FontWeight.w800, color: ink)))])))]));
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الإشعارات')), body: ListView(padding: const EdgeInsets.all(16), children: const [
        _Notice(Icons.home_work_outlined, 'ظهر عقار جديد يطابق بحثك المحفوظ', 'فيلا للبيع في حدة · منذ 8 دقائق', coral),
        SizedBox(height: 10),
        _Notice(Icons.price_change_outlined, 'تغير سعر عقار في المفضلة', 'انخفض من 88م إلى 85م · منذ ساعة', blue),
        SizedBox(height: 10),
        _Notice(Icons.calendar_month_outlined, 'تم تأكيد المعاينة', 'غدًا الساعة 4:30 م · حدة', ink2),
        SizedBox(height: 10),
        _Notice(Icons.chat_bubble_outline, 'رسالة جديدة', 'مكتب النخبة: تم تأكيد الموعد', coral),
      ]));
}

class _Notice extends StatelessWidget {
  final IconData icon;
  final String title, sub;
  final Color color;
  const _Notice(this.icon, this.title, this.sub, this.color);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: line)), child: Row(children: [Container(width: 46, height: 46, decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: color)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 4), Text(sub, style: const TextStyle(color: muted, fontSize: 11))]))]));
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
        child: ListView(padding: const EdgeInsets.fromLTRB(18, 22, 18, 110), children: [
          const Text('حسابي', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink)),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(30)), child: Row(children: [
            const CircleAvatar(radius: 30, backgroundColor: coral, child: Text('م', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900))),
            const SizedBox(width: 14),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('مستخدم تجريبي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)), SizedBox(height: 4), Text('+967 7XX XXX XXX', style: TextStyle(color: Colors.white60, fontSize: 12))])),
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined, color: Colors.white)),
          ])),
          const SizedBox(height: 18),
          _MenuTile(Icons.route_outlined, 'رحلتي العقارية', 'تابع رحلتك من الحفظ حتى الاتفاق', const JourneyPage()),
          _MenuTile(Icons.favorite_border_rounded, 'المفضلة', '3 عقارات محفوظة', const FavoritesPage()),
          _MenuTile(Icons.bookmark_border_rounded, 'عمليات البحث المحفوظة', '3 عمليات بحث', const SavedSearchesPage()),
          _MenuTile(Icons.notifications_none_rounded, 'الإشعارات', 'التحكم بالتنبيهات', const NotificationPrefsPage()),
          _MenuTile(Icons.support_agent_outlined, 'الدعم والمساعدة', 'تذاكرك وطلب مساعدة', const SupportPage()),
          _MenuTile(Icons.lock_outline_rounded, 'الخصوصية والأمان', 'بيانات الحساب والجلسات', const PrivacyPage()),
          _MenuTile(Icons.login_rounded, 'تسجيل الدخول التجريبي', 'معاينة شاشة الدخول', const LoginPage()),
        ]),
      );
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title, sub;
  final Widget page;
  const _MenuTile(this.icon, this.title, this.sub, this.page);
  @override
  Widget build(BuildContext context) => InkWell(onTap: () => go(context, page), borderRadius: BorderRadius.circular(22), child: Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: line)), child: Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: sand, borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: ink)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 3), Text(sub, style: const TextStyle(color: muted, fontSize: 11))])), const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: muted)]))));
}

class NotificationPrefsPage extends StatelessWidget {
  const NotificationPrefsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('تفضيلات الإشعارات')), body: ListView(padding: const EdgeInsets.all(16), children: const [
        _ToggleRow('عقارات تطابق البحث المحفوظ', true),
        _ToggleRow('تغيّر أسعار المفضلة', true),
        _ToggleRow('تذكير بالمعاينات', true),
        _ToggleRow('الرسائل الجديدة', true),
        _ToggleRow('تحديثات الاتفاق والعقد', true),
        _ToggleRow('تنبيهات عامة غير مهمة', false),
        SizedBox(height: 14),
        Text('الإشعارات الأمنية والحرجة لا يمكن تعطيلها.', style: TextStyle(color: muted, fontSize: 11)),
      ]));
}

class _ToggleRow extends StatelessWidget {
  final String t;
  final bool value;
  const _ToggleRow(this.t, this.value);
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: line)), child: Row(children: [Expanded(child: Text(t, style: const TextStyle(fontWeight: FontWeight.w800, color: ink))), Switch(value: value, activeThumbColor: coral, onChanged: (_) {})]));
}

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الدعم والمساعدة')), body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(28)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('كيف نقدر نساعدك؟', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)), SizedBox(height: 6), Text('افتح تذكرة أو تابع الطلبات السابقة.', style: TextStyle(color: Colors.white60))])),
        const SizedBox(height: 16),
        const _InfoCard('تذكرة #1042', [('الموضوع', 'مشكلة في موعد المعاينة'), ('الحالة', 'قيد المعالجة'), ('آخر تحديث', 'منذ ساعتين')]),
        const SizedBox(height: 10),
        const _InfoCard('تذكرة #1011', [('الموضوع', 'استفسار عن البحث المحفوظ'), ('الحالة', 'مكتملة'), ('آخر تحديث', 'قبل 3 أيام')]),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('فتح تذكرة جديدة')),
      ]));
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الخصوصية والأمان')), body: ListView(padding: const EdgeInsets.all(16), children: const [
        _InfoCard('بيانات الحساب', [('رقم الهاتف', '+967 7XX XXX XXX'), ('حالة الحساب', 'نشط'), ('آخر دخول', 'اليوم 3:42 ص')]),
        SizedBox(height: 12),
        _InfoCard('الجلسات', [('هذا الجهاز', 'Android · نشط الآن'), ('جهاز سابق', 'Android · قبل 6 أيام')]),
      ]));
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: ink,
        body: SafeArea(child: Padding(padding: const EdgeInsets.all(22), child: Column(children: [
          Align(alignment: Alignment.centerRight, child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded, color: Colors.white))),
          const Spacer(),
          Container(width: 78, height: 78, decoration: BoxDecoration(color: coral, borderRadius: BorderRadius.circular(26)), child: const Icon(Icons.home_work_rounded, color: Colors.white, size: 38)),
          const SizedBox(height: 20),
          const Text('مرحبًا بك من جديد', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 7),
          const Text('ادخل رقم الهاتف للمتابعة', style: TextStyle(color: Colors.white60)),
          const SizedBox(height: 24),
          const TextField(keyboardType: TextInputType.phone, decoration: InputDecoration(hintText: 'رقم الهاتف')),
          const SizedBox(height: 12),
          FilledButton(onPressed: () {}, child: const Text('متابعة')),
          const Spacer(flex: 2),
        ]))),
      );
}
