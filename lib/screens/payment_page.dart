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
          print('No Image Selected');
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      print("Please select an image first");
      return;
    }

    try {
      // Use the Dio provider to upload the image
      Response response =
          await dioProvider.uploadImage(_image!.path, tagihan.uuid);

      if (response.statusCode == 200 && response != null) {
        print("Image uploaded successfully: ${response.data['message']}");

        // Navigate to another page if upload is successful
        Navigator.of(context).pushNamed(
          'invoice', // Ganti dengan nama halaman yang Anda tuju
          arguments: {'tagihan': tagihan}, // Kirim tagihan sebagai argumen
        );
      } else {
        if (response == null)
          print("Failed to upload image: ${response.statusMessage}");
      }
    } catch (err) {
      print("Error uploading image: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Proof Room'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(
                    _image!,
                    width: 300,
                    height: 300,
                  ),
            Config.spaceSmall,
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
