import 'package:bomberos_ya/config/helpers/db_helper.dart';
import 'package:bomberos_ya/config/helpers/local_storage_util.dart';
import 'package:bomberos_ya/config/services/api_services.dart';
import 'package:bomberos_ya/models/fire_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/helpers/base64_converter.dart';
import 'package:bomberos_ya/config/helpers/date_utils.dart' as local_date_utils;

final simpleReportProvider =
    ChangeNotifierProvider((ref) => _SimpleReportProvider());

class _SimpleReportProvider extends ChangeNotifier {
  String? selectedType;
  String? audioPath;
  String audioBase64 = '';
  List<XFile> selectedImages = [];
  List<FireTypes> fireTypes = [];
  bool isLoading = false;
  bool noDataFound = false;
  final services = ApiServices();
  final dbHelper = DBHelper();
  _SimpleReportProvider() {
    getFireTypes();
    initData();
  }

  void initData() async {
    selectedType = await LocalStorageUtil.getLocalData(KeyTypes.selectedType);
    audioPath = await LocalStorageUtil.getLocalData(KeyTypes.currentRecording);
    notifyListeners();
  }

  void getFireTypes() async {
    // Get from sqlite
    fireTypes = await dbHelper.getFireTypes();
    notifyListeners();
    // Get lasTimeModified from sqlite
    final lastTimeModified = await dbHelper.getLastModifiedTime();
    // Provide a default date
    String lastTime = "01-01-2020 00:00:00";
    if (lastTimeModified != null) {
      lastTime = local_date_utils.DateUtils.formatDateTime(lastTimeModified);
    }

    // Get from http service
    final fireTypesNetwork = await services.getFireTypes(lastTime);

    if (fireTypesNetwork.isNotEmpty) {
      // Verify if new element exists
      for (final networkItem in fireTypesNetwork) {
        var contain =
            fireTypes.where((element) => element.id == networkItem.id);

        if (contain.isEmpty) {
          // If the element does not exist, add it to the list
          fireTypes.add(networkItem);
          // Add to sqlite
          await dbHelper.insertFireType(networkItem);
        } else {
          final FireTypes existingItem = fireTypes.firstWhere(
            (item) => item.id == networkItem.id,
          );
          // If the element already exists, compare to see if there are changes
          if (existingItem.toJson().toString() !=
              networkItem.toJson().toString()) {
            // Update the existing item with the new data
            fireTypes[fireTypes.indexOf(existingItem)] = networkItem;
            // Update in sqlite
            await dbHelper.updateFireType(networkItem);
          }
        }
      }
    }

    // Show only ENABLED fire types
    fireTypes =
        fireTypes.where((fireType) => fireType.status == "ENABLED").toList();
    noDataFound = fireTypes.isEmpty;
    // List<Map<String, dynamic>> fireReports = await dbHelper.getFireReports();
    // selectedType = fireReports[0]["fireTypeId"] ?? "";
    notifyListeners();
  }

  void postData() async {
    isLoading = true;
    notifyListeners();
    final images = await Base64Converter.convertImagesToBase64(selectedImages);
    services.postReport(audioBase64, images);
    isLoading = false;
    notifyListeners();
  }

  void updateSelectedType(FireTypes fireType) {
    String fireTypeId = fireType.id;
    selectedType = fireTypeId;
    LocalStorageUtil.saveLocalData(fireTypeId, KeyTypes.selectedType);
  }

  void saveRecord(String audioPath) {
    this.audioPath = audioPath;
    LocalStorageUtil.saveLocalData(audioPath, KeyTypes.currentRecording);
    notifyListeners();
  }
}
