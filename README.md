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

### Cocoapods

Add `pod FireworkVideoUI` in your Podfile and then run `pod install`.

### Copy & Paste

Most of the extensions are standalone and can be simply copied and pasted into your codebase.

## Getting Started

It is recommended to checkout the [Sample project](https://github.com/loopsocial/firework_ios_sdk_ui_extensions/tree/main/Sample) to get a look at what
can be accomplished with these extensions.

### How to run the sample project

1. Get the Firework app ID from our business team.
2. In `./Sample/SampleApp/Info.plist`, set the value of FireworkVideoAppID key to the Firework app ID.
3. Run `./Sample/SampleApp.xcodeproj` using Xcode.

## VideoFeedView

The `VideoFeedView` provides a `UIView` wrapper of the `FireworkVideo.VideoFeedViewController`. You can customize the `VideoFeedView` just like the `FireworkVideo.VideoFeedViewController`.

```swift
import FireworkVideo
import FireworkVideoUI

let videoFeedView = VideoFeedView(source: source)
videoFeedView.delegate = self
var viewConfiguration = VideoFeedContentConfiguration()
viewConfiguration.itemView.autoplay.isEnabled = true
viewConfiguration.playerView.playbackButton.isHidden = false
videoFeedView.viewConfiguration = viewConfiguration
```

## StoryBlockView

The `StoryBlockView` provides a `UIView` wrapper of the `FireworkVideo.StoryBlockViewController`. You can customize the `StoryBlockView` just like the `FireworkVideo.StoryBlockViewController`.

```swift
import FireworkVideo
import FireworkVideoUI

let storyBlockView = StoryBlockView(source: source)
storyBlockView.delegate = self
var viewConfiguration = StoryBlockConfiguration()
viewConfiguration.playbackButton.isHidden = false
viewConfiguration.fullScreenPlayerView.playbackButton.isHidden = false
storyBlockView.viewConfiguration = viewConfiguration
```

## VideoFeedSwiftUIView

The `VideoFeedSwiftUIView` provides a SwiftUI View wrapper of the `FireworkVideo.VideoFeedViewController`. You can customize the `VideoFeedSwiftUIView` just like the `FireworkVideo.VideoFeedViewController`.

```swift
import FireworkVideo
import FireworkVideoUI

var viewConfiguration = VideoFeedContentConfiguration()
viewConfiguration.itemView.autoplay.isEnabled = true
viewConfiguration.playerView.playbackButton.isHidden = false

VideoFeedSwiftUIView(
  source: .channelPlaylist(channelID: "bJDywZ", playlistID: "g206q5"),
  viewConfiguration: viewConfiguration,
  isPictureInPictureEnabled: true,
  onVideoFeedLoaded: {
      debugPrint("Video feed loaded successfully.")
  },
  onVideoFeedFailedToLoad: { error in
      debugPrint("Video feed did fail loading with error: \(error.localizedDescription)")
  }
)
```

## StoryBlockSwiftUIView

The `StoryBlockSwiftUIView` provides a SwiftUI View wrapper of the `FireworkVideo.StoryBlockViewController`. You can customize the `StoryBlockSwiftUIView` just like the `FireworkVideo.StoryBlockViewController`.

```swift
import FireworkVideo
import FireworkVideoUI

var viewConfiguration = StoryBlockConfiguration()
viewConfiguration.playbackButton.isHidden = false
viewConfiguration.fullScreenPlayerView.playbackButton.isHidden = false

StoryBlockSwiftUIView(
  source: .channel(channelID: "bJDywZ"),
  viewConfiguration: getStoryBlockConfiguration(),
  isPictureInPictureEnabled: true,
  onStoryBlockLoaded: {
      debugPrint("Story block loaded successfully.")
  },
  onStoryBlockFailedToLoad: { error in
      debugPrint("Story block did fail loading with error: \(error.localizedDescription)")
  }
)
```

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
