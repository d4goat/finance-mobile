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
  List<Tagihan> tagihanPending = [];
  List<Tagihan> filteredTagihan = [];
  String filter = 'Semua';
  bool isLoading = true;

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
          isLoading = false;
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
      final List<Tagihan> responsePending =
          await DioProvider().getTagihanPending(nomor);

      if (responseLunas.isNotEmpty) {
        setState(() {
          tagihanLunas = responseLunas;
        });
      }

      if (responseBelumLunas.isNotEmpty) {
        setState(() {
          tagihanBelumLunas = responseBelumLunas;
          filterTagihan();
        });
      }
      if (responsePending.isNotEmpty) {
        setState(() {
          tagihanPending = responsePending;
          filterTagihan();
        });
      }
    } catch (error) {
      Config.logger.e("Error fetching tagihan : $error");
    }
  }

  void filterTagihan() {
    List<Tagihan> allTagihan = []
      ..addAll(tagihanLunas)
      ..addAll(tagihanBelumLunas)
      ..addAll(tagihanPending);

    setState(() {
      switch (filter) {
        case 'Belum Lunas':
          filteredTagihan = tagihanBelumLunas;
          break;
        case 'Menunggu Konfirmasi':
          filteredTagihan = tagihanPending;
          break;
        case 'Lunas':
          filteredTagihan = tagihanLunas;
          break;
        default:
          filteredTagihan = allTagihan;
          break;
      }
    });
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: Config.screenWidth,
                child: CustomScrollView(
                  slivers: [
                    // Personal Information Section
                    SliverToBoxAdapter(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: const Text(
                                'Informasi Pribadi',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                            ),
                            Config.spaceSmall,
                            Card(
                              elevation: 8,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Nama:',
                                          style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${penghuni?.nama ?? 'No name'}",
                                          style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Nomor Telepon:',
                                          style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${penghuni?.telepon ?? 'No phone number'}",
                                          style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Nomor Kamar:',
                                          style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${kos?.nomor ?? 'No room number'}",
                                          style: TextStyle(
                                              color: Colors.grey[800],
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
                    // Bills Section
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tagihan ( $filter )",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (String result) {
                                setState(() {
                                  filter = result;
                                  filterTagihan();
                                });
                              },
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem<String>(
                                    value: 'Semua', child: Text('Semua')),
                                const PopupMenuItem<String>(
                                    value: 'Belum Lunas',
                                    child: Text('Belum Lunas')),
                                const PopupMenuItem<String>(
                                    value: 'Menunggu Konfirmasi',
                                    child: Text('Menunggu Konfirmasi')),
                                const PopupMenuItem<String>(
                                    value: 'Lunas', child: Text('Lunas')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Config.spaceSmall,
                    ),
                    filteredTagihan.isEmpty
                        ? SliverToBoxAdapter(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              alignment: Alignment.center,
                              child: const Text(
                                'No bills available',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final tagihan = filteredTagihan[index];
                                if (tagihan.statusBayar == 0 &&
                                    tagihan.fotoBuktiPembayaran == null) {
                                  return TagihanBelumLunasCard(
                                      tagihan: tagihan);
                                } else if (tagihan.statusBayar == 0 &&
                                    tagihan.fotoBuktiPembayaran != null) {
                                  return TagihanPendingCard(tagihan: tagihan);
                                } else if (tagihan.statusBayar == 1) {
                                  return TagihanLunasCard(tagihan: tagihan);
                                }
                              },
                              childCount: filteredTagihan.length,
                            ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
