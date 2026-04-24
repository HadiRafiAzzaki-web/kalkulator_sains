class Logic {
  int? id;
  double jumlah;
  double watt;
  double waktu;
  double tarif;
  double hasil;
  double kwh;

  Logic({
    this.id,
    required this.jumlah,
    required this.watt,
    required this.waktu,
    required this.tarif,
    required this.hasil,
    required this.kwh,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jumlah': jumlah,
      'watt': watt,
      'waktu': waktu,
      'tarif': tarif,
      'hasil': hasil,
      'kwh': kwh,
    };
  }

  factory Logic.fromMap(Map<String, dynamic> map) {
    return Logic(
      id: map['id'],
      jumlah: map['jumlah'],
      watt: map['watt'],
      waktu: map['waktu'],
      tarif: map['tarif'],
      hasil: map['hasil'],
      kwh: map['kwh'],
    );
  }
}
