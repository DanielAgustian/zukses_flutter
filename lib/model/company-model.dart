import 'package:zukses_app_1/model/user-model.dart';

class CompanyModel {
  String name, code, email, id;
  String startOfficeTime, endOfficeTime, phone, website, address, packageId;
  CompanyModel(
      {this.name,
      this.code,
      this.email,
      this.id,
      this.phone,
      this.website, this.address, this.packageId,
      this.startOfficeTime,
      this.endOfficeTime});

  CompanyModel.fromJson(Map<String, dynamic> map) {
    if (map != null) {
      this.id = map["id"].toString();
      this.name = map["company_name"];
      this.code = map["company_code"];
      this.email = map["company_email"];
      this.startOfficeTime = map["office_start_time"];
      this.endOfficeTime = map["office_end_time"];
    } else {
      this.id = "";
      this.name = "";
      this.code = "";
      this.email = "";
      this.startOfficeTime = "";
      this.endOfficeTime = "";
    }
  }
}
