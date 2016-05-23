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
        rateNewVersionIndipendency: false)
    
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
    
    rate.saveParametersNewReleaseApp()
    
    XCTAssertEqual(dataSaverMock.lastSavedIntValue, 1)
    XCTAssertEqual(dataSaverMock.lastSavedKey, "usesNumber")
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
        rate.saveParametersNewReleaseApp()
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        guard let dataValue = dataSaverMock.lastSavedDateValue else {return}
        let componentsMock = calendar.components([.Day, .Month, .Year], fromDate: dataValue)
        
        rate.saveParametersNewReleaseApp()
        let yearMock = componentsMock.year
        let monthMock = componentsMock.month
        let dayMock = componentsMock.day
        let currentYear =  components.year
        let currentMonth = components.month
        let currentDay = components.day
        
        XCTAssertEqual(yearMock, currentYear)
        XCTAssertEqual(monthMock, currentMonth)
        XCTAssertEqual(dayMock, currentDay)
        XCTAssertEqual("usesNumber", dataSaverMock.lastSavedKey)
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
        
        rate.updateUsesNumber()
        XCTAssertEqual("usesNumber", dataSaverMock.lastSavedKey)
        XCTAssertEqual(dataSaverMock.lastSavedIntValue, 1)
        rate.usesNumber = 4
        rate.updateUsesNumber()
        XCTAssertEqual(dataSaverMock.lastSavedIntValue, 5)
        XCTAssertEqual("usesNumber", dataSaverMock.lastSavedKey)
    }
    
    func testVoteDone()
    {
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)
        
        let dataSaverMock = DataSaverMock()
        
        
        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        
        rate.voteDone()
        XCTAssertEqual(dataSaverMock.lastSavedKey, "rated")
        XCTAssertEqual(dataSaverMock.getBoolForKey("rated"), false)
    }
    
    func testSaveDateFirstBoot()
    {
        let shouldBeLess = NSDate()
        
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)
        
        let dataSaverMock = DataSaverMock()
        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        
        rate.usesNumber = 1
        rate.saveDateFirstBoot()
        XCTAssertEqual(dataSaverMock.lastSavedKey, "dateFirstBoot")
        let shouldBeMiddle = dataSaverMock.lastSavedDateValue
        let shouldBeGreater = NSDate()
        var resultDate: Bool = false
        guard  let shouldBeMiddleNoOpt = shouldBeMiddle else {return}
        
        if(shouldBeLess.earlierDate(shouldBeMiddleNoOpt) == shouldBeLess && shouldBeGreater.laterDate(shouldBeMiddleNoOpt) == shouldBeGreater)
        {
             resultDate = true
        }
        else {resultDate = false}
       
        XCTAssertEqual(resultDate, true)
    }
    
    
    func testGetDateFirstBoot()
    {
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)
        
        let dataSaverMock = DataSaverMock()
        
        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        rate.getDateFirstBoot()
        
        XCTAssertEqual(dataSaverMock.lastSavedKey, "dateFirstBoot")
        
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
        XCTAssertEqual("dateRemindMeLater", dataSaverMock.lastSavedKey)
    }
    
    func testShouldRateForPassedDaysSinceStart()
    {
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)
        
        let dataSaverMock = DataSaverMock()
        
        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        XCTAssertEqual(rate.shouldRateForPassedDaysSinceStart(), false)
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
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)
        
        let dataSaverMock = DataSaverMock()
        
        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        XCTAssertEqual(rate.shouldRateForPassedDaysSinceRemindMeLater(), false)
    }
    
    func testReleaseNewVersionApp()
    {
        let rateSetupMock = MockRateSetup(
            urlString: "",
            timeSetup: ratingTimeSetup,
            textSetup: ratingTextSetup)
        
        let dataSaverMock = DataSaverMock()
        
        let rate = Rate(rateSetup: rateSetupMock,
                        dataSaver: dataSaverMock,
                        openUrl: urlMock)
        XCTAssertEqual(rate.releasedNewVersionApp(), false)
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
        rate.appNotRated()
        XCTAssertEqual(dataSaverMock.lastSavedKey, "rated")
    }
    
    func testGetRatingAlertControllerIfNeeded_Passed()
    {
        let ratingTimeSetup = RatingTimeSetup(
            daysUntilPrompt: 0,
            usesUntilPrompt: 0,
            remindPeriod: 0,
            rateNewVersionIndipendency: false)
        
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
    }
}

