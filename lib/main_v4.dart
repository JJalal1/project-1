import 'package:flutter/material.dart';

void main() => runApp(const DemoApp());

const navy = Color(0xFF102A43);
const navy2 = Color(0xFF173B5E);
const coral = Color(0xFFE85A4F);
const green = Color(0xFF1D8A64);
const sky = Color(0xFFE7F2F8);
const sand = Color(0xFFF6F1E9);
const cream = Color(0xFFFFFCF7);
const ink = Color(0xFF1C2430);
const muted = Color(0xFF6F7782);
const line = Color(0xFFE8E2D9);

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      title: 'تصور المستخدم العادي V4',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: navy),
        appBarTheme: const AppBarTheme(
          backgroundColor: cream,
          foregroundColor: ink,
          elevation: 0,
          centerTitle: false,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: navy,
            foregroundColor: Colors.white,
            minimumSize: const Size(48, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            textStyle: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: line)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: navy, width: 1.4)),
        ),
      ),
      home: const Shell(),
    );
  }
}

class Property {
  final String title;
  final String price;
  final String location;
  final String type;
  final String purpose;
  final String sai;
  final String image;

  const Property({
    required this.title,
    required this.price,
    required this.location,
    required this.type,
    required this.purpose,
    required this.sai,
    required this.image,
  });
}

const properties = <Property>[
  Property(
    title: 'فيلا عصرية بواجهة حجر',
    price: '85,000,000 ر.ي',
    location: 'صنعاء · حدة',
    type: 'فيلا',
    purpose: 'بيع',
    sai: 'السعي 1% · على البائع',
    image: 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=1200',
  ),
  Property(
    title: 'شقة هادئة قريبة من الخدمات',
    price: '320,000 ر.ي / شهر',
    location: 'صنعاء · الستين',
    type: 'شقة',
    purpose: 'إيجار',
    sai: 'السعي 20% من شهر · على المستأجر',
    image: 'https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?w=1200',
  ),
  Property(
    title: 'أرض سكنية في موقع مميز',
    price: '42,500,000 ر.ي',
    location: 'صنعاء · شملان',
    type: 'أرض',
    purpose: 'بيع',
    sai: 'السعي 1% · على المشتري',
    image: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=1200',
  ),
  Property(
    title: 'منزل عائلي واسع',
    price: '58,000,000 ر.ي',
    location: 'صنعاء · بيت بوس',
    type: 'منزل',
    purpose: 'بيع',
    sai: 'السعي 1% · على البائع',
    image: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1200',
  ),
];

void go(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}

class NetImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BorderRadius? radius;

  const NetImage(this.url, {super.key, this.width, this.height, this.radius});

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: sand,
        alignment: Alignment.center,
        child: const Icon(Icons.home_work_outlined, color: muted, size: 36),
      ),
    );
    if (radius == null) return image;
    return ClipRRect(borderRadius: radius!, child: image);
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;
  final pages = const [MapHomePage(), MessagesPage(), ViewingsPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: Container(
          height: 74,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 24, offset: Offset(0, 8))],
          ),
          child: Row(
            children: [
              _NavItem(label: 'العقارات', icon: Icons.map_rounded, active: index == 0, onTap: () => setState(() => index = 0)),
              _NavItem(label: 'الرسائل', icon: Icons.chat_bubble_rounded, active: index == 1, onTap: () => setState(() => index = 1)),
              _NavItem(label: 'المعاينات', icon: Icons.calendar_month_rounded, active: index == 2, onTap: () => setState(() => index = 2)),
              _NavItem(label: 'حسابي', icon: Icons.person_rounded, active: index == 3, onTap: () => setState(() => index = 3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({required this.label, required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 42,
              height: 34,
              decoration: BoxDecoration(color: active ? sky : Colors.transparent, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: active ? green : const Color(0xFF687484), size: 23),
            ),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(color: active ? green : const Color(0xFF687484), fontSize: 10, fontWeight: active ? FontWeight.w900 : FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class MapHomePage extends StatefulWidget {
  const MapHomePage({super.key});

  @override
  State<MapHomePage> createState() => _MapHomePageState();
}

class _MapHomePageState extends State<MapHomePage> {
  String purpose = 'بيع';
  String type = 'الكل';
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: GulfMapCanvas()),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Column(
              children: [
                _TopFilterPanel(
                  purpose: purpose,
                  type: type,
                  onPurpose: (value) => setState(() => purpose = value),
                  onType: (value) => setState(() => type = value),
                  onFilter: () => _showFilter(context),
                  onSearch: () => go(context, const SearchPage()),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: _MatchCard(onTap: () => go(context, const SavedSearchesPage())),
                ),
              ],
            ),
          ),
        ),
        _MapPin(top: 410, left: 100, label: '85م', color: green, icon: Icons.home_rounded, onTap: () => setState(() => selected = 0)),
        _MapPin(top: 510, right: 80, label: '320ألف', color: coral, icon: Icons.apartment_rounded, onTap: () => setState(() => selected = 1)),
        _MapPin(top: 620, left: 220, label: '42.5م', color: navy2, icon: Icons.landscape_rounded, onTap: () => setState(() => selected = 2)),
        Positioned(
          left: 18,
          bottom: 252,
          child: FloatingActionButton.small(
            heroTag: 'locate',
            backgroundColor: Colors.white,
            foregroundColor: navy,
            onPressed: () {},
            child: const Icon(Icons.my_location_rounded),
          ),
        ),
        Positioned(
          left: 12,
          right: 12,
          bottom: 94,
          child: _MapPropertyPreview(
            property: properties[selected],
            onTap: () => go(context, DetailsPage(properties[selected])),
            onFavorite: () {},
          ),
        ),
      ],
    );
  }
}

