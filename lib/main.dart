import 'package:flutter/material.dart';

const terracotta = Color(0xFFC96342);
const krem = Color(0xFFFDF6EC);
const cokelatTua = Color(0xFF4A3428);
const peach = Color(0xFFFCEEE3);

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: RestoranPage()));

class Menu {
  final String nama, gambar;
  final int harga;
  const Menu(this.nama, this.harga, this.gambar);
}

final daftarMenu = [
  Menu('Grilled Sirloin Steak', 145000, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200'),
  Menu('Truffle Carbonara', 98000, 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=200'),
  Menu('Grilled Salmon', 128000, 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=200'),
];

String rp(int n) => 'Rp${n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

class RestoranPage extends StatefulWidget {
  const RestoranPage({super.key});
  @override
  State<RestoranPage> createState() => _RestoranPageState();
}

class _RestoranPageState extends State<RestoranPage> {
  final keranjang = <String, int>{};
  final favorit = <String>{};

  int get totalItem => keranjang.values.fold(0, (a, b) => a + b);
  int get totalHarga => keranjang.entries.fold(
      0, (t, e) => t + daftarMenu.firstWhere((m) => m.nama == e.key).harga * e.value);

  void tambah(Menu m) => setState(() => keranjang[m.nama] = (keranjang[m.nama] ?? 0) + 1);
  void toggleFavorit(String n) => setState(() => favorit.contains(n) ? favorit.remove(n) : favorit.add(n));

  void reservasi() => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: krem,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Konfirmasi Reservasi', style: TextStyle(color: cokelatTua)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: keranjang.isEmpty
                ? [const Text('Belum ada pesanan dipilih.')]
                : [
                    ...keranjang.entries.map((e) => Text('${e.key} x${e.value}')),
                    const SizedBox(height: 6),
                    Text('Total: ${rp(totalHarga)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: terracotta,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(keranjang.clear);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Reservasi berhasil dikirim!')));
              },
              child: const Text('Konfirmasi', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

  Widget pilStat(IconData ic, String nilai, String label) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: peach, borderRadius: BorderRadius.circular(18)),
          child: Column(children: [
            Icon(ic, color: terracotta, size: 20),
            const SizedBox(height: 4),
            Text(nilai, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: cokelatTua)),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.brown)),
          ]),
        ),
      );

  Widget barisMenu(Menu m) {
    final suka = favorit.contains(m.nama);
    final jumlah = keranjang[m.nama] ?? 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.brown.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(m.gambar, width: 64, height: 64, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m.nama, style: const TextStyle(fontWeight: FontWeight.w600, color: cokelatTua)),
            const SizedBox(height: 4),
            Text(rp(m.harga), style: const TextStyle(color: terracotta, fontWeight: FontWeight.bold, fontSize: 13)),
          ]),
        ),
        IconButton(
          onPressed: () => toggleFavorit(m.nama),
          icon: Icon(suka ? Icons.favorite : Icons.favorite_border, color: suka ? Colors.red : Colors.brown[200]),
        ),
        InkWell(
          onTap: () => tambah(m),
          borderRadius: BorderRadius.circular(20),
          child: CircleAvatar(
            radius: 15,
            backgroundColor: terracotta,
            child: jumlah > 0
                ? Text('$jumlah', style: const TextStyle(color: Colors.white, fontSize: 12))
                : const Icon(Icons.add, color: Colors.white, size: 15),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: krem,
      appBar: AppBar(
        backgroundColor: krem,
        elevation: 0,
        iconTheme: const IconThemeData(color: cokelatTua),
        title: const Text('Detail Restoran', style: TextStyle(color: cokelatTua, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width - 32,
        height: 54,
        child: FloatingActionButton.extended(
          onPressed: reservasi,
          backgroundColor: terracotta,
          shape: const StadiumBorder(),
          icon: const Icon(Icons.restaurant_menu, color: Colors.white),
          label: Text(totalItem > 0 ? 'Reservasi • $totalItem item' : 'Reservasi Sekarang',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 100),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Foto rounded, bukan fullwidth edge-to-edge
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              'https://images.unsplash.com/photo-1544148103-0773bf10d330?w=800',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            const Expanded(
              child: Text('La Brasserie Bistro',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: cokelatTua)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: peach, borderRadius: BorderRadius.circular(20)),
              child: Row(mainAxisSize: MainAxisSize.min, children: const [
                Icon(Icons.star, color: terracotta, size: 14),
                SizedBox(width: 4),
                Text('4.8', style: TextStyle(color: terracotta, fontWeight: FontWeight.bold, fontSize: 12)),
              ]),
            ),
          ]),
          const SizedBox(height: 4),
          const Text('Western • Bistro  ·  Jl. Kemang Raya No.45', style: TextStyle(color: Colors.brown, fontSize: 12.5)),
          const SizedBox(height: 16),
          Row(children: [
            pilStat(Icons.near_me_rounded, '2.5 km', 'Jarak'),
            pilStat(Icons.access_time_rounded, '10-22.00', 'Jam Buka'),
            pilStat(Icons.payments_rounded, 'Rp100rb', 'Rata-rata'),
          ]),
          const SizedBox(height: 20),
          const Text('Cerita Kami', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: cokelatTua)),
          const SizedBox(height: 6),
          const Text(
            'Bersantap ala Eropa dengan suasana hangat, bahan pilihan, dan sentuhan personal di setiap hidangan.',
            style: TextStyle(color: Colors.brown, fontSize: 12.5, height: 1.5),
          ),
          const SizedBox(height: 22),
          const Text('Menu Favorit Pengunjung',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: cokelatTua)),
          const SizedBox(height: 12),
          ...daftarMenu.map(barisMenu),
          if (totalItem > 0)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: peach, borderRadius: BorderRadius.circular(18)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('$totalItem item dipilih', style: const TextStyle(color: cokelatTua, fontWeight: FontWeight.w600)),
                Text(rp(totalHarga), style: const TextStyle(fontWeight: FontWeight.bold, color: terracotta)),
              ]),
            ),
        ]),
      ),
    );
  }
}
