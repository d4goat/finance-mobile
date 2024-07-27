import 'package:flutter/material.dart';
import 'package:frontend/components/styled_text.dart';
import 'package:frontend/components/tagihan_card.dart';
import 'package:frontend/models/kos_model.dart';
import 'package:frontend/models/penghuni_model.dart';
import 'package:frontend/models/tagihan_model.dart';
import 'package:frontend/provider/dio_provider.dart';
import 'package:frontend/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Penghuni? penghuni;
  Kos? kos;
  String uuid = '';
  String nomor = '';
  List<Tagihan> tagihanLunas = [];
  List<Tagihan> tagihanBelumLunas = [];
  List<Tagihan> tagihanPending = []; // Separate list for pending confirmation

  @override
  void initState() {
    super.initState();
    fetchKos();
    fetchTagihan();
  }

  Future<void> fetchKos() async {
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

  Future<void> fetchTagihan() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      nomor = prefs.getString('nomor') ?? '';

      final List<Tagihan> responseLunas =
          await DioProvider().getTagihanLunas(nomor);
      final List<Tagihan> responseBelumLunas =
          await DioProvider().getTagihanBelumLunas(nomor);

      if (responseLunas.isNotEmpty) {
        setState(() {
          tagihanLunas = responseLunas;
        });
      } else {
        Config.logger.w('No data received from API');
      }

      if (responseBelumLunas.isNotEmpty) {
        setState(() {
          tagihanBelumLunas = responseBelumLunas
              .where((tagihan) => tagihan.fotoBuktiPembayaran == null)
              .toList();
          tagihanPending = responseBelumLunas
              .where((tagihan) => tagihan.fotoBuktiPembayaran != null)
              .toList();
        });
      } else {
        Config.logger.w("No data received");
      }
    } catch (error) {
      Config.logger.e("Error fetching tagihan : $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      appBar: AppBar(
        title: UltraSuperTitleText(
            "${penghuni?.nama?.split(' ').first ?? 'Guest'}"),
        backgroundColor: Config.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Personal Information Section
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: Config.screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        'Informasi Pribadi',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Nama:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${penghuni?.nama ?? 'No name'}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Nomor Telepon:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${penghuni?.telepon ?? 'No phone number'}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Nomor Kamar:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${kos?.nomor ?? 'No room number'}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Config.spaceSmall,
            ),
            // Unpaid Bills Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  "Tagihan Belum Lunas",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Config.spaceSmall,
            ),
            tagihanBelumLunas.isEmpty
                ? SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: const Text(
                        'No unpaid bills available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return TagihanBelumLunasCard(
                            tagihan: tagihanBelumLunas[index]);
                      },
                      childCount: tagihanBelumLunas.length,
                    ),
                  ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
            // Pending Confirmation Bills Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  "Tagihan Menunggu Konfirmasi",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Config.spaceSmall,
            ),
            tagihanPending.isEmpty
                ? SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: const Text(
                        'No pending confirmations available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return TagihanPendingCard(
                            tagihan: tagihanPending[index]);
                      },
                      childCount: tagihanPending.length,
                    ),
                  ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
            // Paid Bills Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  'Tagihan Lunas',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Config.spaceSmall,
            ),
            tagihanLunas.isEmpty
                ? SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: const Text(
                        'No paid bills available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return TagihanLunasCard(tagihan: tagihanLunas[index]);
                      },
                      childCount: tagihanLunas.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