class _TopFilterPanel extends StatelessWidget {
  final String purpose;
  final String type;
  final ValueChanged<String> onPurpose;
  final ValueChanged<String> onType;
  final VoidCallback onFilter;
  final VoidCallback onSearch;

  const _TopFilterPanel({
    required this.purpose,
    required this.type,
    required this.onPurpose,
    required this.onType,
    required this.onFilter,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    const types = ['الكل', 'شقة', 'فيلا', 'أرض', 'دور', 'عمارة'];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .97),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x24000000), blurRadius: 24, offset: Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: navy, minimumSize: const Size(108, 54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17))),
                onPressed: onFilter,
                icon: const Icon(Icons.tune_rounded),
                label: const Text('تصفية'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: onSearch,
                  borderRadius: BorderRadius.circular(17),
                  child: Container(
                    height: 54,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: const Color(0xFFF7F8FA), borderRadius: BorderRadius.circular(17), border: Border.all(color: const Color(0xFFE9EDF1))),
                    child: const Row(children: [
                      Icon(Icons.search_rounded, color: navy),
                      SizedBox(width: 8),
                      Expanded(child: Text('ابحث عن حي أو نوع عقار...', style: TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w700))),
                    ]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 48,
            decoration: BoxDecoration(color: const Color(0xFFF8F9FB), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE7EBEF))),
            child: Row(
              children: [
                Expanded(child: _PurposeTab(label: 'للبيع', icon: Icons.home_outlined, active: purpose == 'بيع', onTap: () => onPurpose('بيع'))),
                Container(width: 1, height: 26, color: line),
                Expanded(child: _PurposeTab(label: 'للإيجار', icon: Icons.key_rounded, active: purpose == 'إيجار', onTap: () => onPurpose('إيجار'))),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: types.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final item = types[i];
                final active = item == type;
                return InkWell(
                  onTap: () => onType(item),
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: active ? const Color(0xFFEAF6F0) : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: active ? green : const Color(0xFFDDE3E8), width: active ? 1.4 : 1),
                    ),
                    child: Text(item, style: TextStyle(color: active ? green : const Color(0xFF5D6670), fontWeight: active ? FontWeight.w900 : FontWeight.w700)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PurposeTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _PurposeTab({required this.label, required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: active ? navy : Colors.transparent, borderRadius: BorderRadius.circular(13)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: active ? Colors.white : muted, size: 19),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: active ? Colors.white : muted, fontWeight: FontWeight.w900)),
        ]),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final VoidCallback onTap;
  const _MatchCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .95), borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Color(0x1C000000), blurRadius: 18, offset: Offset(0, 6))]),
        child: Row(children: [
          Container(width: 52, height: 52, decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.bookmark_added_rounded, color: Colors.white)),
          const SizedBox(width: 10),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('بحثك المحفوظ', style: TextStyle(color: ink, fontWeight: FontWeight.w900)),
            SizedBox(height: 3),
            Text('5 عقارات جديدة مطابقة', style: TextStyle(color: muted, fontSize: 11)),
          ])),
          const Icon(Icons.chevron_left_rounded, color: muted),
        ]),
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _MapPin({this.top, this.left, this.right, required this.label, required this.color, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14), boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 10, offset: Offset(0, 5))]),
            child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: Colors.white, size: 16), const SizedBox(width: 4), Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11))]),
          ),
          Container(width: 3, height: 7, color: color),
          Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))),
        ]),
      ),
    );
  }
}

class _MapPropertyPreview extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const _MapPropertyPreview({required this.property, required this.onTap, required this.onFavorite});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 142,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 24, offset: Offset(0, 8))]),
        child: Row(children: [
          Stack(children: [
            NetImage(property.image, width: 145, height: 122, radius: BorderRadius.circular(18)),
            Positioned(top: 8, left: 8, child: InkWell(onTap: onFavorite, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: navy.withValues(alpha: .86), shape: BoxShape.circle), child: const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 20)))),
          ]),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text(property.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ink, fontWeight: FontWeight.w900, fontSize: 16))), _SmallBadge(property.purpose)]),
            const SizedBox(height: 4),
            Text(property.location, style: const TextStyle(color: muted, fontSize: 11)),
            const SizedBox(height: 8),
            Row(children: const [Icon(Icons.square_foot_rounded, size: 15, color: muted), SizedBox(width: 4), Text('12 لبنة', style: TextStyle(color: muted, fontSize: 10)), SizedBox(width: 10), Icon(Icons.bed_outlined, size: 15, color: muted), SizedBox(width: 4), Text('5 غرف', style: TextStyle(color: muted, fontSize: 10))]),
            const Spacer(),
            Row(children: [Expanded(child: Text(property.price, style: const TextStyle(color: coral, fontWeight: FontWeight.w900, fontSize: 15))), Container(width: 38, height: 38, decoration: BoxDecoration(color: sand, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.chevron_left_rounded, color: navy))]),
          ])),
        ]),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  final String text;
  const _SmallBadge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFFFE9E5), borderRadius: BorderRadius.circular(12)), child: Text(text, style: const TextStyle(color: coral, fontSize: 10, fontWeight: FontWeight.w900)));
  }
}

class GulfMapCanvas extends StatelessWidget {
  const GulfMapCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GulfMapPainter(), child: const SizedBox.expand());
  }
}

