# FireworkVideoUI

An extension library meant to provide easier interfaces for the [FireworkVideoSDK](https://github.com/loopsocial/firework_ios_sdk).

## Setup Prerequisites

Proceed with FireworkVideo integration steps before integrating the extensions library.

### FireworkVideo SDK Documentation

This extension library is intended to be used alongside FireworkVideoSDK. Read over the [FireworkVideo SDK documentation](https://docs.firework.tv/ios-sdk/integration-guide-for-ios-sdk) to ensure proper FireworkVideoSDK integration.

## Installation

### [Swift Package Manager](https://www.swift.org/package-manager/) **- RECOMMENDED**

In your Xcode project, select File > Add Packages... and enter the following URL: 
```
https://github.com/loopsocial/firework_ios_sdk_ui_extensions/
```

### Copy & Paste

Most of the extensions are standalone and can be simply copied and pasted into your codebase.

## Getting Started

It is recommended to checkout the [Example project](https://github.com/loopsocial/firework_ios_sdk_ui_extensions/tree/master/Example) to get a look at what 
can be accomplished with these extensions.

## VideoFeedView

The `VideoFeedView` provides a `UIView` wrapper of the `FireworkVideoSDK.VideoFeedViewController`. This eliminates the need to manage a child `UIViewController`. You can customize the `VideoFeedView` just like the `VideoFeedViewController`.

However, this solution makes a lot of assumptions about the view hiearchy that may lead to unusual behavior for highly customized view setups. 
Additionally, when the view is nested in a `UIScrollView` type it will need to observe the bounds in order to properly manage the underlying `VideoFeedViewController`.

Checkout the example project to see examples of how to use the `VideoFeedView` in both a `UITableView` and a `UICollectionView`.

## App-level language setting

```swift
import FireworkVideoUI
AppLanguageManager.shared.changeAppLanguage("ar") // such as ar, ar-JO, en, etc.
```

Generally, the `changeAppLanguage` API should be called in the following cases:
  1. The App is launched(e.g. in the `application(:, didFinishLaunchingWithOptions:) -> Bool` method).
  2. Users change the app language manually.
  3. Other cases that change app language.

After calling `changeAppLanguage` API, we need to recreate FireworkVideo SDK components to update the UI. Such as:
  - Recreate video feed and story block
  - Stop floating player
