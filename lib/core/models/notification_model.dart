// Notification status
enum NotificationAppStatus { SUCESS, FAILED }

// Notification
class NotificationApp {
  String msg;
  NotificationAppStatus notificationStatus;

  NotificationApp(this.msg, this.notificationStatus);
}
