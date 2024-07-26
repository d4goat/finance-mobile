import 'package:flutter/material.dart';
import 'package:frontend/models/kos_model.dart';
import 'package:frontend/models/penghuni_model.dart';
import 'package:frontend/models/tagihan_model.dart';
import 'package:frontend/provider/dio_provider.dart';
import 'package:frontend/utils/config.dart';
import 'package:intl/intl.dart';
import 'package:movie_ticket_card/movie_ticket_card.dart';
import 'package:dotted_border/dotted_border.dart';
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
      if (response != null) {
        setState(() {
          kos = response;
          penghuni = kos?.penghuni;
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
    String currency(dynamic value) {
      final NumberFormat currencyFormat = NumberFormat.currency(
          locale: 'id-ID', symbol: 'Rp', decimalDigits: 1);
      String formattedValue = currencyFormat.format(value);
      formattedValue = formattedValue.replaceAll('.', ',');
      return formattedValue;
    }

    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.indigo[800]!,
          Colors.blue[700]!,
          Colors.lightBlue[700]!,
          Colors.cyan[700]!,
          Colors.cyan[200]!,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.fromLTRB(15, 15, 13, 20),
          child: TicketCard(
            decoration: TicketDecoration(
                border: TicketBorder(
                    color: const Color.fromARGB(0, 0, 0, 0),
                    width: 0.1,
                    style: TicketBorderStyle.none)),
            lineFromTop: 300,
            lineRadius: 12,
            child: Card(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Config.spaceBig,
                  Expanded(
                      flex: 2,
                      child:
                          Lottie.asset('assets/success.json', repeat: false)),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      'Upload Success!',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${currency(tagihan.totalTagihan)}',
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Config.spaceSmall,
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        DottedBorder(
                          color: Colors.black,
                          dashPattern: const [3, 7],
                          customPath: (size) {
                            return Path()
                              ..moveTo(0, size.height)
                              ..lineTo(size.width, size.height);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Config.spaceSmall,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Nomor Kamar",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "${kos?.nomor}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Nama Penghuni",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    // Tampilkan hanya kata pertama dari penghuni.nama
                                    penghuni!.nama?.split(' ').first ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Tanggal Mulai Kost ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '${tagihan.tanggalMulai}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Tanggal Selesai Kost ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "${tagihan.tanggalSelesai}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Meteran Air ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "${tagihan.meteranAir}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Meteran Listrik ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "${tagihan.meteranListrik}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Config.spaceSmall,
                            ],
                          ),
                        ),
                        DottedBorder(
                            dashPattern: const [3, 7],
                            customPath: (size) {
                              return Path()
                                ..moveTo(0, size.height)
                                ..lineTo(size.width, size.height);
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 20),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total Tagihan",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "${currency(tagihan.totalTagihan)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    )
                                  ]),
                            ))
                      ],
                    ),
                  ),
                  Config.spaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 45,
                          width: Config.widthSize * 0.75,
                          child: ElevatedButton(
                              onPressed: () async {
                                await _printAsPdf();
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                          color: Colors.black38)),
                                  backgroundColor: Colors.grey[50],
                                  foregroundColor: Colors.black),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.file_download_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Print as PDF"),
                                ],
                              )))
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 25),
                    child: SizedBox(
                        width: Config.widthSize * 0.65,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('main');
                          },
                          child: const Text(
                            "Back to Home Page",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      )),
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

      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw
            .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text("Invoice Tagihan",
              style:
                  pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 35),
          pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: const <int, pw.TableColumnWidth>{
                0: pw.IntrinsicColumnWidth(),
                1: pw.IntrinsicColumnWidth(),
              },
              children: [
                pw.TableRow(children: [
                  pw.Container(
                      color: PdfColor.fromHex("#464545"),
                      child: pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text("Information",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex('#fff'))))),
                  pw.Container(
                      color: PdfColor.fromHex("#464545"),
                      child: pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: pw.Text("Detail",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex('#fff'))))),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: pw.Text("Nomor Kamar",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: pw.Text("${kos?.nomor}",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: pw.Text("Nama Penghuni",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: pw.Text("${penghuni?.nama}",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: pw.Text("Tanggal Mulai Kost",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: pw.Text("${tagihan.tanggalMulai}",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: pw.Text("Tanggal Selesai Kost",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: pw.Text("${tagihan.tanggalSelesai}",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: pw.Text("Meteran Air",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: pw.Text("${tagihan.meteranAir}",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: pw.Text("Meteran Listrik",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: pw.Text("${tagihan.meteranListrik}",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: pw.Text("Biaya Tagihan",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: pw.Text("${currency(tagihan.totalTagihan)}",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                ]),
              ])
        ]);
      }));
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (error) {
      Config.logger.e('Error generating PDF : $error');
    }
  }
}