class _GulfMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFBFE7F2));
    final land = Paint()..color = const Color(0xFFF4F0E7);
    final border = Paint()..color = const Color(0xFF6F6E69)..style = PaintingStyle.stroke..strokeWidth = 1.3;

    final peninsula = Path()
      ..moveTo(size.width * .16, size.height * .28)
      ..lineTo(size.width * .70, size.height * .22)
      ..lineTo(size.width * .88, size.height * .46)
      ..lineTo(size.width * .78, size.height * .77)
      ..lineTo(size.width * .55, size.height * .90)
      ..lineTo(size.width * .23, size.height * .84)
      ..lineTo(size.width * .10, size.height * .62)
      ..close();
    canvas.drawPath(peninsula, land);
    canvas.drawPath(peninsula, border);

    final northWest = Path()
      ..moveTo(0, size.height * .20)
      ..lineTo(size.width * .31, size.height * .18)
      ..lineTo(size.width * .22, size.height * .44)
      ..lineTo(0, size.height * .50)
      ..close();
    canvas.drawPath(northWest, land);
    canvas.drawPath(northWest, border);

    final east = Path()
      ..moveTo(size.width * .77, size.height * .25)
      ..lineTo(size.width, size.height * .22)
      ..lineTo(size.width, size.height * .62)
      ..lineTo(size.width * .86, size.height * .56)
      ..close();
    canvas.drawPath(east, land);
    canvas.drawPath(east, border);

    final subtle = Paint()..color = const Color(0xFFE5DED2)..strokeWidth = 1;
    canvas.drawLine(Offset(size.width * .22, size.height * .44), Offset(size.width * .56, size.height * .54), subtle);
    canvas.drawLine(Offset(size.width * .56, size.height * .54), Offset(size.width * .78, size.height * .77), subtle);
    canvas.drawLine(Offset(size.width * .40, size.height * .24), Offset(size.width * .34, size.height * .78), subtle);
    canvas.drawLine(Offset(size.width * .67, size.height * .22), Offset(size.width * .65, size.height * .70), subtle);

    final city = Paint()..color = navy;
    void dot(double x, double y) => canvas.drawCircle(Offset(size.width * x, size.height * y), 3.4, city);
    dot(.52, .58);
    dot(.20, .57);
    dot(.66, .47);
    dot(.31, .77);
    dot(.47, .82);

    final textPainter = TextPainter(textDirection: TextDirection.rtl);
    void label(String text, double x, double y, double font, {FontWeight weight = FontWeight.w700}) {
      textPainter.text = TextSpan(text: text, style: TextStyle(color: navy, fontSize: font, fontWeight: weight));
      textPainter.layout();
      textPainter.paint(canvas, Offset(size.width * x, size.height * y));
    }
    label('السعودية', .42, .69, 19, weight: FontWeight.w900);
    label('اليمن', .48, .88, 16, weight: FontWeight.w900);
    label('العراق', .22, .35, 16, weight: FontWeight.w900);
    label('الكويت', .62, .39, 13, weight: FontWeight.w900);
    label('الرياض', .49, .54, 13, weight: FontWeight.w900);
    label('جدة', .15, .55, 12);
    label('صنعاء', .44, .82, 12);
    label('البحر الأحمر', .03, .72, 11);
    label('الخليج العربي', .78, .47, 11);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void _showFilter(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: cream,
    isScrollControlled: true,
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('تصفية النتائج', style: TextStyle(fontWeight: FontWeight.w900, color: ink, fontSize: 23)),
        const SizedBox(height: 16),
        const Text('نطاق السعر', style: TextStyle(fontWeight: FontWeight.w900, color: ink)),
        RangeSlider(values: const RangeValues(20, 85), min: 0, max: 100, onChanged: (_) {}),
        const SizedBox(height: 8),
        const Text('الغرف', style: TextStyle(fontWeight: FontWeight.w900, color: ink)),
        const SizedBox(height: 8),
        const Wrap(spacing: 8, children: [Chip(label: Text('1+')), Chip(label: Text('2+')), Chip(label: Text('3+')), Chip(label: Text('5+'))]),
        const SizedBox(height: 18),
        FilledButton(onPressed: () => Navigator.pop(context), child: const Text('عرض النتائج')),
      ]),
    ),
  );
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool map = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('البحث')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 4, 16, 10), child: TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search_rounded), hintText: 'مثال: فيلا في حدة', suffixIcon: IconButton(onPressed: () => _showFilter(context), icon: const Icon(Icons.tune_rounded))))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Expanded(child: _SearchToggle(label: 'قائمة', active: !map, icon: Icons.view_agenda_rounded, onTap: () => setState(() => map = false))),
            const SizedBox(width: 8),
            Expanded(child: _SearchToggle(label: 'خريطة', active: map, icon: Icons.map_rounded, onTap: () => setState(() => map = true))),
          ]),
        ),
        const SizedBox(height: 10),
        Expanded(child: map ? const GulfMapCanvas() : ListView.separated(padding: const EdgeInsets.fromLTRB(16, 10, 16, 24), itemCount: properties.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (_, i) => PropertyListCard(property: properties[i], onTap: () => go(context, DetailsPage(properties[i]))))),
      ]),
    );
  }
}

class _SearchToggle extends StatelessWidget {
  final String label;
  final bool active;
  final IconData icon;
  final VoidCallback onTap;
  const _SearchToggle({required this.label, required this.active, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Container(height: 45, decoration: BoxDecoration(color: active ? navy : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: active ? navy : line)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 18, color: active ? Colors.white : navy), const SizedBox(width: 6), Text(label, style: TextStyle(color: active ? Colors.white : navy, fontWeight: FontWeight.w900))])));
  }
}

