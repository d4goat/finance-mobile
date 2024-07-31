class Penghuni {
  int? id;
  String? uuid;
  int? kosId;
  String? nama;
  String? telepon;
  String? ktp;
  int? status;

  Penghuni(
      {this.id,
      this.uuid,
      this.kosId,
      this.nama,
      this.telepon,
      this.ktp,
      this.status});

  factory Penghuni.fromJson(Map<String, dynamic> json) {
    if (json['status'] == null) {
      json['status'] = 0;
    }
    return Penghuni(
      id: json['id'],
      uuid: json['uuid'],
      kosId: json['kos_id'],
      nama: json['nama'],
      telepon: json['telepon'],
      ktp: json['ktp'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['kos_id'] = this.kosId;
    data['nama'] = this.nama;
    data['telepon'] = this.telepon;
    data['ktp'] = this.ktp;
    data['status'] = this.status;
    return data;
  }
}
