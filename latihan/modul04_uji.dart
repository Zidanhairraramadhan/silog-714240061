import '../lib/model/barang.dart';
import '../lib/model/gudang.dart';
import '../lib/model/pelanggan.dart';
import '../lib/model/pengiriman.dart';

void main() {
  final sepatu = Barang(
    kode: 'B-1024',
    nama: 'Sepatu Lari Pria',
    hargaSatuan: 450000,
    beratKg: 0.9,
  );
  final kaos = Barang.dariPemindaian('B-2048;Kaos Katun;85000');

  final gudangBandung = Gudang(
    kode: 'GD-BDG',
    nama: 'Gudang Utama Bandung',
    kota: 'Bandung',
    kapasitas: 500,
  );

  gudangBandung.terimaBarang(sepatu, 120);
  gudangBandung.terimaBarang(kaos, 300);
  print(gudangBandung);
  print('Rincian stok: ${gudangBandung.stok}');

  final kirim = Pengiriman.baru(
    resi: 'SLG-2026-0007',
    asal: gudangBandung,
    kotaTujuan: 'Surabaya',
    barang: sepatu,
    jumlah: 10,
  );

  gudangBandung.keluarkanBarang(sepatu, kirim.jumlah);
  print(kirim);
  print('Nilai barang: Rp${kirim.nilaiBarang.toStringAsFixed(0)}');

  kirim.ubahStatus('Dalam Perjalanan');
  print('Status terbaru: ${kirim.status}');

  try {
    kirim.ubahStatus('Draft');
  } on StateError catch (e) {
    print('Ditolak: ${e.message}');
  }

  try {
    gudangBandung.keluarkanBarang(sepatu, 9999);
  } on StateError catch (e) {
    print('Ditolak: ${e.message}');
  }

  // --- Pengujian Tugas Praktikum: Kelas Pelanggan ---
  print('\n--- Pengujian Tugas Praktikum (Kelas Pelanggan) ---');
  final pelanggan1 = Pelanggan(
    kode: 'PLG-001',
    nama: 'Budi Santoso',
    nomorTelepon: '081234567890',
    alamat:
        'Jl. Surya Sumantri No. 103, Sukajadi, Kota Bandung, Jawa Barat 40164',
  );

  print('Data Pelanggan : $pelanggan1');
  print('Alamat Lengkap : ${pelanggan1.alamat}');
  print('Alamat Ringkas : ${pelanggan1.alamatRingkas()}');

  final kirimDenganPelanggan = Pengiriman.baru(
    resi: 'SLG-2026-0008',
    asal: gudangBandung,
    kotaTujuan: 'Bandung',
    barang: kaos,
    jumlah: 5,
    pelanggan: pelanggan1,
  );

  print('\nPengiriman dengan data pelanggan:');
  print(kirimDenganPelanggan);
}
