import 'package:dio/dio.dart';
import 'package:frontend/models/kos_model.dart';
import 'package:frontend/models/tagihan_model.dart';
import 'package:frontend/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider {
  static BaseOptions options = BaseOptions(
    baseUrl: Config.api + 'api',
    connectTimeout: const Duration(milliseconds: 200000),
    receiveTimeout: const Duration(milliseconds: 200000),
  );

  Dio dio = Dio(options);

  Future<dynamic> getPenghuni(dynamic ktp, dynamic nomor) async {
    try {
      Response response = await dio.post(
        '/search',
        data: {'ktp': ktp, 'nomor': nomor},
      );

      if (response.data != null && response.data['data'] != null) {
        var uuid = response.data['data']['uuid'];

        if (uuid != null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('uuid_kos', uuid);
        }

        return response.data;
      } else {
        print('Data not found or incomplete.');
        return false;
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  Future<Kos?> getKos(dynamic uuid) async {
    try {
      Response response = await dio.get('/$uuid/kos');

      print(response.data);
      if (response.data != null) {
        return Kos.fromJson(response.data['data']);
      }
    } catch (error) {
      print('Error fetching Kos data: $error');
    }
    return null;
  }

  Future<List<Tagihan>> getTagihanBelumLunas() async {
    try {
      Response response = await dio.get('/belum_lunas');

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = response.data;

        List<Tagihan> tagihanList = jsonResponse
            .map((json) => Tagihan.fromJson(json as Map<String, dynamic>))
            .toList();
        return tagihanList;
      } else {
        print('Failed to fetch data. ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching Tagihan data : $error');
      return [];
    }
    return [];
  }

  Future<List<Tagihan>> getTagihanLunas() async {
    try {
      Response response = await dio.get('/lunas');

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = response.data;

        List<Tagihan> tagihanList = jsonResponse
            .map((json) => Tagihan.fromJson(json as Map<String, dynamic>))
            .toList();
        return tagihanList;
      } else {
        print('Failed to fetch data. ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching Tagihan data : $error');
      return [];
    }
    return [];
  }

  Future<dynamic> uploadImage(String imagePath, dynamic uuid) async {
    try {
      String filename = imagePath.split('/').last;
      FormData formData = FormData.fromMap({
        "foto_bukti_pembayaran":
            await MultipartFile.fromFile(imagePath, filename: filename)
      });

      Response response = await dio.post(
        "/$uuid/bukti",
        data: formData,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"},
        ),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print("Failed to upload image: ${response.statusMessage}");
        return null;
      }
    } catch (err) {
      print("Error uploading image: $err");
    }
  }
}
