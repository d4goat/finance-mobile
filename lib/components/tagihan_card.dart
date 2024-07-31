import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kos_mcflyon/components/styled_text.dart';
import 'package:kos_mcflyon/models/tagihan_model.dart';
import 'package:kos_mcflyon/utils/config.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class TagihanLunasCard extends StatelessWidget {
  const TagihanLunasCard({super.key, required this.tagihan});

  final Tagihan tagihan;

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    String currency(dynamic value) {
      final NumberFormat currency =
          NumberFormat.currency(locale: 'id-ID', symbol: 'Rp');
      String formattedCurrency = currency.format(value);
      formattedCurrency = formattedCurrency.replaceAll('.', ',');
      return formattedCurrency;
    }

    return Container(
      width: Config.screenWidth,
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 120,
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(13)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 2))
            ],
            // color: HexColor('#66bb6a'),

            ///ANOTHER COLOR
            ///
            color: HexColor('#000'),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SuperTitleText('Tagihan Bulanan'),
                      TitleTextBold("${currency(tagihan.totalTagihan)}"),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: const Icon(
                    FontAwesomeIcons.circleCheck,
                    // color: Colors.white,

                    ///ANOTHER COLOR
                    ///
                    color: Colors.green,
                    size: 60,
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamed('invoice', arguments: {'tagihan': tagihan});
        },
      ),
    );
  }
}

class TagihanBelumLunasCard extends StatelessWidget {
  const TagihanBelumLunasCard({super.key, required this.tagihan});

  final Tagihan tagihan;

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    String currency(dynamic value) {
      final NumberFormat currency =
          NumberFormat.currency(locale: 'id-ID', symbol: 'Rp');
      String formattedCurrency = currency.format(value);
      formattedCurrency = formattedCurrency.replaceAll('.', ',');
      return formattedCurrency;
    }

    Future<void> _showAnnounceBillDialog() async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Kirim bukti bayar"),
              content: const SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: ListBody(
                  children: [
                    Text("Apakah anda ingin mengirimkan bukti pembayaran?")
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Tidak")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('bukti_pembayaran',
                          arguments: {'tagihan': tagihan});
                    },
                    child: const Text("Ya"))
              ],
            );
          });
    }

    return Container(
      width: Config.screenWidth,
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 120,
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(13)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 2))
            ],
            // color: HexColor('#ee6056'),

            ///ANOTHER COLOR
            ///
            color: HexColor('#000'),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SuperTitleText('Tagihan Bulanan'),
                      TitleTextBold("${currency(tagihan.totalTagihan)}"),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: const Icon(
                    FontAwesomeIcons.circleXmark,
                    // color: Colors.white,

                    ///ANOTHER COLOR
                    ///
                    color: Colors.red,
                    size: 60,
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          _showAnnounceBillDialog();
        },
      ),
    );
  }
}

class TagihanPendingCard extends StatelessWidget {
  const TagihanPendingCard({super.key, required this.tagihan});

  final Tagihan tagihan;

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    String currency(dynamic value) {
      final NumberFormat currency =
          NumberFormat.currency(locale: 'id-ID', symbol: 'Rp');
      String formattedCurrency = currency.format(value);
      formattedCurrency = formattedCurrency.replaceAll('.', ',');
      return formattedCurrency;
    }

    Future<void> _showPendingBill() async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Pending Bill"),
              content: const SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: ListBody(
                  children: [
                    Text("Pembayaran anda sedang dikonfirmasi oleh admin")
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Tutup"))
              ],
            );
          });
    }

    return Container(
      width: Config.screenWidth,
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 120,
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(13)),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 2))
              ],
              // color: HexColor('#ffeb3b')),

              ///ANOTHER COLOR
              ///
              color: HexColor('#000')),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SuperTitleText('Tagihan Bulanan'),
                      TitleTextBold("${currency(tagihan.totalTagihan)}"),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: const Icon(
                    FontAwesomeIcons.triangleExclamation,
                    // color: Colors.white,

                    ///ANOTHER COLOR
                    ///
                    color: Colors.amber,
                    size: 60,
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          _showPendingBill();
        },
      ),
    );
  }
}
