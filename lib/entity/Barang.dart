import 'dart:convert';

class Barang {
  int id;
  String nama;
  String deskripsi;
  int stok;

  Barang(
      {required this.id,
      required this.deskripsi,
      required this.nama,
      required this.stok});

  factory Barang.fromRawJson(String str) => Barang.fromJson(json.decode(str));
  factory Barang.fromJson(Map<String, dynamic> json) => Barang(
      id: json['id'],
      deskripsi: json['deskripsi'],
      nama: json['nama'],
      stok: json['stok']);

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'deskripsi': deskripsi,
        'stok': stok,
      };
}
