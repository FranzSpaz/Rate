public struct RatingTimeSetup
{
    let daysUntilPrompt: Int
    let usesUntilPrompt: Int
    let remindPeriod: Int
    let rateNewVersionsIndipendently: Bool

    public init(daysUntilPrompt: Int, usesUntilPrompt: Int, remindPeriod: Int, rateNewVersionIndipendently: Bool)
    {
        self.daysUntilPrompt = daysUntilPrompt
        self.rateNewVersionsIndipendently = rateNewVersionIndipendently
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
