class NotificationResult {
  String? platform;
  int? successDelivery;
  int? failedDelivery;
  int? erroredDelivery;
  int? openedNotification;

  NotificationResult(
      {this.platform,
      this.successDelivery,
      this.failedDelivery,
      this.erroredDelivery,
      this.openedNotification});

  NotificationResult.fromJson(Map<String, dynamic> json) {
    platform = json['platform'];
    successDelivery = json['success_delivery'];
    failedDelivery = json['failed_delivery'];
    erroredDelivery = json['errored_delivery'];
    openedNotification = json['opened_notification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['platform'] = platform;
    data['success_delivery'] = successDelivery;
    data['failed_delivery'] = failedDelivery;
    data['errored_delivery'] = erroredDelivery;
    data['opened_notification'] = openedNotification;
    return data;
  }
}
