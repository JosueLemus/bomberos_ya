import 'dart:convert';
import 'package:bomberos_ya/config/helpers/date_utils.dart';
import 'package:bomberos_ya/config/helpers/db_helper.dart';
import 'package:bomberos_ya/models/fire_types.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final baseUrl = "192.168.0.9:3001";

  Future<List<FireTypes>> getFireTypes() async {
    final dbHelper = DBHelper();
    List<FireTypes> fireTypes = [];
    final lastTimeModified = await dbHelper.getLastModifiedTime();
    fireTypes = await dbHelper.getFireTypes();
    String lastTime = "16/11/2020 22:00:00";
    if (lastTimeModified != null) {
      lastTime = DateUtils.formatDateTime(lastTimeModified);
    }

    final queryParameters = {'lastTimeModified': lastTime};
    final url = Uri.http(baseUrl, '/tipo-solicitudes', queryParameters);
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    final newList = FireTypes.fromJsonList(json);

    if (newList.isEmpty) {
      return fireTypes;
    } else {
      // Comparar y actualizar la lista fireTypes
      for (final newItem in newList) {
        var contain = fireTypes.where((element) => element.id == newItem.id);

        if (contain.isEmpty) {
          // Si el elemento no existe, agregarlo a la lista
          fireTypes.add(newItem);
          await dbHelper.insertFireType(newItem);
        } else {
          final FireTypes existingItem = fireTypes.firstWhere(
            (item) => item.id == newItem.id,
          );
          // Si el elemento ya existe, comparar para ver si hay cambios
          if (existingItem.toJson().toString() != newItem.toJson().toString()) {
            // Actualizar el elemento existente con los nuevos datos
            fireTypes[fireTypes.indexOf(existingItem)] = newItem;
            // También puedes actualizar el elemento en la base de datos si es necesario
            await dbHelper.updateFireType(newItem);
          }
        }
      }
      return fireTypes;
    }
  }

  Future<void> postReport(String audio, List<String> images) async {
    final url = Uri.parse('$baseUrl/denuncias');
    final imagenes2 = jsonEncode(images);
    final response = await http.post(
      url,
      body: {
        'usuario': "El ya tu sabe",
        // 'titulo': "",
        // 'descripcion': "",
        // 'tipoDenuncia':"",
        // 'lon':"",
        // 'lat': "",
        'imagenes': imagenes2,
        'audio': audio,
      },
    );
    print(response);
  }
}
