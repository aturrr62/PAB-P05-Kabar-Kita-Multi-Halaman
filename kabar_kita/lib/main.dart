import 'package:flutter/material.dart';

void main() => runApp(const KabarKitaApp());

class AppColors {
  static const teal = Color(0xFF0F766E);
  static const tealLight = Color(0xFFDDF4EF);
  static const background = Color(0xFFF4F7F8);
  static const ink = Color(0xFF172B2A);
  static const muted = Color(0xFF72807F);
  static const border = Color(0xFFE1E9E8);
}

class KabarKitaApp extends StatelessWidget {
  const KabarKitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kabar Kita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.teal),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.ink,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.teal, width: 1.6),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
            backgroundColor: AppColors.teal,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Email wajib diisi.';
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
    return 'Masukkan alamat email yang valid.';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password wajib diisi.';
  if (value.length < 6) return 'Password minimal 6 karakter.';
  return null;
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.teal,
        borderRadius: BorderRadius.circular(size * 0.30),
      ),
      child: Icon(
        Icons.newspaper_rounded,
        color: Colors.white,
        size: size * 0.48,
      ),
    );
  }
}

class PageHeading extends StatelessWidget {
  const PageHeading({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 27,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class RegistrationResult {
  final String name;
  final String email;

  const RegistrationResult({required this.name, required this.email});
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _openRegister() async {
    final result = await Navigator.of(context).push<RegistrationResult>(
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
    if (!mounted || result == null) return;
    _emailController.text = result.email;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registrasi berhasil, ${result.name}. Silakan masuk.'),
      ),
    );
  }

  Future<void> _openResetPassword() async {
    final resetEmail = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
    );
    if (!mounted || resetEmail == null) return;
    _emailController.text = resetEmail;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Instruksi reset ditampilkan untuk $resetEmail.')),
    );
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MainNavigationPage(email: _emailController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BrandMark(),
                  const SizedBox(height: 28),
                  const PageHeading(
                    title: 'Selamat datang di Kabar Kita',
                    subtitle: 'Masuk untuk membaca berita terbaru dan menyimpan berita favoritmu.',
                  ),
                  const SizedBox(height: 28),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          key: const Key('loginEmailField'),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'nama@email.com',
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                          ),
                          validator: validateEmail,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key('loginPasswordField'),
                          controller: _passwordController,
                          obscureText: _hidePassword,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              tooltip: _hidePassword
                                  ? 'Tampilkan password'
                                  : 'Sembunyikan password',
                              onPressed: () => setState(
                                () => _hidePassword = !_hidePassword,
                              ),
                              icon: Icon(
                                _hidePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: validatePassword,
                          onFieldSubmitted: (_) => _login(),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _openResetPassword,
                            child: const Text('Lupa password?'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          key: const Key('loginButton'),
                          onPressed: _login,
                          child: const Text('Masuk'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun?',
                        style: TextStyle(color: AppColors.muted),
                      ),
                      TextButton(
                        onPressed: _openRegister,
                        child: const Text('Daftar sekarang'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'KABAR KITA • PORTAL BERITA',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 10,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      RegistrationResult(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BrandMark(size: 56),
                    const SizedBox(height: 24),
                    const PageHeading(
                      title: 'Buat akun Kabar Kita',
                      subtitle: 'Daftar agar kamu bisa membaca dan menyimpan berita favorit.',
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const Key('registerNameField'),
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nama lengkap',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Nama wajib diisi.'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      key: const Key('registerEmailField'),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'nama@email.com',
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      key: const Key('registerPasswordField'),
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      key: const Key('registerConfirmField'),
                      controller: _confirmController,
                      obscureText: _hideConfirm,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Konfirmasi password',
                        prefixIcon: const Icon(Icons.verified_user_outlined),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _hideConfirm = !_hideConfirm),
                          icon: Icon(
                            _hideConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi password wajib diisi.';
                        }
                        if (value != _passwordController.text) {
                          return 'Password tidak sama.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _register(),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      key: const Key('registerButton'),
                      onPressed: _register,
                      child: const Text('Buat akun'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Sudah punya akun? Kembali ke login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetInstructions() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: AppColors.tealLight,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined,
                        color: AppColors.teal,
                        size: 34,
                      ),
                    ),
                    const SizedBox(height: 26),
                    const PageHeading(
                      title: 'Reset password',
                      subtitle: 'Masukkan email akun Kabar Kita untuk mendapatkan instruksi reset password (simulasi).',
                    ),
                    const SizedBox(height: 26),
                    TextFormField(
                      key: const Key('resetEmailField'),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Email terdaftar',
                        hintText: 'nama@email.com',
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                      validator: validateEmail,
                      onFieldSubmitted: (_) => _sendResetInstructions(),
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton(
                      key: const Key('resetButton'),
                      onPressed: _sendResetInstructions,
                      child: const Text('Kirim instruksi reset'),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: const Text('Kembali ke login'),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppColors.tealLight.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.teal,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Catatan: halaman ini merupakan simulasi navigasi. Belum mengirim email sungguhan.',
                              style: TextStyle(
                                color: AppColors.ink,
                                height: 1.45,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewsArticle {
  final int id;
  final String title;
  final String category;
  final String time;
  final String excerpt;
  final String content;
  final IconData icon;
  final Color color;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.excerpt,
    required this.content,
    required this.icon,
    required this.color,
  });
}

const List<NewsArticle> sampleNews = [
  NewsArticle(
    id: 1,
    title: 'Teknologi Digital Semakin Berkembang di Indonesia',
    category: 'Teknologi',
    time: '10 menit lalu',
    excerpt: 'Pemanfaatan teknologi digital terus membuka peluang baru bagi masyarakat dan pelaku usaha.',
    content: 'Pemanfaatan teknologi digital terus berkembang di berbagai sektor, mulai dari pendidikan, kesehatan, hingga bisnis. Masyarakat diharapkan dapat menggunakan teknologi secara bijak serta meningkatkan keterampilan digital agar mampu mengikuti perkembangan zaman.',
    icon: Icons.devices_rounded,
    color: Colors.blue,
  ),
  NewsArticle(
    id: 2,
    title: 'Mahasiswa Didukung untuk Mengembangkan Inovasi',
    category: 'Pendidikan',
    time: '35 menit lalu',
    excerpt: 'Berbagai program kampus mendorong mahasiswa mengembangkan ide kreatif menjadi solusi nyata.',
    content: 'Perguruan tinggi terus mendorong mahasiswa untuk mengembangkan inovasi melalui proyek, riset, kompetisi, dan kolaborasi dengan industri. Kegiatan tersebut membantu mahasiswa menerapkan ilmu yang dipelajari untuk menyelesaikan permasalahan di dunia nyata.',
    icon: Icons.school_rounded,
    color: Colors.deepPurple,
  ),
  NewsArticle(
    id: 3,
    title: 'UMKM Mulai Memanfaatkan Pembayaran Digital',
    category: 'Bisnis',
    time: '1 jam lalu',
    excerpt: 'Pembayaran digital membantu usaha kecil memberikan pilihan transaksi yang lebih praktis.',
    content: 'Pelaku usaha mikro, kecil, dan menengah mulai memanfaatkan pembayaran digital untuk memudahkan transaksi pelanggan. Pencatatan transaksi yang lebih rapi juga dapat membantu pemilik usaha mengevaluasi penjualan dan mengelola bisnisnya.',
    icon: Icons.storefront_rounded,
    color: Colors.orange,
  ),
  NewsArticle(
    id: 4,
    title: 'Tips Menjaga Produktivitas di Tengah Kesibukan',
    category: 'Gaya Hidup',
    time: '2 jam lalu',
    excerpt: 'Membuat prioritas harian dan beristirahat secara teratur dapat membantu menjaga fokus.',
    content: 'Produktivitas dapat ditingkatkan dengan menentukan prioritas, membagi pekerjaan menjadi beberapa langkah, dan memberi waktu istirahat yang cukup. Kebiasaan sederhana ini membantu aktivitas harian menjadi lebih terarah dan seimbang.',
    icon: Icons.lightbulb_rounded,
    color: Colors.green,
  ),
  NewsArticle(
    id: 5,
    title: 'Inovasi Lingkungan Mendorong Gaya Hidup Berkelanjutan',
    category: 'Lingkungan',
    time: '3 jam lalu',
    excerpt: 'Kebiasaan mengurangi sampah dan memakai ulang barang dapat dimulai dari lingkungan sekitar.',
    content: 'Upaya menjaga lingkungan dapat dimulai melalui langkah sederhana, seperti memilah sampah, mengurangi barang sekali pakai, dan menggunakan kembali barang yang masih layak. Dukungan masyarakat dan inovasi yang tepat dapat membantu membuat kebiasaan ini lebih mudah diterapkan.',
    icon: Icons.eco_rounded,
    color: Colors.teal,
  ),
];

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key, required this.email});

  final String email;

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  final Set<int> _favoriteIds = <int>{2};

  void _toggleFavorite(NewsArticle article) {
    setState(() {
      if (_favoriteIds.contains(article.id)) {
        _favoriteIds.remove(article.id);
      } else {
        _favoriteIds.add(article.id);
      }
    });
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _openArticle(NewsArticle article) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ArticleDetailPage(
          article: article,
          isFavorite: _favoriteIds.contains(article.id),
          onToggleFavorite: () => _toggleFavorite(article),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteArticles = sampleNews
        .where((article) => _favoriteIds.contains(article.id))
        .toList();

    final pages = <Widget>[
      NewsListPage(
        title: 'Berita Terbaru',
        subtitle: 'Informasi pilihan untuk menemani harimu.',
        articles: sampleNews,
        favoriteIds: _favoriteIds,
        onToggleFavorite: _toggleFavorite,
        onArticleTap: _openArticle,
      ),
      NewsListPage(
        title: 'Berita Favorit',
        subtitle: 'Berita yang kamu simpan untuk dibaca kembali.',
        articles: favoriteArticles,
        favoriteIds: _favoriteIds,
        onToggleFavorite: _toggleFavorite,
        onArticleTap: _openArticle,
        emptyMessage: 'Belum ada berita favorit.\nTekan ikon hati pada berita untuk menyimpannya.',
      ),
      ProfilePage(email: widget.email, onLogout: _logout),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.newspaper_rounded),
            SizedBox(width: 10),
            Text('Kabar Kita', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class NewsListPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<NewsArticle> articles;
  final Set<int> favoriteIds;
  final ValueChanged<NewsArticle> onToggleFavorite;
  final ValueChanged<NewsArticle> onArticleTap;
  final String emptyMessage;

  const NewsListPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.articles,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.onArticleTap,
    this.emptyMessage = 'Berita belum tersedia.',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: Colors.black54),
              ),
            ],
          ),
        ),
        Expanded(
          child: articles.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bookmark_border_rounded,
                          size: 56,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          emptyMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return NewsCard(
                      article: article,
                      isFavorite: favoriteIds.contains(article.id),
                      onTap: () => onArticleTap(article),
                      onFavoriteTap: () => onToggleFavorite(article),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const NewsCard({
    super.key,
    required this.article,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 82,
                height: 88,
                decoration: BoxDecoration(
                  color: article.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(article.icon, size: 38, color: article.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.category.toUpperCase(),
                      style: TextStyle(
                        color: article.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 0.7,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      article.excerpt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.time,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: isFavorite
                    ? 'Hapus dari favorit'
                    : 'Tambahkan ke favorit',
                onPressed: onFavoriteTap,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFavorite ? Colors.redAccent : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArticleDetailPage extends StatefulWidget {
  final NewsArticle article;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const ArticleDetailPage({
    super.key,
    required this.article,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    widget.onToggleFavorite();
    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita'),
        actions: [
          IconButton(
            tooltip: _isFavorite
                ? 'Hapus dari favorit'
                : 'Tambahkan ke favorit',
            onPressed: _toggleFavorite,
            icon: Icon(
              _isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                color: article.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(article.icon, size: 88, color: article.color),
            ),
            const SizedBox(height: 20),
            Text(
              article.category.toUpperCase(),
              style: TextStyle(
                color: article.color,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold, height: 1.2),
            ),
            const SizedBox(height: 10),
            Text(article.time, style: const TextStyle(color: Colors.black54)),
            const Divider(height: 30),
            Text(
              article.content,
              style: const TextStyle(fontSize: 16, height: 1.7),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _toggleFavorite,
              icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
              label: Text(
                _isFavorite ? 'Hapus dari Favorit' : 'Simpan ke Favorit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.email, required this.onLogout});

  final String email;
  final VoidCallback onLogout;

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 14),
        CircleAvatar(
          radius: 46,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.person_rounded,
            size: 50,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Pengguna Kabar Kita',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 28),
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline_rounded),
                title: const Text('Informasi Profil'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () =>
                    _showMessage(context, 'Menu Informasi Profil dipilih.'),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Notifikasi'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showMessage(context, 'Menu Notifikasi dipilih.'),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('Tentang Aplikasi'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'Kabar Kita',
                  applicationVersion: '1.0.0',
                  applicationLegalese:
                      'Contoh tugas Layout dan Navigasi Flutter.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: onLogout,
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Keluar dari akun'),
        ),
        const SizedBox(height: 20),
        const Text(
          'Kabar Kita • Aplikasi latihan Flutter',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black45, fontSize: 12),
        ),
      ],
    );
  }
}
