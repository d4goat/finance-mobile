import 'package:frontend/models/penghuni_model.dart';

class Kos {
  int? id;
  String? uuid;
  int? nomor;
  int? harga;
  String? foto;
  String? keterangan;
  int? meteranListrik;
  int? meteranAir;
  Penghuni? penghuni;
  List<Penghuni>? daftarPenghuni; // Menambahkan daftarPenghuni jika perlu

  Kos({
    this.id,
    this.uuid,
    this.nomor,
    this.harga,
    this.foto,
    this.keterangan,
    this.meteranListrik,
    this.meteranAir,
    this.penghuni,
    this.daftarPenghuni,
  });

  factory Kos.fromJson(Map<String, dynamic> json) {
    return Kos(
      id: json['id'] as int?,
      uuid: json['uuid'] as String?,
      nomor: int.tryParse(json['nomor'] as String? ?? '0'), // Konversi nomor dari String ke int
      harga: json['harga'] as int?,
      foto: json['foto'] as String?,
      keterangan: json['keterangan'] as String?,
      meteranListrik: json['meteran_listrik'] as int?,
      meteranAir: json['meteran_air'] as int?,
      penghuni: json['penghuni'] != null ? Penghuni.fromJson(json['penghuni']) : null,
      daftarPenghuni: json['daftar_penghuni'] != null
          ? (json['daftar_penghuni'] as List)
              .map((item) => Penghuni.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'nomor': nomor,
      'harga': harga,
      'foto': foto,
      'keterangan': keterangan,
      'meteran_listrik': meteranListrik,
      'meteran_air': meteranAir,
      'penghuni': penghuni?.toJson(),
      'daftar_penghuni': daftarPenghuni?.map((e) => e.toJson()).toList(),
    };
  }
}
