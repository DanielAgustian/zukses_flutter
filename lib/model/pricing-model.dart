class PricingModel {
  int planId,
      attendance,
      task,
      projectRole,
      meetingScheduling,
      meetingRoleAssign,
      price,
      intervalCount;
  String planName, interval, projectLimit;
  PricingModel(
      {this.attendance,
      this.planId,
      this.task,
      this.projectRole,
      this.meetingScheduling,
      this.meetingRoleAssign,
      this.interval,
      this.intervalCount,
      this.planName,
      this.price,
      this.projectLimit});
  PricingModel.fromJson(Map<String, dynamic> map) {
    this.planId = map['plan_id'];
    this.attendance = map['attendance'];
    this.task = map['task_management'];
    this.projectLimit = map['project_limit'];
    this.projectRole = map['project_role'];
    this.meetingScheduling = map['meeting_scheduling'];
    this.meetingRoleAssign = map['meeting_role_assign'];
    this.planName = map['plan_name'];
    this.price = map['price'];
    this.interval = map['interval'];
    this.intervalCount = map['interval_count'];
  }
}
