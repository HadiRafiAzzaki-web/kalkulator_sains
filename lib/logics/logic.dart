class Logic {
  final int? id;
  final double jumlah;
  final double watt;
  final double waktu;
  final double tarif;
  final double hasil;

  Logic({
    this.id,
    required this.jumlah,
    required this.watt,
    required this.waktu,
    required this.tarif,
    required this.hasil,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jumlah': jumlah,
      'watt': watt,
      'waktu': waktu,
      'tarif': tarif,
      'hasil': hasil,
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
    );
  }
}