class PropertyListCard extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;
  const PropertyListCard({super.key, required this.property, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: line)),
        child: Row(children: [
          NetImage(property.image, width: 110, height: 104, radius: BorderRadius.circular(16)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text(property.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, color: ink))), _SmallBadge(property.purpose)]),
            const SizedBox(height: 5),
            Text(property.location, style: const TextStyle(color: muted, fontSize: 11)),
            const SizedBox(height: 8),
            Text(property.price, style: const TextStyle(color: coral, fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            Text('${property.type} · ${property.sai}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w700)),
          ])),
        ]),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Property property;
  const DetailsPage(this.property, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 310,
          pinned: true,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border_rounded)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
          ],
          flexibleSpace: FlexibleSpaceBar(background: NetImage(property.image)),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 120),
          sliver: SliverList.list(children: [
            Row(children: [Expanded(child: Text(property.title, style: const TextStyle(fontWeight: FontWeight.w900, color: ink, fontSize: 23))), _SmallBadge(property.purpose)]),
            const SizedBox(height: 7),
            Text(property.price, style: const TextStyle(color: coral, fontWeight: FontWeight.w900, fontSize: 21)),
            const SizedBox(height: 5),
            Text(property.location, style: const TextStyle(color: muted)),
            const SizedBox(height: 18),
            Row(children: const [Expanded(child: _Fact(icon: Icons.square_foot_rounded, text: '12 لبنة')), SizedBox(width: 8), Expanded(child: _Fact(icon: Icons.bed_outlined, text: '5 غرف')), SizedBox(width: 8), Expanded(child: _Fact(icon: Icons.bathtub_outlined, text: '4 حمامات'))]),
            const SizedBox(height: 14),
            Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFFFFF3E2), borderRadius: BorderRadius.circular(18)), child: Row(children: [const Icon(Icons.handshake_outlined, color: Color(0xFF9A641B)), const SizedBox(width: 10), Expanded(child: Text(property.sai, style: const TextStyle(color: Color(0xFF7A521A), fontWeight: FontWeight.w900)))])),
            const SizedBox(height: 24),
            const Text('عن العقار', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19, color: ink)),
            const SizedBox(height: 8),
            const Text('عقار بموقع مميز وتشطيب حديث، قريب من الخدمات والطرق الرئيسية. البيانات هنا تجريبية لعرض الشكل فقط.', style: TextStyle(color: muted, height: 1.7)),
            const SizedBox(height: 24),
            const Text('أدوات القرار', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19, color: ink)),
            const SizedBox(height: 10),
            Row(children: [Expanded(child: _ToolCard(icon: Icons.insights_outlined, text: 'مؤشرات الأسعار', onTap: () => go(context, const MarketPage()))), const SizedBox(width: 10), Expanded(child: _ToolCard(icon: Icons.compare_arrows_rounded, text: 'المقارنة', onTap: () => go(context, const ComparePage())))]),
          ]),
        ),
      ]),
      bottomSheet: Container(color: cream, padding: const EdgeInsets.fromLTRB(12, 10, 12, 14), child: SafeArea(top: false, child: Row(children: [
        Expanded(child: OutlinedButton.icon(style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), side: const BorderSide(color: navy)), onPressed: () => go(context, ChatPage(property)), icon: const Icon(Icons.chat_bubble_outline_rounded, color: navy), label: const Text('مراسلة', style: TextStyle(color: navy, fontWeight: FontWeight.w900)))),
        const SizedBox(width: 8),
        Expanded(child: FilledButton.icon(onPressed: () => go(context, BookingPage(property)), icon: const Icon(Icons.calendar_month_outlined), label: const Text('طلب معاينة'))),
      ]))),
    );
  }
}

class _Fact extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Fact({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(vertical: 13), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)), child: Column(children: [Icon(icon, color: navy), const SizedBox(height: 5), Text(text, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: ink))]));
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _ToolCard({required this.icon, required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18), child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)), child: Row(children: [Container(width: 38, height: 38, decoration: BoxDecoration(color: sky, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: navy)), const SizedBox(width: 9), Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w900, color: ink, fontSize: 12)))])));
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('المفضلة'), actions: [TextButton(onPressed: () => go(context, const ComparePage()), child: const Text('مقارنة'))]), body: ListView.separated(padding: const EdgeInsets.all(16), itemCount: 3, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (_, i) => PropertyListCard(property: properties[i], onTap: () => go(context, DetailsPage(properties[i])))));
}

class ComparePage extends StatelessWidget {
  const ComparePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('مقارنة العقارات')), body: ListView(padding: const EdgeInsets.all(16), children: [
      Row(children: [Expanded(child: _CompareHead(properties[0])), const SizedBox(width: 8), Expanded(child: _CompareHead(properties[3]))]),
      const SizedBox(height: 16),
      ...['السعر', 'الموقع', 'النوع', 'المساحة', 'الغرف', 'السعي'].map((label) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: muted, fontSize: 10)), const SizedBox(height: 8), Row(children: [Expanded(child: Text(_compareValue(properties[0], label), style: const TextStyle(fontWeight: FontWeight.w800))), Expanded(child: Text(_compareValue(properties[3], label), style: const TextStyle(fontWeight: FontWeight.w800)))])]))),
    ]));
  }
}

class _CompareHead extends StatelessWidget {
  final Property property;
  const _CompareHead(this.property);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: line)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [NetImage(property.image, height: 110, radius: BorderRadius.circular(14)), const SizedBox(height: 8), Text(property.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)), const SizedBox(height: 4), Text(property.price, style: const TextStyle(color: coral, fontWeight: FontWeight.w900, fontSize: 11))]));
}

