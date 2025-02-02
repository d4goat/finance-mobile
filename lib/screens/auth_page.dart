import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kos_mcflyon/main.dart';
import 'package:kos_mcflyon/provider/dio_provider.dart';
import 'package:kos_mcflyon/utils/config.dart';
import 'package:provider/provider.dart';
import 'package:kos_mcflyon/models/auth_model.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomorController = TextEditingController();
  final _ktpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/illust8.jpg',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Center(
                  child: Text(
                    "Selamat Datang",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                Config.spaceMedium,
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _ktpController,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                              hintText: 'Masukkan NIK',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: 'NIK',
                              alignLabelWithHint: true,
                              prefixIcon: Icon(Icons.credit_card_rounded),
                              prefixIconColor: Colors.black),
                        ),
                        Config.spaceSmall,
                        TextFormField(
                          controller: _nomorController,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                              hintText: 'Masukkan Nomor Kamar',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: 'Nomor Kamar',
                              alignLabelWithHint: true,
                              prefixIcon: Icon(Icons.meeting_room_outlined),
                              prefixIconColor: Colors.black),
                        ),
                        Config.spaceMedium,
                        Consumer<AuthModel>(builder: (context, auth, child) {
                          return SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  backgroundColor: HexColor('#008c8a'),
                                ),
                                onPressed: () async {
                                  final data = await DioProvider().getPenghuni(
                                      _ktpController.text,
                                      _nomorController.text);
                                  if (data != false) {
                                    Config.logger.i(data);
                                    auth.loginSuccess();
                                    MyApp.navigatorKey.currentState!
                                        .pushReplacementNamed('main');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Input data salah, silahkan coba lagi')));
                                  }
                                },
                                child: const Text(
                                  "MASUK",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 4),
                                )),
                          );
                        })
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
