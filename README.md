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
import UIKit
import FireworkVideo
import FireworkVideoUI

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addVideoFeedView()
    }

    func addVideoFeedView() {
        let videoFeedView = VideoFeedView(source: .discover)
        videoFeedView.viewConfiguration = getVideoFeedContentConfiguration()

        videoFeedView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(videoFeedView)

        NSLayoutConstraint.activate([
            videoFeedView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            videoFeedView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            videoFeedView.heightAnchor.constraint(equalToConstant: 240),
            videoFeedView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

    func getVideoFeedContentConfiguration() -> VideoFeedContentConfiguration {
        var viewConfiguration = VideoFeedContentConfiguration()
        viewConfiguration.itemView.autoplay.isEnabled = true
        viewConfiguration.playerView.playbackButton.isHidden = false
        return viewConfiguration
    }
}
```

## StoryBlockView

The `StoryBlockView` provides a `UIView` wrapper of the `FireworkVideo.StoryBlockViewController`. You can customize the `StoryBlockView` just like the `FireworkVideo.StoryBlockViewController`.

```swift
import UIKit
import FireworkVideo
import FireworkVideoUI

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addStoryBlockView()
    }

    func addStoryBlockView() {
        let storyBlockView = StoryBlockView(source: .discover)
        storyBlockView.viewConfiguration = getStoryBlockConfiguration()

        storyBlockView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(storyBlockView)

        NSLayoutConstraint.activate([
            storyBlockView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            storyBlockView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            storyBlockView.heightAnchor.constraint(equalToConstant: 500),
            storyBlockView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

    func getStoryBlockConfiguration() -> StoryBlockConfiguration {
        var viewConfiguration = StoryBlockConfiguration()
        viewConfiguration.playbackButton.isHidden = false
        viewConfiguration.fullScreenPlayerView.playbackButton.isHidden = false
        return viewConfiguration
    }
}
```

## VideoFeedSwiftUIView

The `VideoFeedSwiftUIView` provides a SwiftUI View wrapper for the `FireworkVideo.VideoFeedViewController`. You can customize the `VideoFeedSwiftUIView` just like the `FireworkVideo.VideoFeedViewController`.

```swift
import SwiftUI
import FireworkVideo
import FireworkVideoUI

struct ContentView: View {
    var body: some View {
        List {
            Spacer()
            VideoFeedSwiftUIView(
                source: .discover,
                viewConfiguration: getVideoFeedContentConfiguration(),
                isPictureInPictureEnabled: true,
                onVideoFeedLoaded: {
                    debugPrint("Video feed loaded successfully.")
                },
                onVideoFeedFailedToLoad: { error in
                    debugPrint("Video feed did fail loading.")
                }
            ).frame(height: 240)
            Spacer()
        }
    }

    func getVideoFeedContentConfiguration() -> VideoFeedContentConfiguration {
        var viewConfiguration = VideoFeedContentConfiguration()
        viewConfiguration.itemView.autoplay.isEnabled = true
        viewConfiguration.playerView.playbackButton.isHidden = false
        return viewConfiguration
    }
}
```

## StoryBlockSwiftUIView

The `StoryBlockSwiftUIView` provides a SwiftUI View wrapper for the `FireworkVideo.StoryBlockViewController`. You can customize the `StoryBlockSwiftUIView` just like the `FireworkVideo.StoryBlockViewController`.

```swift
import SwiftUI
import FireworkVideo
import FireworkVideoUI

struct ContentView: View {
    var body: some View {
        List {
            Spacer()
            StoryBlockSwiftUIView(
                source: .discover,
                viewConfiguration: getStoryBlockConfiguration(),
                isPictureInPictureEnabled: true,
                onStoryBlockLoaded: {
                    debugPrint("Story block loaded successfully.")
                },
                onStoryBlockFailedToLoad: { error in
                    debugPrint("Story block did fail loading.")
                }
            ).frame(height: 500)
            Spacer()
        }
    }

    func getStoryBlockConfiguration() -> StoryBlockConfiguration {
        var viewConfiguration = StoryBlockConfiguration()
        viewConfiguration.playbackButton.isHidden = false
        viewConfiguration.fullScreenPlayerView.playbackButton.isHidden = false
        return viewConfiguration
    }
}
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
