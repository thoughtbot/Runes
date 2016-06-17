<img src="https://raw.githubusercontent.com/thoughtbot/Runes/gh-pages/Logo.png" width="200" />

Indecipherable symbols that some people claim have actual meaning.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Version Compatibility ##

Note that we're aggressive about pushing `master` forward along with new
versions of Swift. Therefore, we highly recommend against pointing at
`master`, and instead using [one of the releases we've provided][releases].

Here is the current Swift compatibility breakdown:

| Swift Version | Runes Version |
| ------------- | ------------- |
| 3.X           | master        |
| 2.X           | 3.X           |
| 1.2           | 1.2, 2.X      |
| 1.1           | < 1.2         |

[releases]: https://github.com/thoughtbot/Runes/releases

## Framework Installation ##

### [Carthage] ###

[Carthage]: https://github.com/Carthage/Carthage

```
github "thoughtbot/Runes"
```

Then run `carthage update`.

Follow the current instructions in [Carthage's README][carthage-installation]
for up to date installation instructions.

[carthage-installation]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

### [CocoaPods] ###

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

## Adding Runes as a Framework Dependency ##

If you're a framework author, you might define your own custom types that
would benefit from the operators defined in Runes. However, adding the entire
Runes framework as a dependency might be too much overhead. In this case, you
can use Carthage, CocoaPods, or Git to link to the file that defines the
operators directly into your project. This will let you use Runes as a
centralized dependency for the definition of the operators without needing to
worry about additional overhead for your users.

By using Runes as a dependency in this way, it will be easier to ensure
compatibility between your operator definitions and other types. This will
also reduce the amount of duplication of effort across projects that want to
include the same kinds of functionality.

In order to use Runes as a framework dependency, you must use git submodules.
This will allow Carthage and CocoaPods to pull down the Runes source code
without needing to expose the dependency to your users.

### [Carthage] ###

Add the following to `Cartfile.private`:

```
github "thoughtbot/Runes"
```

Then run `carthage update --no-use-binaries --use-submodules`. This will
ensure that you don't get any pre-built binaries that we are providing for
users who want the full `Runes.framework`, and will tell Carthage to set up a
git submodule for you.

Once you've checked out the required version, you can link
`Carthage/Checkouts/Runes/Source/Runes.swift` directly into your framework.

### [CocoaPods] ###

After adding Runes as a git submodule, you will need to modify your podspec to
tell CocoaPods to pull down your submodule dependencies. This is done by
passing a `submodules: true` flag inside your spec's `source` property.

For example, the `source` for [Argo]'s main spec would look like this:

```ruby
spec.source = {
  git: "https://github.com/thoughtbot/Argo.git",
  tag: "v#{s.version}",
  submodules: true # add this line
}
```

Then add `Runes.swift` to your spec's `source_files` property. This tells
CocoaPods to include that file when building your framework.

Again, using Argo as an example, we can make our `source_files` property look
like so:

```ruby
spec.source_files = 'Argo/**/*.{h,swift}', 'Carthage/Checkouts/Runes/Source/Runes.swift'
```

## What's included? ##

Importing Runes introduces several new operators and one global function:

- `<^>` (pronounced "map")
- `<*>` (pronounced "apply")
- `>>-` (pronounced "flatMap") (left associative)
- `-<<` (pronounced "flatMap") (right associative)
- `pure` (pronounced "pure")
- `>->` (pronounced "Monadic compose") (left associative)
- `<-<` (pronounced "Monadic compose") (right associative)

We also include default implementations for Optional and Array with the
following type signatures:

```swift
// Optional:
public func <^><T, U>(f: T -> U, a: T?) -> U?
public func <*><T, U>(f: (T -> U)?, a: T?) -> U?
public func >>-<T, U>(a: T?, f: T -> U?) -> U?
public func -<<<T, U>(f: T -> U?, a: T?) -> U?
public func pure<T>(a: T) -> T?
public func >-> <A, B, C>(f: A -> B?, g: B -> C?) -> A -> C?
public func <-< <A, B, C>(f: B -> C?, g: A -> B?) -> A -> C?

// Array:
public func <^><T, U>(f: T -> U, a: [T]) -> [U]
public func <*><T, U>(fs: [T -> U], a: [T]) -> [U]
public func >>-<T, U>(a: [T], f: T -> [U]) -> [U]
public func -<<<T, U>(f: T -> [U], a: [T]) -> [U]
public func pure<T>(a: T) -> [T]
public func >-> <A, B, C>(f: A -> [B], g: B -> [C]) -> A -> [C]
public func <-< <A, B, C>(f: B -> [C], g: A -> [B]) -> A -> [C]
```

Contributing
------------

See the [CONTRIBUTING] document. Thank you, [contributors]!

[CONTRIBUTING]: CONTRIBUTING.md
[contributors]: https://github.com/thoughtbot/Runes/graphs/contributors

License
-------

Runes is Copyright (c) 2015 thoughtbot, inc. It is free software, and may be
redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE

About
-----

![thoughtbot](https://thoughtbot.com/logo.png)

Runes is maintained and funded by thoughtbot, inc. The names and logos for
thoughtbot are trademarks of thoughtbot, inc.

We love open source software! See [our other projects][community] or look at
our product [case studies] and [hire us][hire] to help build your iOS app.

[community]: https://thoughtbot.com/community?utm_source=github
[case studies]: https://thoughtbot.com/ios?utm_source=github
[hire]: https://thoughtbot.com/hire-us?utm_source=github
