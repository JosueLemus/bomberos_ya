import 'dart:convert';

import 'package:bomberos_ya/models/fire_types.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final baseUrl = "http://192.168.0.28:3001";

  Future<List<FireTypes>> getFireTypes() async {
    final url = Uri.parse('$baseUrl/tipo-solicitudes');
    final response = await http.get(
      url,
    );
    final json = jsonDecode(response.body);
    return FireTypes.fromJsonList(json);
  }

  Future<List<String>> postReport() async {
    final url = Uri.parse('$baseUrl/denuncias?usuario=');
    final response = await http.get(
      url,
    );
    final json = jsonDecode(response.body);
    // return ComplaintDto.fromJsonList(json);
    return [""];
  }
}