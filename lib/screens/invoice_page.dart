import 'package:flutter/material.dart';
import 'package:frontend/models/tagihan_model.dart';
import 'package:frontend/utils/config.dart';
import 'package:intl/intl.dart';
import 'package:movie_ticket_card/movie_ticket_card.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:lottie/lottie.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  late Tagihan tagihan;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context) != null) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      tagihan = args['tagihan'] as Tagihan;
    }
  }

  @override
  Widget build(BuildContext context) {
    String currency(dynamic value) {
      final NumberFormat currencyFormat = NumberFormat.currency(
          locale: 'id-ID', symbol: 'IDR ', decimalDigits: 1);
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
            lineFromTop: 320,
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
                      'Pembayaran Berhasil!',
                      style: TextStyle(
                          fontSize: 18,
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
                          color: Colors.grey,
                          dashPattern: const [8, 10],
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
                                    "Booking Number",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "ua",
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
                                    "Hotel",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "la",
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
                                    "Rooms",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "la",
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
                                    'Check-in Date ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'su',
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
                                    'Check-out Date ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "la",
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
                            dashPattern: const [8, 10],
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
                                      "Amount",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "lahh",
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
                              onPressed: () async {},
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
}