String _compareValue(Property p, String label) {
  if (label == 'السعر') return p.price;
  if (label == 'الموقع') return p.location;
  if (label == 'النوع') return p.type;
  if (label == 'المساحة') return '12 لبنة';
  if (label == 'الغرف') return '5';
  return p.sai;
}

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('مؤشرات الأسعار')), body: ListView(padding: const EdgeInsets.all(16), children: [
    Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(24)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('فلل للبيع · صنعاء · حدة', style: TextStyle(color: Colors.white70)), SizedBox(height: 7), Text('82,400,000 ر.ي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28)), SizedBox(height: 4), Text('متوسط السعر في العينات المشابهة', style: TextStyle(color: Colors.white70))])),
    const SizedBox(height: 14),
    Row(children: const [Expanded(child: _Metric('8', 'عقارات')), SizedBox(width: 8), Expanded(child: _Metric('76–92م', 'النطاق')), SizedBox(width: 8), Expanded(child: _Metric('10.5', 'متوسط اللبن'))]),
    const SizedBox(height: 18),
    const Text('بيانات تجريبية لعرض الشكل، وتعتمد في المنتج الحقيقي على العقارات المنشورة والمشابهة فقط.', style: TextStyle(color: muted, height: 1.7)),
  ]));
}

class _Metric extends StatelessWidget {
  final String a;
  final String b;
  const _Metric(this.a, this.b);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6), decoration: BoxDecoration(color: sky, borderRadius: BorderRadius.circular(18)), child: Column(children: [Text(a, style: const TextStyle(fontWeight: FontWeight.w900, color: navy)), const SizedBox(height: 3), Text(b, textAlign: TextAlign.center, style: const TextStyle(color: muted, fontSize: 10))]));
}

class SavedSearchesPage extends StatelessWidget {
  const SavedSearchesPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('البحث المحفوظ')), body: ListView(padding: const EdgeInsets.all(16), children: const [
    _SavedSearch(title: 'فلل للبيع في حدة', sub: '60–100 مليون · 5 غرف أو أكثر', enabled: true),
    SizedBox(height: 10),
    _SavedSearch(title: 'شقق للإيجار', sub: 'صنعاء · حتى 400 ألف · 3 غرف', enabled: true),
    SizedBox(height: 10),
    _SavedSearch(title: 'أراضي سكنية', sub: 'شملان · 10 لبن أو أكثر', enabled: false),
  ]));
}

class _SavedSearch extends StatelessWidget {
  final String title;
  final String sub;
  final bool enabled;
  const _SavedSearch({required this.title, required this.sub, required this.enabled});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: line)), child: Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: sky, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.bookmark_outline_rounded, color: navy)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 3), Text(sub, style: const TextStyle(color: muted, fontSize: 11))])), Switch(value: enabled, activeThumbColor: green, onChanged: (_) {})]));
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final names = ['مكتب النخبة العقاري', 'أحمد عبدالله', 'مؤسسة الأمانة'];
    final snippets = ['تم تأكيد معاينتك غدًا الساعة 4:30 م', 'هل يناسبك الموعد يوم الثلاثاء؟', 'أرسلت لك تفاصيل الموقع'];
    return SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(16, 18, 16, 100), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [Expanded(child: Text('الرسائل', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink))), Icon(Icons.search_rounded, color: navy)]),
      const SizedBox(height: 16),
      Expanded(child: ListView.separated(itemCount: 3, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (context, i) => InkWell(onTap: () => go(context, ChatPage(properties[i])), borderRadius: BorderRadius.circular(20), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: i == 0 ? sky : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: i == 0 ? const Color(0xFFCCDFEB) : line)), child: Row(children: [NetImage(properties[i].image, width: 56, height: 56, radius: BorderRadius.circular(16)), const SizedBox(width: 11), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(names[i], style: const TextStyle(fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 4), Text(snippets[i], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 11))])), if (i == 0) const CircleAvatar(radius: 11, backgroundColor: coral, child: Text('2', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)))]))))),
    ])));
  }
}

class ChatPage extends StatelessWidget {
  final Property property;
  const ChatPage(this.property, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('مكتب النخبة العقاري', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)), Text('متصل الآن', style: TextStyle(color: muted, fontSize: 10))])),
    body: Column(children: [
      Container(margin: const EdgeInsets.fromLTRB(12, 8, 12, 0), padding: const EdgeInsets.all(9), decoration: BoxDecoration(color: sky, borderRadius: BorderRadius.circular(18)), child: Row(children: [NetImage(property.image, width: 48, height: 48, radius: BorderRadius.circular(13)), const SizedBox(width: 9), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(property.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)), Text(property.price, style: const TextStyle(color: coral, fontWeight: FontWeight.w900, fontSize: 11))]))])),
      Expanded(child: ListView(padding: const EdgeInsets.all(16), children: const [
        _Bubble(text: 'السلام عليكم، هل العقار ما زال متاحًا؟', mine: true),
        _Bubble(text: 'وعليكم السلام، نعم متاح ويمكن ترتيب معاينة.', mine: false),
        _Bubble(text: 'ممتاز. يناسبني الثلاثاء بعد العصر.', mine: true),
        _Bubble(text: 'تم، أرسلت لك طلب معاينة الساعة 4:30 م.', mine: false),
      ])),
      SafeArea(top: false, child: Padding(padding: const EdgeInsets.fromLTRB(10, 8, 10, 10), child: Row(children: [Expanded(child: TextField(decoration: const InputDecoration(hintText: 'اكتب رسالتك...'))), const SizedBox(width: 8), Container(width: 52, height: 52, decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(17)), child: const Icon(Icons.arrow_upward_rounded, color: Colors.white))]))),
    ]),
  );
}

