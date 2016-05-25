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

        XCTAssertEqual(dataSaverMock.getIntForKey("usesNumber"), 1)
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

        XCTAssertEqual(dataSaverMock.getDate("dateFirstBoot"), expectedDate)
    }

    func testGetUsesNumber()
    {
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)

        let dataSaverMock = DataSaverMock()
        dataSaverMock.saveInt(101, key: "intKey")

        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        rate.getUsesNumber()

        XCTAssertEqual(101, dataSaverMock.getIntForKey("intKey"))
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
  
        XCTAssertEqual(dataSaverMock.getIntForKey("usesNumber"), 1)
        rate.updateForRelease("", date: NSDate())
        rate.updateForRelease("", date: NSDate())
        rate.updateForRelease("", date: NSDate())
        rate.updateForRelease("", date: NSDate())
        XCTAssertEqual(dataSaverMock.getIntForKey("usesNumber"), 5)
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
    
        XCTAssertEqual(dataSaverMock.getDate("dateFirstBoot"), expectedDate)
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
        dataSaverMock.saveDate(NSDate(), key: "dateFirstBoot")
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
        dataSaverMock.saveDate(NSDate(), key: "dateRemindMeLater")
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
        
        dataSaverMock.saveBool(false, key: "tappedRemindMeLater")
        dataSaverMock.saveDate(NSDate(), key: "dateFirstBoot")
        XCTAssertEqual(rate.checkShouldRate(), true)
        dataSaverMock.saveBool(true, key: "tappedRemindMeLater")
        dataSaverMock.saveDate(NSDate(), key: "dateRemindMeLater")
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
        dataSaverMock.saveBool(false, key: "tappedRemindMeLater")
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
        XCTAssertEqual(dataSaverMock.getIntForKey("usesNumber"), 1)
        dataSaverMock.saveString("1.1.1", key: "currentVersion")
        rate.updateForRelease("1.2.1", date: NSDate())
        dataSaverMock.saveString("1.1.2", key: "currentVersion")
        rate.updateForRelease("1.1.4", date: NSDate())
        XCTAssertEqual(dataSaverMock.getBoolForKey("tappedRemindMeLater"), false)
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
        dataSaverMock.saveDate(date, key: "dateFirstBoot")
        let newDate = NSDate()
        rate.updateDateFirstBootIfNeeded(newDate)
        XCTAssertNotEqual(dataSaverMock.getDate("dateFirstBoot"), newDate)
    }
}
