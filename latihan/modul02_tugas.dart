// Tugas Praktikum Modul 02
// Program Dart: Rekapitulasi data kiriman logistik
// NPM: 714240061 | Nama: Zidan Hairra Ramadhan | Kelas: 3C

// --- Fungsi-fungsi terpisah ---

/// Menghitung total berat dari seluruh kiriman
double hitungTotalBerat(List<Map<String, Object>> kiriman) {
  double total = 0;
  for (final item in kiriman) {
    total += item['berat'] as double;
  }
  return total;
}

/// Menghitung rata-rata berat kiriman
double hitungRataRataBerat(List<Map<String, Object>> kiriman) {
  return hitungTotalBerat(kiriman) / kiriman.length;
}

/// Mencari kiriman dengan berat terberat
Map<String, Object> cariKirimanTerberat(List<Map<String, Object>> kiriman) {
  Map<String, Object> terberat = kiriman[0];
  for (final item in kiriman) {
    if ((item['berat'] as double) > (terberat['berat'] as double)) {
      terberat = item;
    }
  }
  return terberat;
}

/// Mencari kiriman dengan berat teringan
Map<String, Object> cariKirimanTeringan(List<Map<String, Object>> kiriman) {
  Map<String, Object> teringan = kiriman[0];
  for (final item in kiriman) {
    if ((item['berat'] as double) < (teringan['berat'] as double)) {
      teringan = item;
    }
  }
  return teringan;
}

/// Menentukan kategori berdasarkan berat
String tentukanKategori(double berat) {
  if (berat <= 5) {
    return 'Paket Kecil';
  } else if (berat <= 20) {
    return 'Paket Sedang';
  } else {
    return 'Kargo';
  }
}

/// Menghitung jumlah kiriman per kategori
Map<String, int> hitungPerKategori(List<Map<String, Object>> kiriman) {
  final Map<String, int> rekap = {
    'Paket Kecil': 0,
    'Paket Sedang': 0,
    'Kargo': 0,
  };
  for (final item in kiriman) {
    final berat = item['berat'] as double;
    final kategori = tentukanKategori(berat);
    rekap[kategori] = (rekap[kategori] ?? 0) + 1;
  }
  return rekap;
}

/// Menampilkan daftar kiriman dalam format tabel
void tampilkanDaftarKiriman(List<Map<String, Object>> kiriman) {
  print('No  Resi        Kota         Berat(kg)  Kategori');
  print('--  ----------  -----------  ---------  ------------');
  for (int i = 0; i < kiriman.length; i++) {
    final item = kiriman[i];
    final resi = item['resi'] as String;
    final kota = item['kota'] as String;
    final berat = item['berat'] as double;
    final kategori = tentukanKategori(berat);
    print(
      '${(i + 1).toString().padLeft(2)}  '
      '${resi.padRight(10)}  '
      '${kota.padRight(11)}  '
      '${berat.toStringAsFixed(1).padLeft(9)}  '
      '$kategori',
    );
  }
}

/// Menampilkan hasil rekapitulasi
void tampilkanRekap({
  required double totalBerat,
  required double rataRata,
  required Map<String, Object> terberat,
  required Map<String, Object> teringan,
  required Map<String, int> perKategori,
}) {
  print('\n========================================');
  print('       REKAPITULASI DATA KIRIMAN       ');
  print('========================================');
  print('Total berat       : ${totalBerat.toStringAsFixed(2)} kg');
  print('Rata-rata berat   : ${rataRata.toStringAsFixed(2)} kg');
  print(
    'Kiriman terberat  : ${terberat['resi']} '
    '(${(terberat['berat'] as double).toStringAsFixed(1)} kg, '
    '${terberat['kota']})',
  );
  print(
    'Kiriman teringan  : ${teringan['resi']} '
    '(${(teringan['berat'] as double).toStringAsFixed(1)} kg, '
    '${teringan['kota']})',
  );
  print('\n--- Jumlah per Kategori ---');
  perKategori.forEach((kategori, jumlah) {
    print('$kategori   : $jumlah kiriman');
  });
}

// --- Fungsi main() hanya memanggil fungsi dan menampilkan hasil ---

void main() {
  // Daftar minimal 8 kiriman
  final List<Map<String, Object>> kiriman = [
    {'resi': 'SLG-001', 'kota': 'Bandung', 'berat': 3.0},
    {'resi': 'SLG-002', 'kota': 'Surabaya', 'berat': 12.5},
    {'resi': 'SLG-003', 'kota': 'Makassar', 'berat': 7.2},
    {'resi': 'SLG-004', 'kota': 'Surabaya', 'berat': 4.8},
    {'resi': 'SLG-005', 'kota': 'Jayapura', 'berat': 18.0},
    {'resi': 'SLG-006', 'kota': 'Bandung', 'berat': 25.0},
    {'resi': 'SLG-007', 'kota': 'Makassar', 'berat': 2.3},
    {'resi': 'SLG-008', 'kota': 'Jayapura', 'berat': 9.7},
    {'resi': 'SLG-009', 'kota': 'Bandung', 'berat': 1.5},
    {'resi': 'SLG-010', 'kota': 'Surabaya', 'berat': 30.0},
  ];

  // Menampilkan daftar kiriman
  print('========================================');
  print('         DAFTAR DATA KIRIMAN           ');
  print('========================================');
  tampilkanDaftarKiriman(kiriman);

  // Menghitung menggunakan fungsi terpisah
  final totalBerat = hitungTotalBerat(kiriman);
  final rataRata = hitungRataRataBerat(kiriman);
  final terberat = cariKirimanTerberat(kiriman);
  final teringan = cariKirimanTeringan(kiriman);
  final perKategori = hitungPerKategori(kiriman);

  // Menampilkan rekapitulasi
  tampilkanRekap(
    totalBerat: totalBerat,
    rataRata: rataRata,
    terberat: terberat,
    teringan: teringan,
    perKategori: perKategori,
  );
}
