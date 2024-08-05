import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:kos_mcflyon/models/kos_model.dart';
import 'package:kos_mcflyon/models/penghuni_model.dart';
import 'package:kos_mcflyon/models/tagihan_model.dart';
import 'package:kos_mcflyon/provider/dio_provider.dart';
import 'package:kos_mcflyon/utils/config.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  late Tagihan tagihan;
  Kos? kos;
  Penghuni? penghuni;
  String uuid = '';
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context) != null) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      tagihan = args['tagihan'] as Tagihan;
    }
  }

  Future<void> fetchKosData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    uuid = prefs.getString('uuid_kos') ?? '';

    if (uuid.isNotEmpty) {
      final Kos? response = await DioProvider().getKos(uuid);
      final Penghuni? res = await DioProvider().getPenghuniDetail(uuid);
      if (response != null) {
        setState(() {
          kos = response;
          penghuni = res;
          isLoading = false;
        });
      }
    }
  }

  void initState() {
    super.initState();
    fetchKosData();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    String currency(dynamic value) {
      final NumberFormat currencyFormat = NumberFormat.currency(
          locale: 'id-ID', symbol: 'Rp', decimalDigits: 1);
      String formattedValue = currencyFormat.format(value);
      formattedValue = formattedValue.replaceAll('.', ',');
      return formattedValue;
    }

    return Scaffold(
      body: isLoading
          ? const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    "Memuat, harap tunggu...",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                ],
              ),
            )
          : SafeArea(
              child: Container(
                width: Config.screenWidth,
                height: Config.screenHeight,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 350,
                      decoration: BoxDecoration(
                          color: Colors.teal[900],
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Config.spaceMedium,
                          Container(
                            height: 150,
                            child: Lottie.asset(
                              'assets/success.json',
                              repeat: false,
                            ),
                          ),
                          const Text(
                            'Upload Success!',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 320, // Adjust this value to control the overlap
                      left: 10,
                      right: 10,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 0.8, color: Colors.black45),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Nomor Kamar",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  "${kos?.nomor}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 13),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Nama Penghuni",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  penghuni!.nama?.split(' ').first ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 13),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Tanggal Mulai Kost",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  "${tagihan.tanggalMulai}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 13),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Tanggal Selesai Kos",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  "${tagihan.tanggalSelesai}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 13),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Meteran Air",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  "${tagihan.meteranAir}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 13),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Meteran Listrik",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  "${tagihan.meteranListrik}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 13),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Biaya Mobil",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  "${tagihan.biayaMobil}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 13),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Biaya Kebersihan",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  "${tagihan.biayaKebersihan}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Config.spaceSmall,
                            DottedBorder(
                              color: Colors.black,
                              strokeWidth: 0.6,
                              dashPattern: const [8, 6],
                              customPath: (size) {
                                return Path()
                                  ..moveTo(0, 0)
                                  ..lineTo(size.width, 0)
                                  ..moveTo(0, size.height)
                                  ..lineTo(size.width, size.height);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Amount',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '${currency(tagihan.totalTagihan)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 13),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${currency(tagihan.totalTagihan)}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Config.spaceMedium,
                            SizedBox(
                              height: 45,
                              width: Config.widthSize * 0.75,
                              child: ElevatedButton(
                                  onPressed: () async => await _printAsPdf,
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: const BorderSide(
                                              color: Colors.black)),
                                      backgroundColor: Colors.grey[50],
                                      foregroundColor: Colors.black),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.file_download_outlined),
                                      SizedBox(width: 10),
                                      Text('Print as PDF')
                                    ],
                                  )),
                            ),
                            Config.spaceSmall,
                            Container(
                              child: SizedBox(
                                width: Config.widthSize * 0.65,
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed('main');
                                    },
                                    child: const Text(
                                      "Back To Home Page",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _printAsPdf() async {
    try {
      final pdf = pw.Document();

      String currency(dynamic value) {
        final NumberFormat currencyFormat = NumberFormat.currency(
            locale: 'id-ID', symbol: 'Rp', decimalDigits: 1);
        String formattedValue = currencyFormat.format(value);
        formattedValue = formattedValue.replaceAll('.', ',');
        return formattedValue;
      }

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Invoice Tagihan",
                  style: pw.TextStyle(
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 35),
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: const <int, pw.TableColumnWidth>{
                    0: pw.IntrinsicColumnWidth(),
                    1: pw.IntrinsicColumnWidth(),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                          color: PdfColor.fromHex("#464545"),
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            child: pw.Text(
                              "Information",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#fff'),
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          color: PdfColor.fromHex("#464545"),
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            child: pw.Text(
                              "Detail",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#fff'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text(
                            "Nomor Kamar",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text(
                            "${kos?.nomor}",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text(
                            "Nama Penghuni",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text(
                            "${penghuni?.nama}",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text(
                            "Tanggal Mulai Kost",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text(
                            "${tagihan.tanggalMulai}",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text(
                            "Tanggal Selesai Kost",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text(
                            "${tagihan.tanggalSelesai}",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text(
                            "Meteran Air",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text(
                            "${tagihan.meteranAir}",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text(
                            "Meteran Listrik",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text(
                            "${tagihan.meteranListrik}",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text(
                            "Biaya Tagihan",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text(
                            "${currency(tagihan.totalTagihan)}",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (error) {
      Config.logger.e('Error generating PDF : $error');
    }
  }
}
