import 'package:flutter/material.dart';
import 'package:kalkulator_sains/databases/db_service.dart';
import 'package:kalkulator_sains/logics/logic.dart';
import 'package:kalkulator_sains/utils/service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final jumlahC = TextEditingController();
  final wattC = TextEditingController();
  final waktuC = TextEditingController();
  final tarifC = TextEditingController();

  double hasil = 0;
  double kwh = 0;
  List<Logic> history = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    final data = await DbService.getAll();
    setState(() {
      history = data;
    });
  }

  void hitung() async {
    double jumlah = double.tryParse(jumlahC.text) ?? 0;
    double watt = double.tryParse(wattC.text) ?? 0;
    double waktu = double.tryParse(waktuC.text) ?? 0;
    double tarif = double.tryParse(tarifC.text) ?? 0;

    final data = Service.buatData(
      jumlah: jumlah,
      watt: watt,
      waktu: waktu,
      tarif: tarif,
    );

    await DbService.insert(data);

    setState(() => hasil = data.hasil);

    loadData();
  }

  Widget input(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Color(0xFF0f3460),
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
        title: Text("Kalkulator Listrik"),
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
                  input(jumlahC, "Jumlah"),
                  input(wattC, "Watt"),
                  input(waktuC, "Jam"),
                  input(tarifC, "Tarif"),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        hitung();
                      });
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
              "Rp ${hasil.toStringAsFixed(0)}",
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
                    "Rp ${item.hasil.toStringAsFixed(0)}",
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
