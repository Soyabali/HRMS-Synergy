class NotificationModel {
  String iTranId;
  String sTitle;
  String sNotification;
  String sNotiDate;
  String sNotiType;

  NotificationModel({
    required this.iTranId,
    required this.sTitle,
    required this.sNotification,
    required this.sNotiDate,
    required this.sNotiType,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      iTranId: json['iTranId'] as String,
      sTitle: json['sTitle'] as String,
      sNotification: json['sNotification'] as String,
      sNotiDate: json['sNotiDate'] as String,
      sNotiType: json['sNotiType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iTranId': iTranId,
      'sTitle': sTitle,
      'sNotification': sNotification,
      'sNotiDate': sNotiDate,
      'sNotiType': sNotiType,
    };
  }
}

List<NotificationModel> parseNotifications(List<dynamic> jsonList) {
  return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
}