class _Bubble extends StatelessWidget {
  final String text;
  final bool mine;
  const _Bubble({required this.text, required this.mine});
  @override
  Widget build(BuildContext context) => Align(alignment: mine ? Alignment.centerLeft : Alignment.centerRight, child: Container(margin: const EdgeInsets.only(bottom: 10), constraints: const BoxConstraints(maxWidth: 285), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11), decoration: BoxDecoration(color: mine ? navy : sky, borderRadius: BorderRadius.only(topLeft: const Radius.circular(19), topRight: const Radius.circular(19), bottomLeft: Radius.circular(mine ? 6 : 19), bottomRight: Radius.circular(mine ? 19 : 6))), child: Text(text, style: TextStyle(color: mine ? Colors.white : ink, height: 1.5, fontWeight: FontWeight.w600))));
}

class ViewingsPage extends StatelessWidget {
  const ViewingsPage({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(16, 20, 16, 100), children: [
    const Text('المعاينات', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink)),
    const SizedBox(height: 4),
    const Text('مواعيدك المرتبطة بالعقارات', style: TextStyle(color: muted)),
    const SizedBox(height: 18),
    _ViewingCard(day: 'الثلاثاء', date: '15', time: '4:30 م', status: 'مؤكدة', property: properties[0], color: green),
    const SizedBox(height: 10),
    _ViewingCard(day: 'الخميس', date: '17', time: '11:00 ص', status: 'بانتظار التأكيد', property: properties[1], color: coral),
    const SizedBox(height: 10),
    _ViewingCard(day: 'السبت', date: '12', time: '5:00 م', status: 'مكتملة', property: properties[3], color: navy2),
  ]));
}

class _ViewingCard extends StatelessWidget {
  final String day, date, time, status;
  final Property property;
  final Color color;
  const _ViewingCard({required this.day, required this.date, required this.time, required this.status, required this.property, required this.color});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: line)), child: Row(children: [Container(width: 68, padding: const EdgeInsets.symmetric(vertical: 11), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)), child: Column(children: [Text(day, style: const TextStyle(color: Colors.white70, fontSize: 10)), Text(date, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 26)), Text(time, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 9))])), const SizedBox(width: 11), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(property.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 5), Text(property.location, style: const TextStyle(color: muted, fontSize: 10)), const SizedBox(height: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: sand, borderRadius: BorderRadius.circular(10)), child: Text(status, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10, color: ink)))]))]));
}

class BookingPage extends StatelessWidget {
  final Property property;
  const BookingPage(this.property, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('طلب معاينة')), body: ListView(padding: const EdgeInsets.all(16), children: [
    PropertyListCard(property: property, onTap: () {}),
    const SizedBox(height: 22),
    const Text('اختر اليوم', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
    const SizedBox(height: 10),
    Row(children: const [Expanded(child: _DayChoice(day: 'الأحد', num: '13', active: false)), SizedBox(width: 8), Expanded(child: _DayChoice(day: 'الاثنين', num: '14', active: true)), SizedBox(width: 8), Expanded(child: _DayChoice(day: 'الثلاثاء', num: '15', active: false))]),
    const SizedBox(height: 20),
    const Text('اختر الوقت', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
    const SizedBox(height: 10),
    const Wrap(spacing: 8, runSpacing: 8, children: [_TimeChoice(text: '10:00 ص', active: false), _TimeChoice(text: '12:30 م', active: false), _TimeChoice(text: '4:30 م', active: true), _TimeChoice(text: '6:00 م', active: false)]),
    const SizedBox(height: 20),
    const TextField(maxLines: 3, decoration: InputDecoration(hintText: 'ملاحظة اختيارية')),
    const SizedBox(height: 18),
    FilledButton(onPressed: () => Navigator.pop(context), child: const Text('إرسال طلب المعاينة')),
  ]));
}

class _DayChoice extends StatelessWidget {
  final String day, num;
  final bool active;
  const _DayChoice({required this.day, required this.num, required this.active});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(vertical: 13), decoration: BoxDecoration(color: active ? navy : Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: active ? navy : line)), child: Column(children: [Text(day, style: TextStyle(color: active ? Colors.white70 : muted, fontSize: 10)), const SizedBox(height: 3), Text(num, style: TextStyle(color: active ? Colors.white : ink, fontWeight: FontWeight.w900, fontSize: 22))]));
}

class _TimeChoice extends StatelessWidget {
  final String text;
  final bool active;
  const _TimeChoice({required this.text, required this.active});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), decoration: BoxDecoration(color: active ? green : Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: active ? green : line)), child: Text(text, style: TextStyle(color: active ? Colors.white : ink, fontWeight: FontWeight.w900)));
}

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('رحلتي العقارية')), body: ListView(padding: const EdgeInsets.all(16), children: [
    Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(24)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('رحلتك الحالية', style: TextStyle(color: Colors.white70)), SizedBox(height: 4), Text('فيلا عصرية بواجهة حجر', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 19)), SizedBox(height: 7), Text('أنت الآن في مرحلة الاتفاق', style: TextStyle(color: Color(0xFF8DD6B6), fontWeight: FontWeight.w900))])),
    const SizedBox(height: 18),
    const _JourneyStep(num: '1', title: 'تم حفظ العقار', sub: 'أضفت العقار إلى المفضلة', done: true),
    const _JourneyStep(num: '2', title: 'تمت المحادثة', sub: 'بدأت التواصل مع مكتب النخبة', done: true),
    const _JourneyStep(num: '3', title: 'تمت المعاينة', sub: 'الثلاثاء 15 · الساعة 4:30 م', done: true),
    _JourneyStep(num: '4', title: 'الاتفاق', sub: 'عرض حالي بقيمة 82,000,000 ر.ي', done: true, onTap: () => go(context, const AgreementPage())),
    const _JourneyStep(num: '5', title: 'العقد', sub: 'يظهر عند الوصول لهذه المرحلة', done: false),
  ]));
}

