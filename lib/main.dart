import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const KampusApp());

class KampusApp extends StatefulWidget {
  const KampusApp({super.key});

  @override
  State<KampusApp> createState() => _KampusAppState();
}

class _KampusAppState extends State<KampusApp> {
  bool darkMode = false;
  bool loggedIn = false;

  void setLoggedIn(bool value) {
    setState(() => loggedIn = value);
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF101B33);
    const blue = Color(0xFF2563EB);

    final lightScheme = ColorScheme.fromSeed(
      seedColor: blue,
      brightness: Brightness.light,
    );
    final darkScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF60A5FA),
      brightness: Brightness.dark,
      surface: const Color(0xFF1B2A49),
    );

    return MaterialApp(
      title: 'Kampusku',
      debugShowCheckedModeBanner: false,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      themeAnimationDuration: const Duration(milliseconds: 700),
      themeAnimationCurve: Curves.easeInOutCubic,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        scaffoldBackgroundColor: const Color(0xFFF3F6FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: navy,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        scaffoldBackgroundColor: navy,
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1B2A49),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      home: loggedIn
          ? KampusHome(
              darkMode: darkMode,
              onThemeChanged: () => setState(() => darkMode = !darkMode),
              onLogout: () => setLoggedIn(false),
            )
          : LoginPage(onLogin: () => setLoggedIn(true)),
    );
  }
}

