import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kalkulator_sains/databases/db_service.dart';
import 'package:kalkulator_sains/logics/logic.dart';
import 'package:kalkulator_sains/utils/service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final voltC = TextEditingController();
  final ampC = TextEditingController();
  final jumlahC = TextEditingController();
  final wattC = TextEditingController();
  final waktuC = TextEditingController();
  final tarifC = TextEditingController();

  double hasil = 0;
  double kwh = 0;
  bool isWatt = true;
  String? selectedTarif;
  List<Logic> history = [];
  final Map<String, double> tarifPLN = {
    "R-1 / 900 VA (Subsidi)": 605,
    "R-1 / 1300 VA": 1444.7,
    "R-1 / 2200 VA": 1444.7,
    "R-2 / 3500-5500 VA": 1699.53,
    "R-3 / >6600 VA": 1699.53,
  };

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void isWattOrVoltAmpere() {
    setState(() {
      isWatt = !isWatt;
    });
  }

  void loadData() async {
    final data = await DbService.getAll();
    setState(() {
      history = data;
    });
  }

  void hitungWatt() async {
    double jumlah = double.tryParse(jumlahC.text) ?? 0;
    double waktu = double.tryParse(waktuC.text) ?? 0;
    double tarif = double.tryParse(tarifC.text) ?? 0;
    double volt = double.tryParse(voltC.text) ?? 0;
    double ampere = double.tryParse(ampC.text) ?? 0;

    double hasilWatt = volt * ampere;

    if (voltC.text.isEmpty ||
        ampC.text.isEmpty ||
        waktuC.text.isEmpty ||
        tarifC.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Isi semua data dulu")));
      return;
    }

    if (selectedTarif == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Pilih tarif PLN dulu")));
      return;
    }

    final data = Service.buatData(
      jumlah: jumlah,
      watt: hasilWatt,
      waktu: waktu,
      tarif: tarif,
    );

    await DbService.insert(data);

    setState(() {
      hasil = data.hasil;
      kwh = data.kwh;
    });

    loadData();
  }

  void hitung() async {
    double jumlah = double.tryParse(jumlahC.text) ?? 0;
    double watt = double.tryParse(wattC.text) ?? 0;
    double waktu = double.tryParse(waktuC.text) ?? 0;
    double tarif = double.tryParse(tarifC.text) ?? 0;

    if (wattC.text.isEmpty || waktuC.text.isEmpty || tarifC.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Isi semua data dulu")));
      return;
    }

    if (selectedTarif == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Pilih tarif PLN dulu")));
      return;
    }

    final data = Service.buatData(
      jumlah: jumlah,
      watt: watt,
      waktu: waktu,
      tarif: tarif,
    );

    await DbService.insert(data);

    setState(() {
      hasil = data.hasil;
      kwh = data.kwh;
    });

    loadData();
  }

  String rupiah(double angka) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(angka);
  }

  Widget input(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF0f3460),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1a1a2e),
      appBar: AppBar(
        backgroundColor: Color(0xFF1a1a2e),
        title: Text(
          "Kalkulator Listrik",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF16213e),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    isWatt ? "Mode: Watt" : "Mode: Volt & Ampere",
                    style: TextStyle(color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: isWattOrVoltAmpere,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4e54c8),
                    ),
                    child: Text(
                      isWatt ? 'Ganti ke Volt/Ampere' : 'Ganti ke Watt',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  input(jumlahC, "Jumlah Perangkat"),
                  if (isWatt) input(wattC, "Daya(Watt)"),
                  if (!isWatt) input(voltC, "Volt"),
                  if (!isWatt) input(ampC, "Ampere"),
                  input(waktuC, "Waktu penggunaan(per jam)"),
                  DropdownButtonFormField<String>(
                    value: selectedTarif,
                    dropdownColor: Color(0xFF0f3460),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Tarif PLN",
                      labelStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Color(0xFF0f3460),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: tarifPLN.keys.map((key) {
                      return DropdownMenuItem(value: key, child: Text(key));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTarif = value;
                        tarifC.text = tarifPLN[value]
                            .toString(); // isi otomatis
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (isWatt) {
                        hitung();
                      } else {
                        hitungWatt();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4e54c8),
                    ),
                    child: Text(
                      "Hitung",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              rupiah(hasil),
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            Text(
              "Pemakaian: ${kwh.toStringAsFixed(2)} kWh",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("History", style: TextStyle(color: Colors.white)),
                TextButton(
                  onPressed: () async {
                    await DbService.clear();
                    loadData();
                  },
                  child: Text("Clear", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: history.length,
              itemBuilder: (_, i) {
                final item = history[i];
                return ListTile(
                  title: Text(
                    rupiah(hasil),
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "${item.jumlah} | ${item.watt}W | ${item.waktu} jam\n"
                    "${item.kwh.toStringAsFixed(2)} kWh",
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await DbService.delete(item.id!);
                      loadData();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
