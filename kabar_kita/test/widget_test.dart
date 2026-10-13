import 'package:flutter_test/flutter_test.dart';
import 'package:kabar_kita/main.dart';

void main() {
  testWidgets('Login page tampil saat aplikasi dibuka', (tester) async {
    await tester.pumpWidget(const KabarKitaApp());
    expect(find.text('Selamat datang di Kabar Kita'), findsOneWidget);
    expect(find.text('Daftar sekarang'), findsOneWidget);
  });

  testWidgets('Pengguna dapat membuka halaman registrasi lalu kembali', (
    tester,
  ) async {
    await tester.pumpWidget(const KabarKitaApp());
    await tester.ensureVisible(find.text('Daftar sekarang'));
    await tester.tap(find.text('Daftar sekarang'));
    await tester.pumpAndSettle();
    expect(find.text('Buat akun Kabar Kita'), findsOneWidget);
    await tester.ensureVisible(find.text('Sudah punya akun? Kembali ke login'));
    await tester.tap(find.text('Sudah punya akun? Kembali ke login'));
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang di Kabar Kita'), findsOneWidget);
  });

  testWidgets('Reset password dapat dibuka dari Login', (tester) async {
    await tester.pumpWidget(const KabarKitaApp());
    await tester.ensureVisible(find.text('Lupa password?'));
    await tester.tap(find.text('Lupa password?'));
    await tester.pumpAndSettle();
    expect(find.text('Reset password'), findsOneWidget);
    expect(find.text('Kembali ke login'), findsOneWidget);
  });
}
