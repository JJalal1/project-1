from pathlib import Path
import sys

path = Path(sys.argv[1] if len(sys.argv) > 1 else 'buildapp/lib/main.dart')
text = path.read_text()


def replace_between(src, start, end, replacement):
    a = src.find(start)
    if a < 0:
        raise SystemExit('missing start: ' + start)
    b = src.find(end, a)
    if b < 0:
        raise SystemExit('missing end: ' + end)
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
      backgroundColor: const Color(0xFF0D0F0F),
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: Container(
        height: 84,
        decoration: const BoxDecoration(
          color: Color(0xFF181A1A),
          border: Border(top: BorderSide(color: Color(0xFF2C2F2F), width: 1)),
        ),
        child: SafeArea(
          top: false,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Row(children: [
                _BottomItem(label: 'الرئيسية', icon: Icons.home_outlined, active: index == 0, onTap: () => setState(() => index = 0)),
                _BottomItem(label: 'الدردشة', icon: Icons.chat_bubble_outline_rounded, active: index == 1, onTap: () => setState(() => index = 1)),
                const SizedBox(width: 78),
                _BottomItem(label: 'المعاينات', icon: Icons.calendar_month_outlined, active: index == 2, onTap: () => setState(() => index = 2)),
                _BottomItem(label: 'الملف الشخصي', icon: Icons.person_outline_rounded, active: index == 3, onTap: () => setState(() => index = 3)),
              ]),
              Positioned(
                top: -22,
                child: InkWell(
                  onTap: () => go(context, const DiscoveryMapPage()),
                  customBorder: const CircleBorder(),
                  child: ClipPath(
                    clipper: _CenterHexClipper(),
                    child: Container(
                      width: 76,
                      height: 70,
                      color: const Color(0xFF57B8BE),
                      alignment: Alignment.center,
                      child: const Icon(Icons.map_outlined, color: Colors.white, size: 30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  const _BottomItem({required this.label, required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
        child: InkWell(
          onTap: onTap,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 25, color: active ? const Color(0xFF57B8BE) : const Color(0xFF9A9E9E)),
            const SizedBox(height: 5),
            Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 9.5, color: active ? const Color(0xFF57B8BE) : const Color(0xFF9A9E9E), fontWeight: active ? FontWeight.w800 : FontWeight.w600)),
          ]),
        ),
      );
}

class _CenterHexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(w * .50, 0)
      ..lineTo(w * .94, h * .24)
      ..lineTo(w * .94, h * .72)
      ..lineTo(w * .50, h)
      ..lineTo(w * .06, h * .72)
      ..lineTo(w * .06, h * .24)
      ..close();
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}'''
text = replace_between(text, 'class Shell extends StatefulWidget', 'class HomePage extends StatelessWidget', shell)

account = r'''class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0B0D0D);
    const panel = Color(0xFF1B1D1D);
    const border = Color(0xFF353838);
    const tile = Color(0xFF2B2E2E);
    const teal = Color(0xFF57B8BE);
    const text = Color(0xFFF5F5F5);
    const sub = Color(0xFFA5A8A8);

    return ColoredBox(
      color: bg,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 118),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
              decoration: BoxDecoration(
                color: panel,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: border, width: 1.5),
              ),
              child: Row(children: [
                InkWell(
                  onTap: () {},
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(color: Color(0xFF292B2B), shape: BoxShape.circle),
                    child: const Icon(Icons.edit_outlined, color: Colors.white, size: 23),
                  ),
                ),
                const SizedBox(width: 18),
                const Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('مستخدم تجريبي', style: TextStyle(color: text, fontSize: 19, fontWeight: FontWeight.w800)),
                    SizedBox(height: 5),
                    Text('user@example.com', textDirection: TextDirection.ltr, style: TextStyle(color: text, fontSize: 13, fontWeight: FontWeight.w500)),
                  ]),
                ),
                const SizedBox(width: 18),
                Container(
                  width: 82,
                  height: 82,
                  decoration: const BoxDecoration(color: Color(0xFF1E3334), shape: BoxShape.circle),
                  child: const Icon(Icons.person_outline_rounded, color: teal, size: 50),
                ),
              ]),
            ),
            const SizedBox(height: 38),
            Container(
              decoration: BoxDecoration(
                color: panel,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border, width: 1.3),
              ),
              child: Column(children: [
                _ProfileMenuRow(icon: Icons.route_outlined, title: 'رحلتي العقارية', onTap: () => go(context, const JourneyPage())),
                const _DarkDivider(),
                _ProfileMenuRow(icon: Icons.favorite_rounded, title: 'المفضلة', onTap: () => go(context, const FavoritesPage())),
                const _DarkDivider(),
                _ProfileMenuRow(icon: Icons.bookmark_outline_rounded, title: 'عمليات البحث المحفوظة', onTap: () => go(context, const SavedSearchesPage())),
                const _DarkDivider(),
                _ProfileMenuRow(icon: Icons.compare_arrows_rounded, title: 'مقارنة العقارات', onTap: () => go(context, const ComparePage())),
                const _DarkDivider(),
                _ProfileMenuRow(icon: Icons.notifications_none_rounded, title: 'الإشعارات', onTap: () => go(context, const NotificationPrefsPage())),
                const _DarkDivider(),
                _ProfileMenuRow(icon: Icons.support_agent_outlined, title: 'الدعم والمساعدة', onTap: () => go(context, const SupportPage())),
                const _DarkDivider(),
                _ProfileMenuRow(icon: Icons.lock_outline_rounded, title: 'الخصوصية والأمان', onTap: () => go(context, const PrivacyPage())),
                const _DarkDivider(),
                _ProfileMenuRow(icon: Icons.settings_rounded, title: 'التفضيلات والإعدادات', leading: 'AR', onTap: () => go(context, const NotificationPrefsPage())),
              ]),
            ),
            const SizedBox(height: 18),
            TextButton.icon(
              onPressed: () => go(context, const LoginPage()),
              style: TextButton.styleFrom(foregroundColor: sub, padding: const EdgeInsets.symmetric(vertical: 15)),
              icon: const Icon(Icons.logout_rounded, size: 19),
              label: const Text('تسجيل الخروج من العرض التجريبي', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? leading;
  final VoidCallback onTap;
  const _ProfileMenuRow({required this.icon, required this.title, this.leading, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 84,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              if (leading != null) ...[
                const Icon(Icons.chevron_left_rounded, color: Color(0xFF9A9E9E), size: 20),
                const SizedBox(width: 8),
                Text(leading!, style: const TextStyle(color: Color(0xFF9A9E9E), fontSize: 15)),
              ],
              const Spacer(),
              Text(title, textAlign: TextAlign.right, style: const TextStyle(color: Color(0xFFF5F5F5), fontSize: 17, fontWeight: FontWeight.w700)),
              const SizedBox(width: 18),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: const Color(0xFF2C2E2E), borderRadius: BorderRadius.circular(6)),
                child: Icon(icon, color: Colors.white, size: 27),
              ),
            ]),
          ),
        ),
      );
}

class _DarkDivider extends StatelessWidget {
  const _DarkDivider();
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Divider(height: 1, thickness: 1, color: Color(0xFF343737)),
      );
}'''
text = replace_between(text, 'class AccountPage extends StatelessWidget', 'class NotificationPrefsPage extends StatelessWidget', account)

path.write_text(text)
