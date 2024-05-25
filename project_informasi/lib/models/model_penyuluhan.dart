class ModelPenyuluhan {
  ModelPenyuluhan({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  late final bool isSuccess;
  late final String message;
  late final List<Penyuluhan> data;

  ModelPenyuluhan.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    data = List.from(json['data']).map((e) => Penyuluhan.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['isSuccess'] = isSuccess;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Penyuluhan {
  Penyuluhan({
    required this.id_penyuluhan,
    required this.id_user,
    required this.nama,
    required this.no_hp,
    required this.ktp,
    required this.ktp_pdf,
    required this.permasalahan,
    required this.permasalahan_pdf,
    required this.status,
  });

  late final String id_penyuluhan;
  late final String id_user;
  late final String nama;
  late final String no_hp;
  late final String ktp;
  late final String ktp_pdf;
  late final String permasalahan;
  late final String permasalahan_pdf;
  late final String status;

  Penyuluhan.fromJson(Map<String, dynamic> json) {
    id_user = json['id_user'].toString();
    id_penyuluhan = json['id_penyuluhan'].toString();
    nama = json['nama'];
    no_hp = json['no_hp'];
    ktp = json['ktp'];
    ktp_pdf = json['ktp_pdf'];
    permasalahan = json['permasalahan'];
    permasalahan_pdf = json['permasalahan_pdf'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id_user'] = id_user;
    _data['id_penyuluhan'] = id_penyuluhan;
    _data['nama'] = nama;
    _data['no_hp'] = no_hp;
    _data['ktp'] = ktp;
    _data['ktp_pdf'] = ktp_pdf;
    _data['permasalahan'] = permasalahan;
    _data['permasalahan_pdf'] = permasalahan_pdf;
    _data['status'] = status;
    return _data;
  }
}
