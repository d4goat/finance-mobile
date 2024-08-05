import 'package:dio/dio.dart';
import 'package:kos_mcflyon/models/kos_model.dart';
import 'package:kos_mcflyon/models/penghuni_model.dart';
import 'package:kos_mcflyon/models/tagihan_model.dart';
import 'package:kos_mcflyon/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider {
  static BaseOptions options = BaseOptions(
    baseUrl: Config.api + 'api/mobile',
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
        var uuidPenghuni = response.data['data']['penghuni']['uuid'];
        var nomor = response.data['data']['nomor'];

        if (uuid != null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('uuid_kos', uuid);
        }

        if (uuidPenghuni != null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('uuid_penghuni', uuidPenghuni);
        }

        if (nomor != null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('nomor', nomor);
        }

        return response.data;
      } else {
        Config.logger.w('Data not found or incomplete.');
        return false;
      }
    } catch (error) {
      Config.logger.e('Error: $error');
      return false;
    }
  }

  Future<Kos?> getKos(dynamic uuid) async {
    try {
      Response response = await dio.get('/$uuid/kos');

      Config.logger.i(response.data);
      if (response.data != null) {
        return Kos.fromJson(response.data['data']);
      }
    } catch (error) {
      Config.logger.f('Error fetching Kos data: $error');
    }
    return null;
  }

  Future<Penghuni?> getPenghuniDetail(dynamic uuid) async {
    try {
      Response response = await dio.post('/get_penghuni', data: {'uuid': uuid});

      if (response.data != null) {
        return Penghuni.fromJson(response.data['data']);
      }
    } catch (err) {
      Config.logger.f('Error fething data Penghuni');
    }
    return null;
  }

  Future<List<Tagihan>> getTagihanBelumLunas(dynamic nomor) async {
    try {
      Response response =
          await dio.post('/belum_lunas', data: {'nomor': nomor});

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = response.data['data'];

        List<Tagihan> tagihanList = jsonResponse
            .map((json) => Tagihan.fromJson(json as Map<String, dynamic>))
            .toList();
        return tagihanList;
      } else {
        Config.logger.e('Failed to fetch data. ${response.statusCode}');
      }
    } catch (error) {
      Config.logger.f('Error fetching Tagihan data : $error');
      return [];
    }
    return [];
  }

  Future<List<Tagihan>> getTagihanPending(dynamic nomor) async {
    try {
      Response response = await dio.post('/pending', data: {'nomor': nomor});

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = response.data['data'];

        List<Tagihan> tagihanList = jsonResponse
            .map((json) => Tagihan.fromJson(json as Map<String, dynamic>))
            .toList();
        return tagihanList;
      } else {
        Config.logger.e('Failed to fetch data. ${response.statusCode}');
      }
    } catch (err) {
      Config.logger.f('Error fetching data : $err');
    }
    return [];
  }

  Future<List<Tagihan>> getTagihanLunas(dynamic nomor) async {
    try {
      Response response = await dio.post('/lunas', data: {'nomor': nomor});

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = response.data['data'];

        List<Tagihan> tagihanList = jsonResponse
            .map((json) => Tagihan.fromJson(json as Map<String, dynamic>))
            .toList();
        return tagihanList;
      } else {
        Config.logger.e('Failed to fetch data. ${response.statusCode}');
      }
    } catch (error) {
      Config.logger.f('Error fetching Tagihan data : $error');
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
        Config.logger.e("Failed to upload image: ${response.statusMessage}");
        return null;
      }
    } catch (err) {
      Config.logger.f("Error uploading image: $err");
    }
  }
}
