import 'package:dio/dio.dart';
import 'package:frontend/models/kos_model.dart';
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
}
