# KasirKu — Navigation v0.1

KasirKu adalah prototype aplikasi kasir sederhana berbasis Flutter. Versi Navigation v0.1 melanjutkan prototype v0.0 dengan pemisahan alur kasir ke beberapa halaman.

## Fitur v0.1
- Menampilkan daftar produk dan harga.
- Menambahkan produk ke keranjang.
- Menghitung total belanja.
- Navigasi dari halaman kasir ke halaman pembayaran menggunakan `Navigator.push()`.
- Kembali ke halaman sebelumnya menggunakan `Navigator.pop()`.
- Input nominal pembayaran menggunakan `TextField` dan hanya menerima angka.
- Validasi jika pembayaran kurang dari total belanja.
- Menghitung kembalian dan menampilkan halaman transaksi berhasil.
- Menampilkan feedback menggunakan `SnackBar`.
- Keranjang dikosongkan setelah pembayaran simulasi berhasil.

## Menjalankan aplikasi
Pastikan Flutter SDK sudah terpasang. Dari folder root proyek:

```bash
flutter pub get
flutter analyze
flutter run -d chrome
```

Untuk menjalankan pada perangkat yang terdeteksi, periksa terlebih dahulu:

```bash
flutter devices
```

## Alur navigasi
1. Halaman Kasir: pilih produk dan tekan **Tambah**.
2. Tekan **Lanjut ke Pembayaran**.
3. Masukkan nominal pembayaran, lalu tekan **Konfirmasi Pembayaran**.
4. Halaman Transaksi Berhasil menampilkan total, uang diterima, dan kembalian.
5. Tekan **Kembali ke Halaman Kasir**.

## Catatan
Pembayaran pada prototype ini hanya simulasi. Belum ada integrasi payment gateway, database, atau pencetakan struk. Data produk masih ditulis langsung di kode.

## Bukti running
Ambil screenshot aplikasi setelah dijalankan pada perangkatmu sendiri, kemudian lampirkan di LMS. Jangan mengklaim screenshot atau pengujian yang belum dilakukan.
