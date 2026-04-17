import 'package:kalkulator_sains/logics/logic.dart';

class Service {
  //logika perhitungan
  static double hitung({
    required double watt,
    required int jumlah,
    required double tarif,
    required double waktu,
  }) {
    double kWH = (jumlah * watt * waktu) / 1000;
    return kWH * tarif;
  }

  //nyimpan histori
  static Logic buatData({
    required double watt,
    required int jumlah,
    required double tarif,
    required double waktu,
  }) {
    double hasil = hitung(
      watt: watt,
      jumlah: jumlah,
      tarif: tarif,
      waktu: watt,
    );
    return Logic(
      jumlah: jumlah,
      tarif: tarif,
      watt: watt,
      waktu: waktu,
      hasil: hasil,
    );
  }
}
