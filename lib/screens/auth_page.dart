import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/tagihan_model.dart';
import 'package:frontend/provider/dio_provider.dart';
import 'package:frontend/utils/config.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/auth_model.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: ClipRRect(
                child: Image.asset(
                  'assets/illust1.jpg',
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
                              backgroundColor: Config.primaryColor,
                            ),
                            onPressed: () async {
                              final data = await DioProvider().getPenghuni(
                                  _ktpController.text, _nomorController.text);
                              if (data != null) {
                                print(data);
                                auth.loginSuccess();
                                MyApp.navigatorKey.currentState!
                                    .pushNamed('main');
                              }
                            },
                            child: const Text(
                              "Cari",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            )),
                      );
                    })
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
