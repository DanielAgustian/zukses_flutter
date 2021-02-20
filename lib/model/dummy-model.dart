class AbsenceTime {
  String id, time1, time2, status;
  DateTime date;
  AbsenceTime({this.date, this.id, this.time1, this.time2, this.status});
}

List<AbsenceTime> dummy = [
  AbsenceTime(
      id: "1",
      date: DateTime.parse("2021-02-11"),
      time1: "09.00",
      time2: "17.30",
      status: "on time"),
  AbsenceTime(
      id: "2",
      date: DateTime.parse("2021-02-12"),
      time1: "09.50",
      time2: "17.30",
      status: "late"),
  AbsenceTime(
      id: "3",
      date: DateTime.parse("2021-02-13"),
      time1: "09.13",
      time2: "17.30",
      status: "on time"),
  AbsenceTime(
      id: "4",
      date: DateTime.parse("2021-02-14"),
      time1: "09.00",
      time2: "17.30",
      status: "on time"),
  AbsenceTime(
      id: "5",
      date: DateTime.parse("2021-01-01"),
      time1: "09.00",
      time2: "17.30",
      status: "on time"),
];
