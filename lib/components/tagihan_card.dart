import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/styled_text.dart';
import 'package:frontend/models/tagihan_model.dart';
import 'package:frontend/utils/config.dart';
import 'package:intl/intl.dart';

class TagihanCard extends StatelessWidget {
  const TagihanCard({super.key, required this.tagihan});

  final Tagihan tagihan;

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    String currency(dynamic value) {
      final NumberFormat currency =
          NumberFormat.currency(locale: 'id-ID', symbol: 'IDR ');
      String formattedCurrency = currency.format(value);
      formattedCurrency = formattedCurrency.replaceAll('.', ',');
      return formattedCurrency;
    }

    return Container(
      width: Config.screenWidth,
      margin: const EdgeInsets.all(10),
      height: 120,
      child: GestureDetector(
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(13)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2))
              ],
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 0, 224, 206),
                Color.fromARGB(255, 0, 189, 173),
                Color.fromARGB(255, 0, 146, 133),
              ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
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
                    FontAwesomeIcons.solidCalendarDays,
                    color: Colors.white,
                    size: 60,
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed('bukti_pembayaran', arguments: {'tagihan' : tagihan});
        },
      ),
    );
  }
}
