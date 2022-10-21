import WatchKit
import WidgetKit

final class Delegate: NSObject, WKApplicationDelegate {
    weak var session: Session?
    
    func applicationDidFinishLaunching() {
        WKApplication.shared().registerForRemoteNotifications()
    }
    
    func didReceiveRemoteNotification(_: [AnyHashable : Any]) async -> WKBackgroundFetchResult {
        await session?.cloud.backgroundFetch == true ? .newData : .noData
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        Task {
            WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Calendar.current.date(byAdding: .minute, value: 20, to: .now)!, userInfo: nil) { _ in }
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
}
