import Foundation

public protocol UrlOpener
{
    func openUrl(url: NSURL)
}

public protocol RateSetupType
{
    var appStoreUrlString: String { get }
    var timeSetup: RatingTimeSetup { get }
    var textsSetup: RatingTextSetup { get }
}

public protocol DataSaverType
{
    func saveInt(value: Int, key: String)
    func saveBool(value: Bool, key: String)
    func getIntForKey(key: String) -> Int
    func getBoolForKey(key: String) -> Bool
    func saveDate(date: NSDate, key: String)
    func getDate(key: String) -> NSDate
}

public struct RatingTimeSetup
{
    let daysUntilPrompt: Int
    let usesUntilPrompt: Int
    let remindPeriod: Int
    let rateNewVersionsIndipendently: Bool
    
    public init(daysUntilPrompt: Int, usesUntilPrompt: Int, remindPeriod: Int, rateNewVersionIndipendency: Bool)
    {
        self.daysUntilPrompt = daysUntilPrompt
        self.rateNewVersionsIndipendently = rateNewVersionIndipendency
        self.remindPeriod = remindPeriod
        self.usesUntilPrompt = usesUntilPrompt
    }
}

public struct RatingTextSetup
{
    let alertTitle: String
    let alertMessage: String
    let rateButtonTitle: String
    let remindButtonTitle: String
    let ignoreButtonTitle: String
    
    public init(alertTitle: String, alertMessage: String, rateButtonTitle: String, remindButtonTitle: String, ignoreButtonTitle: String)
    {
        self.alertMessage = alertMessage
        self.alertTitle = alertTitle
        self.ignoreButtonTitle = ignoreButtonTitle
        self.rateButtonTitle = rateButtonTitle
        self.remindButtonTitle = remindButtonTitle
    }
}

public class Rate
{
    let rateSetup: RateSetupType
    let dataSaver: DataSaverType
    var usesNumber: Int = 0
    var dateFirstBoot: NSDate
    let urlOpener: UrlOpener
   
    public init(rateSetup: RateSetupType,
         dataSaver: DataSaverType,
         openUrl: UrlOpener)
    {
        self.rateSetup = rateSetup
        self.dataSaver = dataSaver
        self.dateFirstBoot = NSDate()
        self.urlOpener = openUrl
        
    }
    
    func voteNowOnAppStore()
    {
        guard let urlNoOpt = NSURL(string: rateSetup.appStoreUrlString) else { return }
        urlOpener.openUrl(urlNoOpt)
    }
    
    public func saveParametersNewReleaseApp()
    {
        dataSaver.saveDate(NSDate(), key: "dateFirstBoot")
        dataSaver.saveInt(1, key: "usesNumber")
    }
    
    public func getUsesNumber() -> Int
    {
        return dataSaver.getIntForKey("usesNumber")
    }
    
    public func updateUsesNumber()
    {
        dataSaver.saveInt(usesNumber + 1, key: "usesNumber")
    }
    
    func voteDone() -> Bool
    {
        return dataSaver.getBoolForKey("rated") == true
    }
    
    public func saveDateFirstBoot()
    {
        if(usesNumber == 1)
        {
            dataSaver.saveDate(dateFirstBoot, key: "dateFirstBoot")
        }
    }

    func getDateFirstBoot() -> NSDate
    {
        dateFirstBoot = dataSaver.getDate("dateFirstBoot")
        return dateFirstBoot
    }
    
     public func saveDateRemindMeLater()
    {
          dataSaver.saveDate(NSDate(), key: "dateRemindMeLater")
    }

    func shouldRateForPassedDaysSinceStart() -> Bool
    {
        return (Int(dateFirstBoot.timeIntervalSinceNow) >= rateSetup.timeSetup.daysUntilPrompt)
    }
    
    func shouldRateForNumberOfUses() -> Bool
    {
        return usesNumber >= rateSetup.timeSetup.usesUntilPrompt
    }
    
    func shouldRateForPassedDaysSinceRemindMeLater() -> Bool
    {
        return rateSetup.timeSetup.remindPeriod < Int(dataSaver.getDate("dateRemindMeLater").timeIntervalSinceNow)
    }
    
    func releasedNewVersionApp() -> Bool
    {
        return rateSetup.timeSetup.rateNewVersionsIndipendently == true
    }
    
    func appNotRated() -> Bool {
        return dataSaver.getBoolForKey("rated") == false
    }
    
    func getRatingAlertControllerIfNeeded() -> UIAlertController?
    {
        let shouldRate = shouldRateForPassedDaysSinceStart() ||
            shouldRateForNumberOfUses() ||
            shouldRateForPassedDaysSinceRemindMeLater()
        
        guard shouldRate && appNotRated() else { return nil }
        
        let alertController = UIAlertController(
            title: rateSetup.textsSetup.alertTitle,
            message: rateSetup.textsSetup.alertMessage,
            preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(
            title: rateSetup.textsSetup.rateButtonTitle,
            style: .Default,
            handler: ignoreInput(voteNowOnAppStore)))
        
        alertController.addAction( UIAlertAction(
            title: rateSetup.textsSetup.remindButtonTitle,
            style: .Default,
            handler: ignoreInput(saveDateRemindMeLater)))
        
        alertController.addAction(UIAlertAction(
            title: rateSetup.textsSetup.ignoreButtonTitle,
            style: .Default,
            handler: { [weak self] _ in self?.dataSaver.saveBool(true, key: "rated") }))

        return alertController
    }
    
}

    func ignoreInput<T>(function: () -> ()) -> T -> ()
    {
    return { _ in function() }
    }













