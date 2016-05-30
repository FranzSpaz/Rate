import Foundation

public protocol RateSetupType {
    var appStoreUrlString: String { get }
    var timeSetup: RatingTimeSetup { get }
    var textsSetup: RatingTextSetup { get }
}

public protocol DataSaverType {
    func saveInt(value: Int, key: String)
    func saveBool(value: Bool, key: String)
    func saveDate(date: NSDate, key: String)
    func saveString(string: String, key: String)

    func getIntForKey(key: String) -> Int?
    func getBoolForKey(key: String) -> Bool?
    func getDateForKey(key: String) -> NSDate?
    func getStringForKey(key: String) -> String?

	func resetValueForKey(key: String)
}

public protocol URLOpenerType {
	func openURL(url: NSURL) -> Bool
}
