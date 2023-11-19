// import 'package:shared_preferences/shared_preferences.dart';

// class LocalStorageUtil {
//   static Future<void> saveLocalData(String data, KeyTypes key) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(key.name, data);
//   }

//   static Future<String?> getLocalData(KeyTypes key) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(key.name);
//   }
// }

// enum KeyTypes { fireTypesList, selectedType, currentRecording, selectedPhotos }
