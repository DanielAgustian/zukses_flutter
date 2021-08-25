class UtilStringLang {
  String priorityTransformation(String priority, List<String> priorityList) {
    if (priority == "High") {
      return priorityList[0];
    } else if (priority == "Medium") {
      return priorityList[1];
    } else if (priority == "Low") {
      return priorityList[2];
    } else {
      return priority;
    }
  }

  String priorityDeTransformation(String priority) {
    if (priority == "Tinggi") {
      return "High";
    } else if (priority == "Menengah") {
      return "Medium";
    } else if (priority == "rendah") {
      return "Low";
    }
    return priority;
  }

  String leaveLabelDeTransform(String name, List<String> list) {
    if (name == list[0]) {
      return "Single Day";
    } else if (name == list[1]) {
      return "Multiple Day";
    } else if (name == list[2]) {
      return "Half Day";
    }
    return name;
  }
}
