import XCTest
import Foundation
@testable import Rate

class RateTests: XCTestCase
{
    let urlMock = UrlOpenerMock()

    let ratingTimeSetup = RatingTimeSetup(
        daysUntilPrompt: 2,
        usesUntilPrompt: 2,
        remindPeriod: 2,
        rateNewVersionIndipendently: false)

    let ratingTextSetup = RatingTextSetup(
        alertTitle: "",
        alertMessage: "",
        rateButtonTitle: "",
        remindButtonTitle: "",
        ignoreButtonTitle: "")

    func testSaveParametersNewReleaseApp_saveInt()
    {

        let dataSaverMock = DataSaverMock()

        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)

        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)

        rate.updateForRelease("", date: NSDate())

        XCTAssertEqual(dataSaverMock.getIntForKey(rate.usesNumberKey), 1)
    }


    func testSaveParametersNewReleaseApp_saveDate()
    {
        let dataSaverMock = DataSaverMock()
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)

        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)

        let expectedDate = NSDate()
        rate.updateForRelease("", date: expectedDate)

        XCTAssertEqual(dataSaverMock.getDateForKey(rate.dateFirstBootKey), expectedDate)
    }

    func testGetUsesNumber()
    {
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)

        let dataSaverMock = DataSaverMock()

        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
		dataSaverMock.saveInt(101, key: rate.usesNumberKey)

        XCTAssertEqual(101, rate.getUsesNumber())
    }

    func testUpdateUsesNumber()
    {
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)

        let dataSaverMock = DataSaverMock()

        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)

        rate.updateForRelease("", date: NSDate())
  
        XCTAssertEqual(dataSaverMock.getIntForKey(rate.usesNumberKey), 1)
        rate.updateForRelease("", date: NSDate())
        rate.updateForRelease("", date: NSDate())
        rate.updateForRelease("", date: NSDate())
        rate.updateForRelease("", date: NSDate())
        XCTAssertEqual(dataSaverMock.getIntForKey(rate.usesNumberKey), 5)
    }

    func testSaveDateFirstBoot()
    {
        let expectedDate = NSDate()

        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)

        let dataSaverMock = DataSaverMock()
        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)

        rate.updateForRelease("", date: expectedDate)
    
        XCTAssertEqual(dataSaverMock.getDateForKey(rate.dateFirstBootKey), expectedDate)
    }

    func testSaveDateRemindMeLater()
    {
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)

        let dataSaverMock = DataSaverMock()

        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        rate.saveDateRemindMeLater()
    }

    func testShouldRateForPassedDaysSinceStart()
    {
        let ratingTimeSetup = RatingTimeSetup(
            daysUntilPrompt: 0,
            usesUntilPrompt: 0,
            remindPeriod: 0,
            rateNewVersionIndipendently: false)
        
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)

        let dataSaverMock = DataSaverMock()

        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        XCTAssertEqual(rate.shouldRateForPassedDaysSinceStart(), false)
        dataSaverMock.saveDate(NSDate(), key: rate.dateFirstBootKey)
        XCTAssertEqual(rate.shouldRateForPassedDaysSinceStart(), true)
    }

    func testShouldRateForNumberOfUses()
    {
        
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)

        let dataSaverMock = DataSaverMock()

        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        XCTAssertEqual(rate.shouldRateForNumberOfUses(), false)
    }

    func testShoulRateForPassedDaysSinceRemindMeLater()
    {
        let ratingTimeSetup = RatingTimeSetup(
            daysUntilPrompt: 0,
            usesUntilPrompt: 0,
            remindPeriod: 0,
            rateNewVersionIndipendently: false)

        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)

        let dataSaverMock = DataSaverMock()

        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        
        XCTAssertEqual(rate.shouldRateForPassedDaysSinceRemindMeLater(), false)
        dataSaverMock.saveDate(NSDate(), key: rate.dateRemindMeLaterKey)
        XCTAssertEqual(rate.shouldRateForPassedDaysSinceRemindMeLater(), true)
    }

    func testAppNotRated()
    {
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)

        let dataSaverMock = DataSaverMock()

        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        XCTAssertTrue(rate.appNotRated())
        dataSaverMock.saveBool(false, key: "rated")
        XCTAssertEqual(rate.appNotRated(), false)
    }

    func testCheckShouldRate()
    {
        let ratingTimeSetup = RatingTimeSetup(
            daysUntilPrompt: 0,
            usesUntilPrompt: 20,
            remindPeriod: 0,
            rateNewVersionIndipendently: false)
        
        let ratingTextSetup = RatingTextSetup(
            alertTitle: "alert",
            alertMessage: "vuoi votare?",
            rateButtonTitle: "vota",
            remindButtonTitle: "non ora",
            ignoreButtonTitle: "ignora")
        
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)
        
        let dataSaverMock = DataSaverMock()
        
        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        
        dataSaverMock.saveBool(false, key: rate.tappedRemindMeLaterKey)
        dataSaverMock.saveDate(NSDate(), key: rate.dateFirstBootKey)
        XCTAssertEqual(rate.checkShouldRate(), true)
        dataSaverMock.saveBool(true, key: rate.tappedRemindMeLaterKey)
        dataSaverMock.saveDate(NSDate(), key: rate.dateRemindMeLaterKey)
        XCTAssertEqual(rate.checkShouldRate(), true)
}
    
    func testGetRatingAlertControllerIfNeeded_Passed()
    {
        let ratingTimeSetup = RatingTimeSetup(
            daysUntilPrompt: 0,
            usesUntilPrompt: 0,
            remindPeriod: 0,
            rateNewVersionIndipendently: false)

        let ratingTextSetup = RatingTextSetup(
            alertTitle: "alert",
            alertMessage: "vuoi votare?",
            rateButtonTitle: "vota",
            remindButtonTitle: "non ora",
            ignoreButtonTitle: "ignora")

        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)

        let dataSaverMock = DataSaverMock()

        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        dataSaverMock.saveBool(true, key: "rated")
        dataSaverMock.saveBool(false, key: rate.tappedRemindMeLaterKey)
        let alertController = rate.getRatingAlertControllerIfNeeded()
        XCTAssertNotNil(alertController)
        XCTAssertEqual(alertController?.title, "alert")
        XCTAssertEqual(alertController?.message, "vuoi votare?")
        XCTAssertEqual(alertController?.preferredStyle, .Alert)
        XCTAssertEqual(alertController?.actions[0].title, "vota")
        XCTAssertEqual(alertController?.actions[0].style, .Default)
        XCTAssertEqual(alertController?.actions[1].title, "non ora")
        XCTAssertEqual(alertController?.actions[1].style, .Default)
        XCTAssertEqual(alertController?.actions[2].title, "ignora")
        XCTAssertEqual(alertController?.actions[2].style, .Default)
    }

    func testGetRatingAlertControllerIfNeeded_NotPassed()
    {

        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)

        let dataSaverMock = DataSaverMock()

        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        dataSaverMock.saveBool(false, key: "rated")
        XCTAssertEqual(rate.getRatingAlertControllerIfNeeded(), nil)
    }

    func testVoteNowOnAppStore()
    {
        let urlCompare = NSURL(string: "http://www.facile.it")
        let rateSetupMock = MockRateSetup(
            urlString: "http://www.facile.it",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)

        let dataSaverMock = DataSaverMock()

        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        rate.voteNowOnAppStore()
        XCTAssertEqual(urlCompare, urlMock.simpleUrl)
        urlMock.simpleUrl = nil
        rate.voteNowOnAppStore()
    }

    
    func testUpdateForRelease()
    {
        let ratingTimeSetup = RatingTimeSetup(daysUntilPrompt: 2,
                                              usesUntilPrompt: 2,
                                              remindPeriod: 2,
                                              rateNewVersionIndipendently: true)
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)
        
        let dataSaverMock = DataSaverMock()
        
        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        dataSaverMock.saveString("2.2.2", key: "currentVersion")
        rate.updateForRelease("2.2.2", date: NSDate())
        XCTAssertEqual(dataSaverMock.getIntForKey(rate.usesNumberKey), 1)
        dataSaverMock.saveString("1.1.1", key: "currentVersion")
        rate.updateForRelease("1.2.1", date: NSDate())
        dataSaverMock.saveString("1.1.2", key: "currentVersion")
        rate.updateForRelease("1.1.4", date: NSDate())
        XCTAssertEqual(dataSaverMock.getBoolForKey(rate.tappedRemindMeLaterKey), false)
    }
    
    func testUpdateDateFirstBootIfNeeded()
    {
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)
        
        let dataSaverMock = DataSaverMock()
        
        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        let date = NSDate()
        dataSaverMock.saveDate(date, key: rate.dateFirstBootKey)
        let newDate = NSDate()
        rate.updateDateFirstBootIfNeeded(newDate)
        XCTAssertNotEqual(dataSaverMock.getDateForKey(rate.dateFirstBootKey), newDate)
    }

	func testResetAll() {
		let rateSetupMock = MockRateSetup(
			urlString: "",
			timeSetup: ratingTimeSetup,
			textSetup: ratingTextSetup)

		let dataSaverMock = DataSaverMock()

		let rate = Rate(rateSetup: rateSetupMock,
		                dataSaver: dataSaverMock,
		                openUrl: urlMock)

		let expectedDate = NSDate()

		dataSaverMock.saveString("12345", key: rate.currentVersionKey)
		dataSaverMock.saveInt(3, key: rate.usesNumberKey)
		dataSaverMock.saveBool(true, key: rate.tappedRemindMeLaterKey)
		dataSaverMock.saveBool(true, key: rate.ratedKey)
		dataSaverMock.saveDate(expectedDate, key: rate.dateFirstBootKey)
		dataSaverMock.saveDate(expectedDate, key: rate.dateRemindMeLaterKey)

		rate.reset()

		XCTAssertNil(dataSaverMock.getStringForKey(rate.currentVersionKey))
		XCTAssertNil(dataSaverMock.getIntForKey(rate.usesNumberKey))
		XCTAssertNil(dataSaverMock.getBoolForKey(rate.tappedRemindMeLaterKey))
		XCTAssertNil(dataSaverMock.getBoolForKey(rate.ratedKey))
		XCTAssertNil(dataSaverMock.getDateForKey(rate.dateFirstBootKey))
		XCTAssertNil(dataSaverMock.getDateForKey(rate.dateRemindMeLaterKey))
	}
}
