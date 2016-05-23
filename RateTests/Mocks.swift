import Foundation
@testable import Rate

class MockRateSetup: RateSetupType
{
    var appStoreUrlString: String
    var timeSetup: RatingTimeSetup
    var textsSetup: RatingTextSetup
 
    init(urlString: String, timeSetup: RatingTimeSetup, textSetup: RatingTextSetup)
    {
        self.appStoreUrlString = urlString
        self.textsSetup = textSetup
        self.timeSetup = timeSetup
    }
}


class UrlOpenerMock: UrlOpener
{
    var simpleUrl: NSURL?
    func openUrl(url: NSURL)
    {
      simpleUrl = url
    }
}

class DataSaverMock: DataSaverType
{
    var lastSavedIntKey: String?
    var lastSavedDateKey: String?
    var lastSavedBoolKey: String?
    var lastSavedStringKey: String?

    var lastSavedIntValue: Int?
    var lastSavedDateValue: NSDate?
    var lastSavedBool: Bool?
    var lastSavedString: String?
    
    func saveInt(value: Int, key: String) {
        lastSavedIntKey = key
        lastSavedIntValue = value
    }
    
    func saveBool(value: Bool, key: String) {
        lastSavedBoolKey = key
        lastSavedBool = value
    }

    func saveDate(date: NSDate, key: String) {
        lastSavedDateKey = key
        lastSavedDateValue = date
    }

    func saveString(string: String, key: String) {
        lastSavedStringKey = key
        lastSavedString = string
    }

    func getIntForKey(key: String) -> Int? {
        return lastSavedIntValue
    }
    
    func getBoolForKey(key: String) -> Bool? {
        return lastSavedBool
    }

    func getDate(key: String) -> NSDate? {
        return lastSavedDateValue
    }

    func getString(key: String) -> String? {
        return lastSavedString
    }
}