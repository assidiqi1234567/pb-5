import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const KasirKuApp());
}

class KasirKuApp extends StatelessWidget {
  const KasirKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KasirKu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const KasirPage(),
    );
  }
}

class Produk {
  final String nama;
  final int harga;

  const Produk({required this.nama, required this.harga});
}

class KasirPage extends StatefulWidget {
  const KasirPage({super.key});

  @override
  State<KasirPage> createState() => _KasirPageState();
}

class _KasirPageState extends State<KasirPage> {
  final List<Produk> produk = const [
    Produk(nama: 'Nasi Goreng', harga: 15000),
    Produk(nama: 'Mie Goreng', harga: 12000),
    Produk(nama: 'Ayam Geprek', harga: 18000),
    Produk(nama: 'Es Teh', harga: 5000),
    Produk(nama: 'Kopi', harga: 8000),
  ];

  final List<Produk> keranjang = [];

  int get totalHarga => keranjang.fold(0, (total, item) => total + item.harga);

  String formatRupiah(int angka) {
    final digits = angka.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString()}';
  }

  void tambahKeKeranjang(Produk item) {
    setState(() => keranjang.add(item));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.nama} ditambahkan ke keranjang')),
    );
  }

  void hapusKeranjang() {
    if (keranjang.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Keranjang sudah kosong')));
      return;
    }
    setState(() => keranjang.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Keranjang telah dikosongkan')),
    );
  }

  Future<void> bukaPembayaran() async {
    if (keranjang.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tambahkan produk sebelum membayar')),
      );
      return;
    }

    final total = totalHarga;
    final itemDibeli = List<Produk>.from(keranjang);

    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => PembayaranPage(
          items: itemDibeli,
          total: total,
          formatRupiah: formatRupiah,
          onPembayaranBerhasil: () {
            if (mounted) {
              setState(() => keranjang.clear());
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KasirKu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat datang di KasirKu',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Aplikasi kasir sederhana untuk warung, kantin, dan UMKM.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Daftar Produk',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...produk.map(
              (item) => Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text(item.nama.substring(0, 1))),
                  title: Text(item.nama),
                  subtitle: Text(formatRupiah(item.harga)),
                  trailing: FilledButton(
                    onPressed: () => tambahKeKeranjang(item),
                    child: const Text('Tambah'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Keranjang (${keranjang.length} barang)',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (keranjang.isEmpty)
                      const Text('Keranjang masih kosong')
                    else
                      ...keranjang.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${entry.key + 1}. ${entry.value.nama}',
                                ),
                              ),
                              Text(formatRupiah(entry.value.harga)),
                            ],
                          ),
                        ),
                      ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total belanja',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatRupiah(totalHarga),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: bukaPembayaran,
                        icon: const Icon(Icons.payment),
                        label: const Text('Lanjut ke Pembayaran'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: hapusKeranjang,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Kosongkan Keranjang'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PembayaranPage extends StatefulWidget {
  final List<Produk> items;
  final int total;
  final String Function(int) formatRupiah;
  final VoidCallback onPembayaranBerhasil;

  const PembayaranPage({
    super.key,
    required this.items,
    required this.total,
    required this.formatRupiah,
    required this.onPembayaranBerhasil,
  });

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final TextEditingController uangController = TextEditingController();
  String? pesanError;

  int get uangDibayar => int.tryParse(uangController.text.trim()) ?? 0;
  int get kembalian => uangDibayar - widget.total;

  @override
  void dispose() {
    uangController.dispose();
    super.dispose();
  }

  void konfirmasiPembayaran() {
    if (uangDibayar < widget.total) {
      setState(() => pesanError = 'Uang pembayaran belum mencukupi.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nominal pembayaran kurang dari total belanja'),
        ),
      );
      return;
    }

    widget.onPembayaranBerhasil();

    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute(
        builder: (_) => TransaksiBerhasilPage(
          items: widget.items,
          total: widget.total,
          dibayar: uangDibayar,
          kembalian: kembalian,
          formatRupiah: widget.formatRupiah,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        leading: IconButton(
          tooltip: 'Kembali ke kasir',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Belanja',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  ...widget.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(child: Text(item.nama)),
                          Text(widget.formatRupiah(item.harga)),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total yang harus dibayar'),
                      Text(
                        widget.formatRupiah(widget.total),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Nominal Pembayaran',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: uangController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              prefixText: 'Rp ',
              hintText: 'Contoh: 50000',
              border: const OutlineInputBorder(),
              helperText: 'Masukkan nominal angka tanpa titik atau koma.',
              errorText: pesanError,
            ),
            onChanged: (_) => setState(() => pesanError = null),
          ),
          const SizedBox(height: 12),
          if (uangController.text.isNotEmpty)
            Card(
              color: kembalian >= 0
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(kembalian >= 0 ? 'Kembalian' : 'Kekurangan'),
                    Text(
                      widget.formatRupiah(
                        kembalian >= 0 ? kembalian : -kembalian,
                      ),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: konfirmasiPembayaran,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Konfirmasi Pembayaran'),
            ),
          ),
        ],
      ),
    );
  }
}

class TransaksiBerhasilPage extends StatelessWidget {
  final List<Produk> items;
  final int total;
  final int dibayar;
  final int kembalian;
  final String Function(int) formatRupiah;

  const TransaksiBerhasilPage({
    super.key,
    required this.items,
    required this.total,
    required this.dibayar,
    required this.kembalian,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Berhasil'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 84, color: Colors.green.shade600),
              const SizedBox(height: 16),
              Text(
                'Pembayaran Berhasil!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Terima kasih. Transaksi simulasi telah selesai.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _ReceiptRow(
                        label: 'Jumlah barang',
                        value: '${items.length}',
                      ),
                      const Divider(height: 24),
                      _ReceiptRow(
                        label: 'Total belanja',
                        value: formatRupiah(total),
                      ),
                      const SizedBox(height: 10),
                      _ReceiptRow(
                        label: 'Uang diterima',
                        value: formatRupiah(dibayar),
                      ),
                      const SizedBox(height: 10),
                      _ReceiptRow(
                        label: 'Kembalian',
                        value: formatRupiah(kembalian),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.point_of_sale),
                  label: const Text('Kembali ke Halaman Kasir'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReceiptRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