class _JourneyStep extends StatelessWidget {
  final String num, title, sub;
  final bool done;
  final VoidCallback? onTap;
  const _JourneyStep({required this.num, required this.title, required this.sub, required this.done, this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, child: IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [SizedBox(width: 42, child: Column(children: [Container(width: 34, height: 34, decoration: BoxDecoration(color: done ? green : sand, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: Text(num, style: TextStyle(color: done ? Colors.white : muted, fontWeight: FontWeight.w900))), Expanded(child: Container(width: 2, color: line))])), const SizedBox(width: 9), Expanded(child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 4), Text(sub, style: const TextStyle(color: muted, fontSize: 11))])))])));
}

class AgreementPage extends StatelessWidget {
  const AgreementPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الاتفاق')), body: ListView(padding: const EdgeInsets.all(16), children: [
    Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: sky, borderRadius: BorderRadius.circular(22)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('العرض الحالي', style: TextStyle(color: muted)), SizedBox(height: 5), Text('82,000,000 ر.ي', style: TextStyle(color: navy, fontWeight: FontWeight.w900, fontSize: 27)), SizedBox(height: 5), Text('السعي حسب الشرط المحفوظ للعقار', style: TextStyle(color: muted, fontSize: 10))])),
    const SizedBox(height: 14),
    const _InfoCard(title: 'تفاصيل الاتفاق', rows: [('السعر النهائي', '82,000,000 ر.ي'), ('السعي', '1% · على البائع'), ('الحالة', 'بانتظار قبول الطرف الآخر')]),
    const SizedBox(height: 10),
    const _InfoCard(title: 'سجل التعديلات', rows: [('الإصدار 3', '82,000,000 ر.ي · اليوم'), ('الإصدار 2', '80,000,000 ر.ي · أمس'), ('الإصدار 1', '78,000,000 ر.ي · قبل يومين')]),
    const SizedBox(height: 16),
    FilledButton(onPressed: () => go(context, const RentalContractPage()), child: const Text('معاينة شكل العقد')),
  ]));
}

class RentalContractPage extends StatelessWidget {
  const RentalContractPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('عقد الإيجار')), body: ListView(padding: const EdgeInsets.all(16), children: const [
    _InfoCard(title: 'العقار', rows: [('العنوان', 'شقة هادئة قريبة من الخدمات'), ('الموقع', 'صنعاء · الستين'), ('نوع العقد', 'إيجار سكني')]),
    SizedBox(height: 10),
    _InfoCard(title: 'الأطراف', rows: [('المؤجر', 'محمد أحمد'), ('المستأجر', 'مستخدم تجريبي'), ('مدة العقد', '12 شهرًا')]),
    SizedBox(height: 10),
    _InfoCard(title: 'القيمة', rows: [('الإيجار الشهري', '320,000 ر.ي'), ('السعي', '20% من شهر · على المستأجر')]),
    SizedBox(height: 12),
    Text('نموذج داخل التطبيق لأغراض العرض فقط، ولا يمثل وثيقة رسمية أو موثقة.', style: TextStyle(color: muted, height: 1.6)),
  ]));
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<(String, String)> rows;
  const _InfoCard({required this.title, required this.rows});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: line)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: ink, fontSize: 16)), const SizedBox(height: 8), ...rows.map((row) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [Expanded(child: Text(row.$1, style: const TextStyle(color: muted, fontSize: 10))), Expanded(flex: 2, child: Text(row.$2, style: const TextStyle(fontWeight: FontWeight.w800, color: ink)))])))]));
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الإشعارات')), body: ListView(padding: const EdgeInsets.all(16), children: const [
    _Notice(icon: Icons.home_work_outlined, title: 'ظهر عقار جديد يطابق بحثك المحفوظ', sub: 'فيلا للبيع في حدة · منذ 8 دقائق', color: green),
    SizedBox(height: 10),
    _Notice(icon: Icons.price_change_outlined, title: 'تغير سعر عقار في المفضلة', sub: 'انخفض من 88م إلى 85م · منذ ساعة', color: coral),
    SizedBox(height: 10),
    _Notice(icon: Icons.calendar_month_outlined, title: 'تم تأكيد المعاينة', sub: 'غدًا الساعة 4:30 م · حدة', color: navy),
    SizedBox(height: 10),
    _Notice(icon: Icons.chat_bubble_outline, title: 'رسالة جديدة', sub: 'مكتب النخبة: تم تأكيد الموعد', color: navy2),
  ]));
}

