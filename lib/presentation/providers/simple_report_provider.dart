import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:bomberos_ya/config/helpers/base64_converter.dart';
import 'package:bomberos_ya/config/helpers/db_helper.dart';
import 'package:bomberos_ya/config/helpers/local_storage_util.dart';
import 'package:bomberos_ya/config/services/api_services.dart';
import 'package:bomberos_ya/models/fire_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bomberos_ya/config/helpers/date_utils.dart' as local_date_utils;

final simpleReportProvider =
    ChangeNotifierProvider((ref) => _SimpleReportProvider());

class _SimpleReportProvider extends ChangeNotifier {
  int currentPage = 0;
  String? selectedType;
  String? audioPath;
  List<FireTypes> fireTypes = [];
  bool isLoading = false;
  bool noDataFound = false;
  final services = ApiServices();
  final dbHelper = DBHelper();
  List<String> selectedImages = [];
  int imageLimit = 4;
  String currentProcess = "";
  _SimpleReportProvider() {
    getFireTypes();
    initData();
  }

  void setPage(int page) {
    currentPage = page;
    notifyListeners();
  }

  void goToNextPage() {
    if (currentPage < 2) {
      currentPage++;
      notifyListeners();
    }
  }

  void goToPreviousPage() {
    if (currentPage > 0) {
      currentPage--;
      notifyListeners();
    }
  }

  void initData() async {
    selectedType = await LocalStorageUtil.getLocalData(KeyTypes.selectedType);
    audioPath = await LocalStorageUtil.getLocalData(KeyTypes.currentRecording);
    selectedImages = await LocalStorageUtil.getArrayList(KeyTypes.imagesList);

    if (selectedImages.isNotEmpty) {
      currentPage = 2;
    } else {
      if (audioPath != null) {
        currentPage = 2;
      } else {
        if (selectedType != null) {
          currentPage = 1;
        }
      }
    }
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
    if (lastTimeModified != null && fireTypes.isNotEmpty) {
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
    // FlutterBackgroundService().invoke("setAsForeground");
    try {
      isLoading = true;
      // final images =
      //     await Base64Converter.convertImagesToBase64(selectedImages);
      final audioBase64 =
          await Base64Converter.convertAudioToBase64(File(audioPath ?? ""));
      // final imagenesJson = jsonEncode(images);

      final report = ReportRequest(
          id: Random().nextInt(10000).toString(),
          hash: "",
          usuario: "el ya tu sabe",
          tipoIncendio: selectedType ?? "",
          lon: "",
          lat: "",
          audio: audioBase64,
          imagenes: jsonEncode(selectedImages),
          part: "1");

      ReportRequestDataBase.instance.insertReport(report);

      isLoading = false;
      await removeAllData();
      notifyListeners();
    } catch (e) {
      // Manejar la excepción aquí
      print('Error en postData: $e');
      // Puedes realizar acciones específicas según el tipo de error
    }
  }

  void updateSelectedType(FireTypes fireType) {
    String fireTypeId = fireType.id;
    selectedType = fireTypeId;
    LocalStorageUtil.saveLocalData(fireTypeId, KeyTypes.selectedType);
    goToNextPage();
  }

  void saveRecord(String audioPath) {
    this.audioPath = audioPath;
    LocalStorageUtil.saveLocalData(audioPath, KeyTypes.currentRecording);
    notifyListeners();
  }

  void addImage(String imagePath) {
    selectedImages.add(imagePath);
    LocalStorageUtil.saveArrayList(selectedImages, KeyTypes.imagesList);
    notifyListeners();
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    LocalStorageUtil.saveArrayList(selectedImages, KeyTypes.imagesList);
    notifyListeners();
  }

  Future removeAllData() async {
    currentPage = 0;
    selectedType = null;
    audioPath = null;
    isLoading = false;
    noDataFound = false;
    selectedImages = [];
    imageLimit = 4;
    currentProcess = "";
    await LocalStorageUtil.removeData();
  }
}
