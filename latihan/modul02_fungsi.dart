double beratVolumetrik(double p, double l, double t, {double faktor = 6000}) =>
    (p * l * t) / faktor;

double beratTertagih({required double aktual, required double volumetrik}) =>
    aktual > volumetrik ? aktual : volumetrik;

double hitungOngkir({
  required double berat,
  required double tarifPerKg,
  bool asuransi = false,
  double persenAsuransi = 0.005,
  double nilaiBarang = 0,
}) {
  double biaya = berat * tarifPerKg;
  if (asuransi) {
    biaya += nilaiBarang * persenAsuransi;
  }
  return biaya;
}

String rupiah(double nilai) => 'Rp${nilai.toStringAsFixed(0)}';

// Fungsi baru: estimasi hari sampai berdasarkan kota tujuan (langkah 3)
int estimasiHariSampai(String kota) {
  switch (kota) {
    case 'Bandung':
      return 1;
    case 'Surabaya':
      return 2;
    case 'Makassar':
      return 3;
    case 'Jayapura':
      return 5;
    default:
      return 7;
  }
}

void main() {
  final volumetrik = beratVolumetrik(45, 30, 25);
  final tertagih = beratTertagih(aktual: 12.4, volumetrik: volumetrik);

  // Ongkir dengan asuransi = false (langkah 2)
  final ongkirTanpaAsuransi = hitungOngkir(
    berat: tertagih,
    tarifPerKg: 8500,
    asuransi: false,
    nilaiBarang: 2500000,
  );

  // Ongkir dengan asuransi = true
  final ongkirDenganAsuransi = hitungOngkir(
    berat: tertagih,
    tarifPerKg: 8500,
    asuransi: true,
    nilaiBarang: 2500000,
  );

  print('Berat tertagih         : ${tertagih.toStringAsFixed(2)} kg');
  print('Ongkir tanpa asuransi  : ${rupiah(ongkirTanpaAsuransi)}');
  print('Ongkir dengan asuransi : ${rupiah(ongkirDenganAsuransi)}');
  print(
    'Selisih biaya          : ${rupiah(ongkirDenganAsuransi - ongkirTanpaAsuransi)}',
  );

  // Demonstrasi fungsi estimasiHariSampai (langkah 3)
  print('\n--- Estimasi Hari Sampai ---');
  for (final kota in ['Bandung', 'Surabaya', 'Makassar', 'Jayapura']) {
    print('$kota : ${estimasiHariSampai(kota)} hari');
  }
}
