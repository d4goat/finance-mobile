import 'package:flutter/material.dart';
import 'package:frontend/models/kos_model.dart';
import 'package:frontend/models/penghuni_model.dart';
import 'package:frontend/provider/dio_provider.dart';
import 'package:frontend/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Penghuni? penghuni;
  Kos? kos;
  String uuid = '';

  @override
  void initState() {
    super.initState();
    fetchKosData();
  }

  Future<void> fetchKosData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    uuid = prefs.getString('uuid_kos') ?? '';

    if (uuid.isNotEmpty) {
      final Kos? response = await DioProvider().getKos(uuid);
      if (response != null) {
        setState(() {
          kos = response;
          penghuni = kos?.penghuni;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${penghuni?.nama}"),
        backgroundColor: Config.primaryColor,
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 350,
                        child: ClipRRect(
                          child: Image.asset('assets/illust2.png'),
                        ),
                      ),
                      Config.spaceSmall,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 3),
                            ),
                          ],
                          color: Colors.grey[200],
                        ),
                        width: Config.screenWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("data"),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.of(context).pushNamed('invoice');
                                  });
                                },
                                child: Text("butt"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget kosDetailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kos ID: ${kos?.id}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          "UUID: ${kos?.uuid}",
          style: TextStyle(fontSize: 16),
        ),
        Text(
          "Harga: ${kos?.harga}",
          style: TextStyle(fontSize: 16),
        ),
        Text(
          "Keterangan: ${kos?.keterangan}",
          style: TextStyle(fontSize: 16),
        ),
        // Add more details as needed
      ],
    );
  }
}
