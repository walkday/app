import Foundation

public struct Defaults {
    public static var sponsor: Bool {
        get { UserDefaults.standard.object(forKey: "sponsor") as? Bool ?? false }
        set { UserDefaults.standard.setValue(newValue, forKey: "sponsor") }
    }
    
    private static var onboard: Bool {
        get { UserDefaults.standard.object(forKey: "onboard") as? Bool ?? true }
        set { UserDefaults.standard.setValue(newValue, forKey: "onboard") }
    }
    
    private init() { }
}
