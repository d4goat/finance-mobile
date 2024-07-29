import 'package:flutter/material.dart';

class UltraSuperTitleText extends StatelessWidget {
  const UltraSuperTitleText(this.text, {super.key});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white));
  }
}

class SuperTitleText extends StatelessWidget {
  const SuperTitleText(this.text, {super.key});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[200]));
  }
}

class TitleTextBold extends StatelessWidget {
  const TitleTextBold(this.text, {super.key});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey[200]));
  }
}

class SubTitleText extends StatelessWidget {
  const SubTitleText(this.text, {super.key});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 15));
  }
}

class SuperSubTitleText extends StatelessWidget {
  const SuperSubTitleText(this.text, {super.key});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 13));
  }
}
