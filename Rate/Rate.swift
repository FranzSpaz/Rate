import Foundation

public class Rate {
	let currentVersionKey = "currentVersion"
	let usesNumberKey = "usesNumber"
	let tappedRemindMeLaterKey = "tappedRemindMeLater"
	let ratedKey = "rated"
	let dateFirstBootKey = "dateFirstBoot"
	let dateRemindMeLaterKey = "dateRemindMeLater"

	let rateSetup: RateSetupType
	let dataSaver: DataSaverType
	let urlOpener: URLOpener

	public init(rateSetup: RateSetupType,
	            dataSaver: DataSaverType,
	            openUrl: URLOpener) {
		self.rateSetup = rateSetup
		self.dataSaver = dataSaver
		self.urlOpener = openUrl
	}

	public func updateForRelease(appVersion: String, date: NSDate) {
		if let currentVersion = dataSaver.getStringForKey(currentVersionKey) where currentVersion == appVersion {
			let currentUsesNumber = dataSaver.getIntForKey(usesNumberKey) ?? 0
			dataSaver.saveInt(currentUsesNumber + 1, key: usesNumberKey)
		} else {
			let hasNoVersion = dataSaver.getStringForKey(currentVersionKey) == nil
			let shouldResetRemindMeLater = hasNoVersion || rateSetup.timeSetup.rateNewVersionsIndipendently
			if shouldResetRemindMeLater {
				dataSaver.saveBool(false, key: tappedRemindMeLaterKey)
			}
			dataSaver.saveString(appVersion, key: currentVersionKey)
			dataSaver.saveInt(1, key: usesNumberKey)
			resetRatedForNewVersionIfNeeded()
			updateDateFirstBootIfNeeded(date)
		}
	}

	public func getRatingAlertControllerIfNeeded() -> UIAlertController? {
		guard checkShouldRate() && appNotRated() else {
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
			handler:ignoreInput(ignoreRating)))

		return alertController
	}

	public func reset() {
		dataSaver.resetValueForKey(currentVersionKey)
		dataSaver.resetValueForKey(usesNumberKey)
		dataSaver.resetValueForKey(tappedRemindMeLaterKey)
		dataSaver.resetValueForKey(ratedKey)
		dataSaver.resetValueForKey(dateFirstBootKey)
		dataSaver.resetValueForKey(dateRemindMeLaterKey)
	}

	//MARK: - private logic

	func ignoreRating() {
		setRated(true)
	}

	func setRated(value: Bool) {
		self.dataSaver.saveBool(value, key: self.ratedKey)
	}

	func checkShouldRate() -> Bool {
		switch dataSaver.getBoolForKey(tappedRemindMeLaterKey) {
		case true?:
			return shouldRateForPassedDaysSinceRemindMeLater()
		default:
			return shouldRateForNumberOfUses()
				|| shouldRateForPassedDaysSinceStart()
		}
	}

	func resetRatedForNewVersionIfNeeded() {
		let rateNewVersions = rateSetup.timeSetup.rateNewVersionsIndipendently
		guard rateNewVersions else { return }
		setRated(false)
	}

	func updateDateFirstBootIfNeeded(date: NSDate) {
		let noDate = dataSaver.getDateForKey(dateFirstBootKey) == nil
		let rateNewVersions = rateSetup.timeSetup.rateNewVersionsIndipendently
		guard noDate || rateNewVersions else { return }
		dataSaver.saveDate(date, key: dateFirstBootKey)
	}

	func getUsesNumber() -> Int {
		return dataSaver.getIntForKey(usesNumberKey) ?? 0
	}

	func saveDateRemindMeLater() {
		dataSaver.saveDate(NSDate(), key: dateRemindMeLaterKey)
		dataSaver.saveBool(true, key: tappedRemindMeLaterKey)
	}

	func voteNowOnAppStore() {
		guard let url = NSURL(string: rateSetup.appStoreUrlString) else { return }
		setRated(true)
		urlOpener.openURL(url)
	}

	func shouldRateForPassedDaysSinceStart() -> Bool {
		if let timeInterval = dataSaver.getDateForKey(dateFirstBootKey)?.timeIntervalSinceNow {
			return (-timeInterval) >= Double(rateSetup.timeSetup.daysUntilPrompt*3600*24)
		} else {
			return false
		}
	}

	func shouldRateForNumberOfUses() -> Bool {
		return getUsesNumber() >= rateSetup.timeSetup.usesUntilPrompt
	}

	func shouldRateForPassedDaysSinceRemindMeLater() -> Bool {
		if let timeInterval = dataSaver.getDateForKey(dateRemindMeLaterKey)?.timeIntervalSinceNow {
			return (-timeInterval) >= Double(rateSetup.timeSetup.remindPeriod*3600*24)
		} else {
			return false
		}
	}

	func appNotRated() -> Bool {
		if let rated = dataSaver.getBoolForKey(ratedKey) {
			return rated == false
		} else {
			return true
		}
	}
}
