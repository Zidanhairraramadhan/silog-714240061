import '../lib/layanan/layanan_pengiriman.dart';
import '../lib/layanan/moda.dart';

void main() {
  final List<LayananPengiriman> daftarLayanan = [
    PengirimanTruk(kodeLayanan: 'TRK-REG', jarakKm: 780, beratKg: 1200),
    PengirimanTruk(
      kodeLayanan: 'TRK-EXP',
      jarakKm: 780,
      beratKg: 1200,
      ekspres: true,
    ),
    PengirimanKeretaApi(
      kodeLayanan: 'KA-CARGO',
      jarakKm: 780,
      beratKg: 1200,
      stasiunAsal: 'Kiaracondong',
      stasiunTujuan: 'Pasar Turi',
    ),
    PengirimanKapal(
      kodeLayanan: 'KPL-PETI',
      jarakKm: 1450,
      beratKg: 1200,
      volumeM3: 8.5,
    ),
    // Latihan E: moda baru PengirimanUdara — tidak ada baris kode lain yang perlu diubah
    PengirimanUdara(
      kodeLayanan: 'UDR-CARGO',
      jarakKm: 1450,
      beratKg: 1200,
      panjangCm: 120,
      lebarCm: 80,
      tinggiCm: 75,
    ),
  ];

  print('=== Perbandingan Layanan Pengiriman ===');
  for (final layanan in daftarLayanan) {
    print(layanan.ringkasan());
  }

  daftarLayanan.sort((a, b) => a.hitungTarif().compareTo(b.hitungTarif()));
  print('\nLayanan termurah : ${daftarLayanan.first.kodeLayanan}');
  print(
    'Layanan tercepat : '
    '${daftarLayanan.reduce((a, b) => a.estimasiHari() <= b.estimasiHari() ? a : b).kodeLayanan}',
  );

  // Pemanfaatan mixin Terlacak
  final truk = daftarLayanan.whereType<PengirimanTruk>().first;
  truk.catatPosisi('Gudang Utama Bandung');
  truk.catatPosisi('Rest Area KM 207');
  truk.catatPosisi('Gudang Transit Semarang');
  print('\nRiwayat posisi ${truk.kodeLayanan}:');
  for (final r in truk.riwayat) {
    print('  $r');
  }
  print('Posisi terakhir: ${truk.posisiTerakhir()}');

  // Tugas Praktikum F.2: Bukti mixin Terasuransi hanya pada Kapal dan Udara
  print('\n=== Pengujian Mixin Terasuransi ===');
  final kapal = daftarLayanan.whereType<PengirimanKapal>().first;
  final udara = daftarLayanan.whereType<PengirimanUdara>().first;

  const nilaiBarang = 50000000.0;
  print(
    'Premi ${kapal.kodeLayanan} : Rp${kapal.hitungPremi(nilaiBarang).toStringAsFixed(0)}',
  );
  print(
    'Premi ${udara.kodeLayanan} : Rp${udara.hitungPremi(nilaiBarang).toStringAsFixed(0)}',
  );

  // Bukti PengirimanTruk TIDAK memiliki metode hitungPremi
  // (baris berikut jika diaktifkan akan menyebabkan compile error):
  // truk.hitungPremi(nilaiBarang); // Error: method not found
  print(
    '\nPengirimanTruk tidak memiliki metode hitungPremi (mixin Terasuransi tidak dipasang).',
  );
}
