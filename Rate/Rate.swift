import Foundation

public class Rate
{
    let rateSetup: RateSetupType
    let dataSaver: DataSaverType
    let urlOpener: UrlOpener

    public init(rateSetup: RateSetupType,
                dataSaver: DataSaverType,
                openUrl: UrlOpener)
    {
        self.rateSetup = rateSetup
        self.dataSaver = dataSaver
        self.urlOpener = openUrl
    }

    public func updateForRelease(appVersion: String, date: NSDate)
    {
        if let currentVersion = dataSaver.getString("currentVersion") where currentVersion == appVersion {
            let currentUsesNumber = dataSaver.getIntForKey("usesNumber") ?? 0
            dataSaver.saveInt(currentUsesNumber + 1, key: "usesNumber")
        } else {
            dataSaver.saveString(appVersion, key: "currentVersion")
            dataSaver.saveInt(1, key: "usesNumber")
            updateDateFirstBootIfNeeded(date)
        }
    }

    public func getRatingAlertControllerIfNeeded() -> UIAlertController?
    {
        let shouldRate = shouldRateForPassedDaysSinceStart() ||
            shouldRateForNumberOfUses() ||
            shouldRateForPassedDaysSinceRemindMeLater()

        guard shouldRate && appNotRated() else {
            return nil
        }

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

    func updateDateFirstBootIfNeeded(date: NSDate)
    {
        let noDate = dataSaver.getDate("dateFirstBoot") == nil
        let rateNewVersions = rateSetup.timeSetup.rateNewVersionsIndipendently
        guard noDate || rateNewVersions else { return }
        
        dataSaver.saveDate(date, key: "dateFirstBoot")
    }

    func getUsesNumber() -> Int
    {
        return dataSaver.getIntForKey("usesNumber") ?? 0
    }

    public func saveDateRemindMeLater()
    {
        dataSaver.saveDate(NSDate(), key: "dateRemindMeLater")
    }

    func voteNowOnAppStore()
    {
        guard let urlNoOpt = NSURL(string: rateSetup.appStoreUrlString) else { return }
        urlOpener.openUrl(urlNoOpt)
    }

    func shouldRateForPassedDaysSinceStart() -> Bool
    {
        if let timeInterval = dataSaver.getDate("dateFirstBoot")?.timeIntervalSinceNow {
            return Int(timeInterval) >= rateSetup.timeSetup.daysUntilPrompt
        } else {
            return false
        }
    }

    func shouldRateForNumberOfUses() -> Bool
    {
        return getUsesNumber() >= rateSetup.timeSetup.usesUntilPrompt
    }

    func shouldRateForPassedDaysSinceRemindMeLater() -> Bool
    {
        if let timeInterval = dataSaver.getDate("dateRemindMeLater")?.timeIntervalSinceNow {
            return Int(timeInterval) >= rateSetup.timeSetup.remindPeriod
        } else {
            return false
        }
    }

    func appNotRated() -> Bool
    {
        if let rated = dataSaver.getBoolForKey("rated") {
            return rated
        } else {
            return true
        }
    }
}
