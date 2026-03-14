import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private let defaults = UserDefaults(suiteName: SharedConstants.appGroupID)
    private let enabledKey = "monthlyNotificationsEnabled"

    var isEnabled: Bool {
        get { defaults?.bool(forKey: enabledKey) ?? false }
        set {
            defaults?.set(newValue, forKey: enabledKey)
            if newValue {
                scheduleMonthlyNotification()
            } else {
                cancelAll()
            }
        }
    }

    func requestPermissionAndEnable() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    self.isEnabled = true
                }
            }
        }
    }

    func scheduleMonthlyNotification() {
        cancelAll()

        let content = UNMutableNotificationContent()
        content.title = "New Season Alert!"
        content.sound = .default

        let region = SharedDataManager.shared.currentRegion
        let nextMonth = (Calendar.current.component(.month, from: Date()) % 12) + 1
        let newItems = SeasonalData.shared.comingSoon(for: region, month: Calendar.current.component(.month, from: Date()))
        let count = newItems.count
        let previews = newItems.prefix(3).map(\.emoji).joined()

        if count > 0 {
            content.body = "\(previews) \(count) new items coming into season! Check what's fresh."
        } else {
            content.body = "Check out what's in season this month!"
        }

        // Fire on the 1st of each month at 9 AM
        var dateComponents = DateComponents()
        dateComponents.day = 1
        dateComponents.hour = 9
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "monthly-season-update", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    private func cancelAll() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["monthly-season-update"])
    }
}
