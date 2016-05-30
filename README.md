## Purpose
Rate is a library to help you promote your iPhone apps by prompting users to rate the app after using it for a few days. This approach is one of the best ways to get positive app reviews by targeting only regular users (who presumably like the app or they wouldn't keep using it!).

## Supported OS 
Supported build target - iOS 9.0  (Xcode 7.3.1)

## Usage
The `Rate` class is highly decoupled from functionalities like URL opening, alert presentation and data persistence: the class will only take care of the logic needed to calculate if the rate app prompt should be shown to the user or not.

To inject the dependencies, three protocols are used.

#### `RateSetupType`
This protocol is simply used to describe an object that will contain the entire *setup* for the `Rate` class, that is, duration values, texts, and the App Store url string for the app.

#### `DataSaverType`
This protocol is used by `Rate` to handle data persistence: the type that will be extended with this protocol should be able to *save* a *retrieve* objects of type `Int`, `Bool`, `String` and `NSDate` in correspondence to some `String` key. It should also be able to reset those values.

Because the data that will be saved is not complex, nor huge in size, `NSUserDefaults` could be good candidate to be extended with this protocol.

#### `URLOpenerType`
This protocol describes a generic type that can handle the opening of `NSURL` objects; the protocol is designed to make `UIApplication` extendable with no additional work, you just need to add a empty extension to `UIApplication` like this:

```swift
extension UIApplication: URLOpenerType {}
```
