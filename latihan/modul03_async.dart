// Modul 03 - Latihan 3 (async/await) + Latihan 4 (Future.wait) + Tugas Praktikum
// NPM: 714240061 | Nama: Zidan Hairra Ramadhan | Kelas: 3C

// === Exception kustom (digunakan oleh Tugas Praktikum) ===

class ResiTidakDitemukan implements Exception {
  final String resi;
  ResiTidakDitemukan(this.resi);
  @override
  String toString() => 'Resi $resi tidak ditemukan pada basis data.';
}

// === Basis data resi (minimal 5 resi untuk Tugas Praktikum) ===

final Map<String, Map<String, String>> basisDataResi = {
  'SLG-001': {
    'kota': 'Bandung',
    'status': 'Dalam perjalanan menuju gudang transit',
  },
  'SLG-002': {'kota': 'Surabaya', 'status': 'Sedang diproses di gudang sortir'},
  'SLG-003': {'kota': 'Makassar', 'status': 'Telah tiba di kota tujuan'},
  'SLG-004': {'kota': 'Jayapura', 'status': 'Sedang dalam pengantaran kurir'},
  'SLG-005': {'kota': 'Bandung', 'status': 'Telah diterima oleh penerima'},
};

// === Latihan 3: Future, async, dan await ===

Future<String> ambilStatusKiriman(String resi) async {
  // Simulasi jeda jaringan selama dua detik
  await Future.delayed(const Duration(seconds: 2));

  if (!resi.startsWith('SLG-')) {
    throw FormatException('Format resi tidak sah: $resi');
  }

  // Tugas Praktikum: membaca dari Map, bukan hardcode
  final data = basisDataResi[resi];
  if (data == null) {
    throw ResiTidakDitemukan(resi);
  }
  return 'Paket $resi: ${data['status']} (tujuan ${data['kota']}).';
}

Future<double> ambilOngkir(String resi) async {
  await Future.delayed(const Duration(seconds: 1));
  return 105400;
}

// === Latihan 4: Eksekusi Paralel dengan Future.wait ===

Future<void> bandingkanWaktu() async {
  print('\n--- Latihan 4: Future.wait (Paralel) ---');
  final mulai = DateTime.now();

  final hasil = await Future.wait([
    ambilStatusKiriman('SLG-001'),
    ambilOngkir('SLG-001'),
  ]);

  final durasi = DateTime.now().difference(mulai);
  print('Status : ${hasil[0]}');
  print('Ongkir : ${hasil[1]}');
  print('Durasi total: ${durasi.inMilliseconds} ms');
  print('(Lebih cepat karena kedua operasi berjalan bersamaan)');
}

// === Tugas Praktikum: pantauBanyakResi ===

Future<void> pantauBanyakResi(List<String> daftarResi) async {
  print('\n--- Tugas Praktikum: Pantau Banyak Resi ---');
  final List<String> berhasil = [];
  final List<String> gagal = [];

  // Jalankan semua permintaan secara bersamaan
  final futures = daftarResi.map((resi) async {
    try {
      final status = await ambilStatusKiriman(resi);
      return {'resi': resi, 'status': status, 'sukses': 'true'};
    } on FormatException catch (e) {
      return {'resi': resi, 'error': e.message, 'sukses': 'false'};
    } on ResiTidakDitemukan catch (e) {
      return {'resi': resi, 'error': e.toString(), 'sukses': 'false'};
    } catch (e) {
      return {'resi': resi, 'error': e.toString(), 'sukses': 'false'};
    }
  });

  final hasil = await Future.wait(futures);

  for (final h in hasil) {
    if (h['sukses'] == 'true') {
      berhasil.add(h['resi']!);
      print('[OK]    ${h['status']}');
    } else {
      gagal.add(h['resi']!);
      print('[GAGAL] ${h['resi']}: ${h['error']}');
    }
  }

  print('\nRingkasan:');
  print('  Berhasil : ${berhasil.length} resi (${berhasil.join(', ')})');
  print(
    '  Gagal    : ${gagal.length} resi (${gagal.isNotEmpty ? gagal.join(', ') : '-'})',
  );
}

// === main() ===

Future<void> main() async {
  // --- Latihan 3: Pemanggilan berurutan ---
  print('--- Latihan 3: async/await (Berurutan) ---');
  print('1. Permintaan data dikirim...');
  final mulaiSequential = DateTime.now();

  try {
    final status = await ambilStatusKiriman('SLG-002');
    print('2. $status');

    final ongkir = await ambilOngkir('SLG-002');
    print('3. Ongkos kirim: Rp${ongkir.toStringAsFixed(0)}');
  } on FormatException catch (e) {
    print('Kesalahan format: ${e.message}');
  } catch (e) {
    print('Gagal mengambil data: $e');
  }

  final durasiSequential = DateTime.now().difference(mulaiSequential);
  print('4. Proses selesai. (Durasi: ${durasiSequential.inMilliseconds} ms)');

  // --- Latihan 4: Eksekusi paralel ---
  await bandingkanWaktu();

  // --- Tugas Praktikum ---
  // Skenario 1: Seluruh resi sah
  print('\n==============================');
  print('Skenario 1: Seluruh resi SAH');
  print('==============================');
  await pantauBanyakResi([
    'SLG-001',
    'SLG-002',
    'SLG-003',
    'SLG-004',
    'SLG-005',
  ]);

  // Skenario 2: Terdapat resi tidak sah
  print('\n===================================');
  print('Skenario 2: Terdapat resi TIDAK SAH');
  print('===================================');
  await pantauBanyakResi([
    'SLG-001',
    'SLG-002',
    'XYZ-999', // format salah
    'SLG-888', // tidak ditemukan
    'SLG-005',
  ]);
}
