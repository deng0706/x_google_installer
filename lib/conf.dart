import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'api.dart';

class AppConf {
  static IndexData _indexData;

  static Future<int> initData() async {
    await Hive.initFlutter();
    var box = await Hive.openBox('appConfig');
    final lastUpdate = box.get("lastUpdate");
    var savedData = box.get("index.json");
    if (lastUpdate == null ||
        savedData == null ||
        DateTime.now().add(Duration(days: -1)).millisecond > lastUpdate) {
      print("getting...");
      String jsonString = await Api.getIndexData();
      box.put("index.json", jsonString);
      box.put("lastUpdate", DateTime.now().millisecond);
      _indexData = IndexData.formJson(jsonString);
      return 1;
    } else {
      _indexData = IndexData.formJson(savedData);
      return 0;
    }
  }
}

class IndexData {
  int appVersion;
  String urlPath;
  Map framework;
  Map services;
  Map store;

  IndexData(
      this.appVersion, this.urlPath, this.framework, this.services, this.store);

  factory IndexData.formJson(String jsonString) {
    Map m = json.decode(jsonString);
    return IndexData(m["app_version"], m["url_path"], m["f"], m["s"], m["st"]);
  }
}

class ApkData {
  int versionCode;
  String versionName;
  int minApi;
  String url;
  String note;

  ApkData(this.versionCode, this.versionName, this.minApi, this.url, this.note);

  factory ApkData.formMapAndIndex(int index, Map m) {
    return ApkData(index, m["version_name"], m["min_api"], m["url"], m["note"]);
  }
}