# Framework Installation #

### [Swift Package Manager] ###

[Swift Package Manager]: https://swift.org/package-manager/

Add this as a package dependency in Xcode:

```
https://github.com/thoughtbot/Runes
```

Or add it as a dependency in your Package.swift file:

```swift
dependencies: [
  .package(url: "https://github.com/thoughtbot/Runes", from: "5.0.0"),
]
```

## [Carthage] ##

[Carthage]: https://github.com/Carthage/Carthage

```
github "thoughtbot/Runes"
```

Then run `carthage update`.

Follow the current instructions in [Carthage's README][carthage-installation]
for up to date installation instructions.

[carthage-installation]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

## [CocoaPods] ##

[CocoaPods]: http://cocoapods.org

Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```ruby
pod 'Runes'
```

You will also need to make sure you're opting into using frameworks:

```ruby
use_frameworks!
```

Then run `pod install` with CocoaPods 0.36 or newer.

