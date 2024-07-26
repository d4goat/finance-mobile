import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/tagihan_model.dart';
import 'package:frontend/provider/dio_provider.dart';
import 'package:frontend/utils/config.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  File? _image;
  final DioProvider dioProvider = DioProvider();
  late Tagihan tagihan;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve the Tagihan object from the arguments
    if (ModalRoute.of(context) != null) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      tagihan = args['tagihan'] as Tagihan;
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (image != null) {
          _image = File(image.path);
        } else {
          Config.logger.w('No Image Selected');
        }
      });
    } catch (e) {
      Config.logger.e('Error picking image: $e');
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      Config.logger.w("Please select an image first");
      return;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Config.spaceSmall,
                  CircularProgressIndicator(),
                  Config.spaceSmall,
                  Text('Uploading image ...')
                ],
              ),
            ),
          );
        });

    try {
      // Use the Dio provider to upload the image
      Response response =
          await dioProvider.uploadImage(_image!.path, tagihan.uuid);

      if (response.statusCode == 200 && response != null) {
        Config.logger
            .i("Image uploaded successfully: ${response.data['message']}");

        // Navigate to another page if upload is successful
        Config.logger.i(tagihan);
        Navigator.of(context).pushNamed(
          'invoice', // Ganti dengan nama halaman yang Anda tuju
          arguments: {'tagihan': tagihan}, // Kirim tagihan sebagai argumen
        );
      } else {
        if (response == null)
          Config.logger.e("Failed to upload image: ${response.statusMessage}");
      }
    } catch (err) {
      Navigator.of(context).pop();
      Config.logger.f("Error uploading image: $err");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error uploading image. Please try again ')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.primaryColor,
        title: const Text(
          'Halaman Pembayaran',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text(
                    'Tidak ada foto yang terpilih',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                : Image.file(
                    _image!,
                    width: 400,
                    height: 400,
                  ),
            Config.spaceMedium,
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
