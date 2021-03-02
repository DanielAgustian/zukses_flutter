import 'dart:convert';

import 'package:flutter/services.dart';

class Company2 {
  String kode;
  String nama;

  Company2({
    this.kode,
    this.nama,
  });

  factory Company2.fromJson(Map<String, dynamic> parsedJson) {
    return Company2(
      kode: parsedJson['kode'] as String,
      nama: parsedJson['nama'] as String,
    );
  }
}

class Company2ViewModel {
  static List<Company2> company;

  static Future loadPlayers() async {
    try {
      company = new List<Company2>();
      String jsonString = await rootBundle.loadString('assets/json/dummy.json');
      Map parsedJson = json.decode(jsonString);
      var categoryJson = parsedJson['company'] as List;
      for (int i = 0; i < categoryJson.length; i++) {
        company.add(new Company2.fromJson(categoryJson[i]));
      }
    } catch (e) {
      print(e);
    }
  }
}
