import 'package:kalkulator_sains/logics/logic.dart';

class Service {
  static double hitung({
    required double jumlah,
    required double watt,
    required double waktu,
    required double tarif,
  }) {
    return (jumlah * watt * waktu / 1000) * tarif;
  }

  static double hitungKwh({
    required double jumlah,
    required double watt,
    required double waktu,
  }) {
    return (jumlah * watt * waktu) / 1000;
  }

  static Logic buatData({
    required double jumlah,
    required double watt,
    required double waktu,
    required double tarif,
  }) {
    double kwh = hitungKwh(jumlah: jumlah, watt: watt, waktu: waktu);

    return Logic(
      jumlah: jumlah,
      watt: watt,
      waktu: waktu,
      tarif: tarif,
      hasil: kwh * tarif,
      kwh: kwh,
    );
  }
}