class LoginPage extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginPage({super.key, required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nimController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    // Login demo lokal: input tidak diperiksa ke server/database.
    widget.onLogin();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(26),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            Icons.school_rounded,
                            size: 42,
                            color: colors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'KAMPUSKU',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selamat datang!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Masuk untuk melihat informasi mahasiswa.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 26),
                      TextFormField(
                        controller: _nimController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'NIM',
                          prefixIcon: Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'NIM wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            tooltip: _obscurePassword
                                ? 'Tampilkan password'
                                : 'Sembunyikan password',
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Password wajib diisi'
                            : null,
                        onFieldSubmitted: (_) => _login(),
                      ),
                      const SizedBox(height: 22),
                      FilledButton(
                        onPressed: _login,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Masuk'),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Mode demo: isi NIM dan password apa saja.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KampusHome extends StatefulWidget {
  final bool darkMode;
  final VoidCallback onThemeChanged;
  final VoidCallback onLogout;

  const KampusHome({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
    required this.onLogout,
  });

  @override
  State<KampusHome> createState() => _KampusHomeState();
}

class _KampusHomeState extends State<KampusHome> {
  String nama = 'Mochamad Basa';
  final String nim = '2495114005';
  final String prodi = 'Teknik Informatika';
  final String kampus = 'Universitas Hasyim Asy’ari';
  String email = 'mochamadbasa@mhs.unhasy.ac.id';
  String hobi = 'Bermain game';

  bool favorit = false;
  int halaman = 0;
  Uint8List? fotoProfil;
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, String>> jadwal = [
    {
      'hari': 'Senin',
      'jam': '08.00–09.40',
      'matkul': 'Pemrograman Mobile',
      'ruang': 'Lab Komputer 2',
    },
    {
      'hari': 'Selasa',
      'jam': '10.00–11.40',
      'matkul': 'Basis Data',
      'ruang': 'Ruang B-203',
    },
    {
      'hari': 'Rabu',
      'jam': '13.00–14.40',
      'matkul': 'Rekayasa Perangkat Lunak',
      'ruang': 'Ruang A-105',
    },
    {
      'hari': 'Kamis',
      'jam': '08.00–09.40',
      'matkul': 'Jaringan Komputer',
      'ruang': 'Lab Jaringan',
    },
  ];

  Future<void> _pilihFoto() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file == null) return;

      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() => fotoProfil = bytes);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil diperbarui')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto tidak dapat dibuka. Coba pilih gambar lain.'),
        ),
      );
    }
  }

  Future<void> _editProfil() async {
    final namaC = TextEditingController(text: nama);
    final emailC = TextEditingController(text: email);
    final hobiC = TextEditingController(text: hobi);

    final hasil = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaC,
                decoration: const InputDecoration(
                  labelText: 'Nama mahasiswa',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              TextField(
                controller: emailC,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              TextField(
                controller: hobiC,
                decoration: const InputDecoration(
                  labelText: 'Hobi',
                  prefixIcon: Icon(Icons.favorite_outline),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (hasil == true && mounted) {
      setState(() {
        if (namaC.text.trim().isNotEmpty) nama = namaC.text.trim();
        email = emailC.text.trim();
        hobi = hobiC.text.trim();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
    }

    namaC.dispose();
    emailC.dispose();
    hobiC.dispose();
  }

  Future<void> _konfirmasiLogout() async {
    final keluar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu akan kembali ke halaman login.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (keluar == true) widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    final dark = widget.darkMode;
    final accent = dark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
    final surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.school_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 23,
              ),
            ),
            const SizedBox(width: 11),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Kampusku',
                  style: TextStyle(
                    fontSize: 19,
                    letterSpacing: -0.4,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Portal Akademik',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: dark ? 'Mode terang' : 'Mode gelap',
            onPressed: widget.onThemeChanged,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) => RotationTransition(
                turns: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Icon(
                dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey<bool>(dark),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: _konfirmasiLogout,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: KeyedSubtree(
          key: ValueKey<int>(halaman),
          child: halaman == 0
              ? _beranda(dark, accent, surface)
              : _akademik(dark, accent, surface),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: halaman,
        onDestinationSelected: (index) => setState(() => halaman = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school_rounded),
            label: 'Akademik',
          ),
        ],
      ),
    );
  }

  Widget _beranda(bool dark, Color accent, Color surface) {
    return ListView(
      key: const PageStorageKey<String>('beranda'),
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Halo, Mahasiswa! 👋',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'Kelola informasi profilmu di sini.',
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: dark
                  ? const [Color(0xFF243D68), Color(0xFF1B2A49)]
                  : const [Color(0xFF2563EB), Color(0xFF1745A5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.verified_user, color: Colors.white70),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'PROFIL MAHASISWA',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: favorit ? 'Hapus favorit' : 'Jadikan favorit',
                    onPressed: () => setState(() => favorit = !favorit),
                    color: Colors.white,
                    icon: Icon(
                      favorit ? Icons.favorite : Icons.favorite_border,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    backgroundImage: fotoProfil == null
                        ? null
                        : MemoryImage(fotoProfil!),
                    child: fotoProfil == null
                        ? const Icon(
                            Icons.person,
                            size: 54,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: 'Pilih foto profil',
                      onPressed: _pilihFoto,
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Color(0xFF2563EB),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                nama,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(nim, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '●  Mahasiswa',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: _pilihFoto,
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                icon: const Icon(Icons.photo_library_outlined, size: 18),
                label: const Text('Ganti foto profil'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Informasi Saya',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton.icon(
              onPressed: _editProfil,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _infoCard(
          surface,
          accent,
          Icons.menu_book_outlined,
          'Program Studi',
          'Teknik Informatika',
        ),
        _infoCard(
          surface,
          accent,
          Icons.account_balance_outlined,
          'Perguruan Tinggi',
          'Universitas Hasyim Asy’ari',
        ),
        _infoCard(surface, accent, Icons.email_outlined, 'Email', email),
        _infoCard(surface, accent, Icons.sports_esports_outlined, 'Hobi', hobi),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _editProfil,
          icon: const Icon(Icons.manage_accounts_outlined),
          label: const Text('Edit Informasi Profil'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _konfirmasiLogout,
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoCard(
    Color surface,
    Color accent,
    IconData icon,
    String label,
    String value,
  ) {
    return Card(
      color: surface,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: accent),
        ),
        title: Text(
          label,
          style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Future<void> _formJadwal({int? index}) async {
    final dataLama = index == null ? null : jadwal[index];
    final matkulC = TextEditingController(text: dataLama?['matkul'] ?? '');
    final jamC = TextEditingController(text: dataLama?['jam'] ?? '');
    final ruangC = TextEditingController(text: dataLama?['ruang'] ?? '');
    String hari = dataLama?['hari'] ?? 'Senin';

    final hasil = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(index == null ? 'Tambah Jadwal' : 'Edit Jadwal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: matkulC,
                  decoration: const InputDecoration(
                    labelText: 'Nama mata kuliah',
                    prefixIcon: Icon(Icons.menu_book_outlined),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: hari,
                  decoration: const InputDecoration(
                    labelText: 'Hari',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  items:
                      const [
                            'Senin',
                            'Selasa',
                            'Rabu',
                            'Kamis',
                            'Jumat',
                            'Sabtu',
                          ]
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) setDialogState(() => hari = value);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: jamC,
                  decoration: const InputDecoration(
                    labelText: 'Jam (contoh: 08.00–09.40)',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ruangC,
                  decoration: const InputDecoration(
                    labelText: 'Ruangan',
                    prefixIcon: Icon(Icons.meeting_room_outlined),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                if (matkulC.text.trim().isEmpty ||
                    jamC.text.trim().isEmpty ||
                    ruangC.text.trim().isEmpty) {
                  return;
                }
                Navigator.pop(dialogContext, {
                  'hari': hari,
                  'jam': jamC.text.trim(),
                  'matkul': matkulC.text.trim(),
                  'ruang': ruangC.text.trim(),
                });
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );

    matkulC.dispose();
    jamC.dispose();
    ruangC.dispose();

    if (hasil != null && mounted) {
      setState(() {
        if (index == null) {
          jadwal.add(hasil);
        } else {
          jadwal[index] = hasil;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            index == null
                ? 'Jadwal berhasil ditambahkan'
                : 'Jadwal berhasil diperbarui',
          ),
        ),
      );
    }
  }

  Future<void> _hapusJadwal(int index) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus jadwal?'),
        content: Text('Jadwal "${jadwal[index]['matkul']}" akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true && mounted) {
      setState(() => jadwal.removeAt(index));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Jadwal berhasil dihapus')));
    }
  }

  Widget _akademik(bool dark, Color accent, Color surface) {
    return ListView(
      key: const PageStorageKey<String>('akademik'),
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Akademik',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'Atur jadwal kuliahmu dalam satu tempat.',
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
        const SizedBox(height: 20),
        Card(
          color: surface,
          child: SwitchListTile(
            secondary: Icon(
              dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: accent,
            ),
            title: const Text('Mode tampilan'),
            subtitle: Text(dark ? 'Mode gelap aktif' : 'Mode terang aktif'),
            value: dark,
            onChanged: (_) => widget.onThemeChanged(),
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Jadwal Kuliah',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ),
            FilledButton.icon(
              onPressed: () => _formJadwal(),
              icon: const Icon(Icons.add, size: 19),
              label: const Text('Tambah'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (jadwal.isEmpty)
          Card(
            color: surface,
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.event_busy_outlined, size: 38),
                  SizedBox(height: 10),
                  Text('Belum ada jadwal kuliah.'),
                  Text('Tekan tombol Tambah untuk membuat jadwal.'),
                ],
              ),
            ),
          )
        else
          for (int i = 0; i < jadwal.length; i++)
            Card(
              color: surface,
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(Icons.calendar_month_outlined, color: accent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jadwal[i]['matkul']!,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 5),
                          Text('${jadwal[i]['hari']} • ${jadwal[i]['jam']}'),
                          Text(jadwal[i]['ruang']!),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      tooltip: 'Kelola jadwal',
                      onSelected: (value) {
                        if (value == 'edit') {
                          _formJadwal(index: i);
                        } else if (value == 'hapus') {
                          _hapusJadwal(i);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit_outlined),
                            title: Text('Edit'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'hapus',
                          child: ListTile(
                            leading: Icon(Icons.delete_outline),
                            title: Text('Hapus'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        const SizedBox(height: 8),
        Text(
          'Jadwal ini masih tersimpan sementara selama aplikasi berjalan.',
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: Theme.of(context).hintColor),
        ),
      ],
    );
  }
}
