class Tagihan {
  int? id;
  String? uuid;
  int? penghuniKosId;
  String? mulai;
  String? selesai;
  int? statusBayar;
  int? totalTagihan;
  int? meteranListrikAwal;
  int? meteranListrikAkhir;
  int? meteranAirAwal;
  int? meteranAirAkhir;
  dynamic fotoMeteranAir;
  int? mobil;
  int? biayaMobil;
  int? biayaKebersihan;
  int? meteranListrik;
  int? meteranAir;
  String? tanggalMulai;
  String? tanggalSelesai;

  Tagihan({
    this.id,
    this.uuid,
    this.penghuniKosId,
    this.mulai,
    this.selesai,
    this.statusBayar,
    this.totalTagihan,
    this.meteranListrikAwal,
    this.meteranListrikAkhir,
    this.meteranAirAwal,
    this.meteranAirAkhir,
    this.fotoMeteranAir,
    this.mobil,
    this.biayaMobil,
    this.biayaKebersihan,
    this.meteranListrik,
    this.meteranAir,
    this.tanggalMulai,
    this.tanggalSelesai,
  });

  factory Tagihan.fromJson(Map<String, dynamic> json) {
    return Tagihan(
      id: json['id'] as int?,
      uuid: json['uuid'] as String?,
      penghuniKosId: json['penghuni_kos_id'] as int?,
      mulai: json['mulai'] as String?,
      selesai: json['selesai'] as String?,
      statusBayar: json['status_bayar'] as int?,
      totalTagihan: json['total_tagihan'] as int?,
      meteranListrikAwal: json['meteran_listrik_awal'] as int?,
      meteranListrikAkhir: json['meteran_listrik_akhir'] as int?,
      meteranAirAwal: json['meteran_air_awal'] as int?,
      meteranAirAkhir: json['meteran_air_akhir'] as int?,
      fotoMeteranAir: json['foto_meteran_air'],
      mobil: json['mobil'] as int?,
      biayaMobil: json['biaya_mobil'] as int?,
      biayaKebersihan: json['biaya_kebersihan'] as int?,
      meteranListrik: json['meteran_listrik'] as int?,
      meteranAir: json['meteran_air'] as int?,
      tanggalMulai: json['tanggal_mulai'] as String?,
      tanggalSelesai: json['tanggal_selesai'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'penghuni_kos_id': penghuniKosId,
      'mulai': mulai,
      'selesai': selesai,
      'status_bayar': statusBayar,
      'total_tagihan': totalTagihan,
      'meteran_listrik_awal': meteranListrikAwal,
      'meteran_listrik_akhir': meteranListrikAkhir,
      'meteran_air_awal': meteranAirAwal,
      'meteran_air_akhir': meteranAirAkhir,
      'foto_meteran_air': fotoMeteranAir,
      'mobil': mobil,
      'biaya_mobil': biayaMobil,
      'biaya_kebersihan': biayaKebersihan,
      'meteran_listrik': meteranListrik,
      'meteran_air': meteranAir,
      'tanggal_mulai': tanggalMulai,
      'tanggal_selesai': tanggalSelesai,
    };
  }
}