import 'package:flutter/material.dart';
import 'package:kos_mcflyon/components/tagihan_card.dart';
import 'package:kos_mcflyon/models/kos_model.dart';
import 'package:kos_mcflyon/models/tagihan_model.dart';
import 'package:kos_mcflyon/provider/dio_provider.dart';
import 'package:kos_mcflyon/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: Text("Kamar No ${kos?.nomor ?? 'Alias'}"),
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
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomScrollView(
                  slivers: [
                    tagihanList.isEmpty
                        ? SliverToBoxAdapter(
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 350,
                                  child: ClipRRect(
                                    child: Image.asset('assets/illust10.png'),
                                  ),
                                ),
                                Config.spaceSmall,
                                const Text(
                                  "Tidak ada tagihan yang tersedia",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              ],
                            ),
                          )
                        : SliverToBoxAdapter(
                            child: Column(
                            children: [
                              Config.spaceSmall,
                              const Text(
                                "Terdapat tagihan yang belum dibayar nih. Bayar Yuk!",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 10),
                              ...tagihanList.map((tagihan) {
                                if (tagihan.fotoBuktiPembayaran == null) {
                                  return TagihanBelumLunasCard(
                                      tagihan: tagihan);
                                }
                                return const SizedBox.shrink();
                              }).toList()
                            ],
                          )),
                  ],
                ),
              ),
            ),
    );
  }
}
