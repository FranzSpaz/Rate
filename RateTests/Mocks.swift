import Foundation
@testable import Rate

func after(value: Double, callback: () -> ()) {
	let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(value * Double(NSEC_PER_SEC)))
	dispatch_after(delayTime, dispatch_get_main_queue(),callback)
}

class MockRateSetup: RateSetupType {
	var appStoreUrlString: String
	var timeSetup: RatingTimeSetup
	var textsSetup: RatingTextSetup

	init(urlString: String,
	     timeSetup: RatingTimeSetup,
	     textSetup: RatingTextSetup) {
		self.appStoreUrlString = urlString
		self.textsSetup = textSetup
		self.timeSetup = timeSetup
	}
}

class UrlOpenerMock: URLOpenerType {
	var lastOpenedURL: NSURL?
	func openURL(url: NSURL) -> Bool {
		lastOpenedURL = url
		return true
	}
}

class DataSaverMock: DataSaverType {
    var dict: [String:AnyObject] = [:]
    
    func resetValueForKey(key: String) {
        dict[key] = nil
    }
    
    func saveInt(value: Int, key: String) {
        dict[key] = value
    }
    
    func saveBool(value: Bool, key: String) {
        dict[key] = value
    }

    func saveDate(date: NSDate, key: String) {
        dict[key] = date
    }

    func saveString(string: String, key: String) {
        dict[key] = string
    }

    func getIntForKey(key: String) -> Int? {
        return dict[key] as? Int
    }
    
    func getBoolForKey(key: String) -> Bool? {
        return dict[key] as? Bool
    }

    func getDateForKey(key: String) -> NSDate? {
        return dict[key] as? NSDate
    }

    func getStringForKey(key: String) -> String? {
        return dict [key] as? String
    }
}
