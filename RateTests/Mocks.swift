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
    var lastSavedIntValue: Int?
    var lastSavedKey: String?
    var lastSavedDateValue: NSDate?
    var lastSavedBool: Bool?
    
    func saveInt(value: Int, key: String) {
        lastSavedIntValue = value
        lastSavedKey = key
    }
    
    func saveBool(value: Bool, key: String) {
        lastSavedKey = key
        lastSavedBool = value
        
    }
    
    func getIntForKey(key: String) -> Int {
        return lastSavedIntValue ?? -1
    }
    
    func getBoolForKey(key: String) -> Bool {
        lastSavedKey = key
        return false
    }
    
    func saveDate(date: NSDate, key: String) {
        lastSavedDateValue = date
        lastSavedKey = key
    }
    
    func getDate(key: String) -> NSDate {
        lastSavedKey = key
        return NSDate()
    }
}