import 'dart:convert';

List<FireTypes> fireTypesFromJson(String str) =>
    List<FireTypes>.from(json.decode(str).map((x) => FireTypes.fromJson(x)));

String fireTypesToJson(List<FireTypes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FireTypes {
  final String id;
  final String nombre;
  final String descripcion;
  final String imageUrl;

  FireTypes({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imageUrl,
  });

  factory FireTypes.fromJson(Map<String, dynamic> json) => FireTypes(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "imageUrl": imageUrl,
      };

  static List<FireTypes> fromJsonList(List<dynamic> json) {
    final fireTypes = json.map((data) => FireTypes.fromJson(data)).toList();
    return fireTypes;
  }
}
