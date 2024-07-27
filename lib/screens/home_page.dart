import 'package:flutter/material.dart';
import 'package:frontend/components/tagihan_card.dart';
import 'package:frontend/models/kos_model.dart';
import 'package:frontend/models/penghuni_model.dart';
import 'package:frontend/models/tagihan_model.dart';
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
  String nomor = '';
  List<Tagihan> tagihanList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKosData();
    fetchTagihan();
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
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchTagihan() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      nomor = prefs.getString('nomor') ?? '';
      final List<Tagihan> response =
          await DioProvider().getTagihanBelumLunas(nomor);

      if (response != null && response.isNotEmpty) {
        setState(() {
          tagihanList = response;
        });
      } else {
        Config.logger.w('No data received from API');
      }
    } catch (e) {
      Config.logger.e('Error fetching tagihan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Kamar No : ${kos?.nomor}"),
        backgroundColor: Config.primaryColor,
        titleTextStyle: const TextStyle(
          fontSize: 20,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: CustomScrollView(
                slivers: [
                  tagihanList.isEmpty
                      ? SliverToBoxAdapter(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 350,
                                child: ClipRRect(
                                  child: Image.asset('assets/illust2.png'),
                                ),
                              ),
                              Config.spaceSmall,
                              const Text(
                                "Tidak ada tagihan yang tersedia",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                        )
                      : const SliverToBoxAdapter(child: Config.spaceSmall),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (tagihanList[index].fotoBuktiPembayaran != null)
                          return TagihanBelumLunasCard(
                              tagihan: tagihanList[index]);
                        else
                          return TagihanPendingCard(
                              tagihan: tagihanList[index]);
                      },
                      childCount: tagihanList.length,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