class _Notice extends StatelessWidget {
  final IconData icon;
  final String title, sub;
  final Color color;
  const _Notice({required this.icon, required this.title, required this.sub, required this.color});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: line)), child: Row(children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: color)), const SizedBox(width: 11), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 4), Text(sub, style: const TextStyle(color: muted, fontSize: 10))]))]));
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(16, 20, 16, 100), children: [
    const Row(children: [Expanded(child: Text('حسابي', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink))), Icon(Icons.notifications_none_rounded, color: navy)]),
    const SizedBox(height: 14),
    Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(24)), child: Row(children: [const CircleAvatar(radius: 28, backgroundColor: green, child: Text('م', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 21))), const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('مستخدم تجريبي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)), SizedBox(height: 3), Text('+967 7XX XXX XXX', style: TextStyle(color: Colors.white70, fontSize: 11))])), IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined, color: Colors.white))])),
    const SizedBox(height: 14),
    _AccountItem(icon: Icons.route_outlined, title: 'رحلتي العقارية', sub: 'تابع رحلتك من الحفظ حتى الاتفاق', page: const JourneyPage()),
    _AccountItem(icon: Icons.favorite_border_rounded, title: 'المفضلة', sub: '3 عقارات محفوظة', page: const FavoritesPage()),
    _AccountItem(icon: Icons.bookmark_border_rounded, title: 'عمليات البحث المحفوظة', sub: '3 عمليات بحث', page: const SavedSearchesPage()),
    _AccountItem(icon: Icons.notifications_none_rounded, title: 'الإشعارات', sub: 'التحكم بالتنبيهات', page: const NotificationPrefsPage()),
    _AccountItem(icon: Icons.support_agent_outlined, title: 'الدعم والمساعدة', sub: 'تذاكرك وطلب مساعدة', page: const SupportPage()),
    _AccountItem(icon: Icons.lock_outline_rounded, title: 'الخصوصية والأمان', sub: 'بيانات الحساب والجلسات', page: const PrivacyPage()),
    _AccountItem(icon: Icons.login_rounded, title: 'تسجيل الدخول التجريبي', sub: 'معاينة شاشة الدخول', page: const LoginPage()),
  ]));
}

class _AccountItem extends StatelessWidget {
  final IconData icon;
  final String title, sub;
  final Widget page;
  const _AccountItem({required this.icon, required this.title, required this.sub, required this.page});
  @override
  Widget build(BuildContext context) => InkWell(onTap: () => go(context, page), borderRadius: BorderRadius.circular(18), child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: sky, borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: navy)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 3), Text(sub, style: const TextStyle(color: muted, fontSize: 10))])), const Icon(Icons.chevron_left_rounded, color: muted)])));
}

class NotificationPrefsPage extends StatelessWidget {
  const NotificationPrefsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('تفضيلات الإشعارات')), body: ListView(padding: const EdgeInsets.all(16), children: const [
    _ToggleRow(text: 'عقارات تطابق البحث المحفوظ', value: true),
    _ToggleRow(text: 'تغيّر أسعار المفضلة', value: true),
    _ToggleRow(text: 'تذكير بالمعاينات', value: true),
    _ToggleRow(text: 'الرسائل الجديدة', value: true),
    _ToggleRow(text: 'تحديثات الاتفاق والعقد', value: true),
    _ToggleRow(text: 'تنبيهات عامة غير مهمة', value: false),
    SizedBox(height: 12),
    Text('الإشعارات الأمنية والحرجة لا يمكن تعطيلها.', style: TextStyle(color: muted, fontSize: 10)),
  ]));
}

class _ToggleRow extends StatelessWidget {
  final String text;
  final bool value;
  const _ToggleRow({required this.text, required this.value});
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)), child: Row(children: [Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800, color: ink))), Switch(value: value, activeThumbColor: green, onChanged: (_) {})]));
}

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الدعم والمساعدة')), body: ListView(padding: const EdgeInsets.all(16), children: [
    Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(22)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('كيف نقدر نساعدك؟', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 19)), SizedBox(height: 5), Text('افتح تذكرة أو تابع الطلبات السابقة.', style: TextStyle(color: Colors.white70))])),
    const SizedBox(height: 14),
    const _InfoCard(title: 'تذكرة #1042', rows: [('الموضوع', 'مشكلة في موعد المعاينة'), ('الحالة', 'قيد المعالجة'), ('آخر تحديث', 'منذ ساعتين')]),
    const SizedBox(height: 10),
    const _InfoCard(title: 'تذكرة #1011', rows: [('الموضوع', 'استفسار عن البحث المحفوظ'), ('الحالة', 'مكتملة'), ('آخر تحديث', 'قبل 3 أيام')]),
    const SizedBox(height: 14),
    FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add_rounded), label: const Text('فتح تذكرة جديدة')),
  ]));
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الخصوصية والأمان')), body: ListView(padding: const EdgeInsets.all(16), children: const [
    _InfoCard(title: 'بيانات الحساب', rows: [('رقم الهاتف', '+967 7XX XXX XXX'), ('حالة الحساب', 'نشط'), ('آخر دخول', 'اليوم 4:09 ص')]),
    SizedBox(height: 10),
    _InfoCard(title: 'الجلسات', rows: [('هذا الجهاز', 'Android · نشط الآن'), ('جهاز سابق', 'Android · قبل 6 أيام')]),
  ]));
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: navy, body: SafeArea(child: Padding(padding: const EdgeInsets.all(22), child: Column(children: [
    Align(alignment: Alignment.centerRight, child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded, color: Colors.white))),
    const Spacer(),
    Container(width: 76, height: 76, decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(24)), child: const Icon(Icons.home_work_rounded, color: Colors.white, size: 36)),
    const SizedBox(height: 18),
    const Text('مرحبًا بك من جديد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 27)),
    const SizedBox(height: 6),
    const Text('ادخل رقم الهاتف للمتابعة', style: TextStyle(color: Colors.white70)),
    const SizedBox(height: 22),
    const TextField(keyboardType: TextInputType.phone, decoration: InputDecoration(hintText: 'رقم الهاتف')),
    const SizedBox(height: 12),
    FilledButton(style: FilledButton.styleFrom(backgroundColor: green), onPressed: () {}, child: const Text('متابعة')),
    const Spacer(flex: 2),
  ]))));
}
