//
//  VideoFeedSwiftUIView.swift
//
//  Created by linjie jiang on 8/13/24.
//

import SwiftUI
import FireworkVideo

public struct VideoFeedHandler {
    private weak var videoFeedVC: VideoFeedViewController?

    init(videoFeedVC: VideoFeedViewController? = nil) {
        self.videoFeedVC = videoFeedVC
    }

    /**
     Force refreshes the video feed.

     Provides a way to force refresh the entire video feed. This is helpful when you support features like pull to refresh.

     - important: Any calls to this method while the Firework Video Player is presented will be ignored.

     - warning: This will replace all the items in the current feed.
     */
    public func refresh() {
        videoFeedVC?.refresh()
    }
}

public typealias GetVideoFeedHandlerClosure = (_ handler: VideoFeedHandler) -> Void

/**
 The `VideoFeedSwiftUIView` provides a SwiftUI View wrapper of the `FireworkVideo.VideoFeedViewController`. You can customize the `VideoFeedSwiftUIView` just like the `FireworkVideo.VideoFeedViewController`.
 */
public struct VideoFeedSwiftUIView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = VideoFeedViewController


    public class Coordinator: VideoFeedViewControllerDelegate, PictureInPictureControllerDelegate {
        let parent: VideoFeedSwiftUIView
        var hasCalledAppearanceTransitionMethods = false

        init(parent: VideoFeedSwiftUIView) {
            self.parent = parent
        }

        public func videoFeedDidLoadFeed(
            _ viewController: VideoFeedViewController
        ) {
            parent.onVideoFeedLoaded?()
        }
        
        public func videoFeed(
            _ viewController: VideoFeedViewController,
            didFailToLoadFeed error: VideoFeedError
        ) {
            parent.onVideoFeedFailedToLoad?(error)
        }

        public func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: PictureInPictureController) {
            parent.onPipWillStart?()
        }

        public func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: PictureInPictureController) {
            parent.onPipDidStart?()
        }

        public func pictureInPictureController(_ pictureInPictureController: PictureInPictureController, failedToStartPictureInPictureWithError error: (any Error)?) {
            parent.onPipFailedToStart?(error)
        }

        public func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: PictureInPictureController) {
            parent.onPipWillStop?()
        }

        public func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: PictureInPictureController) {
            parent.onPipDidStop?()
        }

        public func pictureInPictureController(_ pictureInPictureController: PictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
            parent.onPipRestoreUserInterface?(completionHandler)
        }
    }

    private let layout: VideoFeedLayout
    private let source: VideoFeedContentSource
    private let adConfiguration: AdConfiguration
    private let viewConfiguration: VideoFeedContentConfiguration
    private let isPictureInPictureEnabled: Bool
    private let onVideoFeedLoaded: VideoFeedLoadedClosure?
    private let onVideoFeedFailedToLoad: VideoFeedFailedToLoadClosure?
    private let onPipWillStart: PipWillStartClosure?
    private let onPipDidStart: PipDidStartClosure?
    private let onPipFailedToStart: PipFailedToStartClosure?
    private let onPipWillStop: PipWillStopClosure?
    private let onPipDidStop: PipDidStopClosure?
    private let onPipRestoreUserInterface: PipRestoreUserInterfaceClosure?
    private let onGetFeedID: GetFeedIDClosure?
    private let onGetVideoFeedHandler: GetVideoFeedHandlerClosure?

    /// Initializes VideoFeedSwfitUIView.
    /// - Parameters:
    ///   - layout: The video feed layout. Defaults to VideoFeedHorizontalLayout().
    ///   - source: The video content source. Defaults to `.discover`.
    ///   - adConfiguration: The ad configuration. See `AdConfiguration` default values.
    ///   - viewConfiguration: The video configuration for the video feed.
    ///   - isPictureInPictureEnabled: Indicate whether pip is enabled.
    ///   - onVideoFeedLoaded: Called when the video feed is loaded.
    ///   - onVideoFeedFailedToLoad: Called when the video feed loading fails.
    ///   - onPipDidStart: Called when the pip will start.
    ///   - onPipDidStart: Called after the pip started.
    ///   - onPipFailedToStart: Called when pip failed to start.
    ///   - onPipWillStop: Called when the pip will stop.
    ///   - onPipDidStop: Called after the pip stopped.
    ///   - onPipRestoreUserInterface: Host app could set this closure to restore the user interface before Picture in Picture stops.
    ///   - onGetFeedID: Host app could get feed using this closure.
    ///   - onGetVideoFeedHandler: Host app could get `VideoFeedHandler` using this closure.
    public init(
        layout: VideoFeedLayout = VideoFeedHorizontalLayout(),
        source: VideoFeedContentSource = .discover,
        adConfiguration: AdConfiguration = AdConfiguration(),
        viewConfiguration: VideoFeedContentConfiguration = VideoFeedContentConfiguration(),
        isPictureInPictureEnabled: Bool = false,
        onVideoFeedLoaded: VideoFeedLoadedClosure? = nil,
        onVideoFeedFailedToLoad: VideoFeedFailedToLoadClosure? = nil,
        onPipWillStart: PipWillStartClosure? = nil,
        onPipDidStart: PipDidStartClosure? = nil,
        onPipFailedToStart: PipFailedToStartClosure? = nil,
        onPipWillStop: PipWillStopClosure? = nil,
        onPipDidStop: PipDidStopClosure? = nil,
        onPipRestoreUserInterface: PipRestoreUserInterfaceClosure? = nil,
        onGetFeedID: GetFeedIDClosure? = nil,
        onGetVideoFeedHandler: GetVideoFeedHandlerClosure? = nil
    ) {
        self.layout = layout
        self.source = source
        self.adConfiguration = adConfiguration
        self.viewConfiguration = viewConfiguration
        self.isPictureInPictureEnabled = isPictureInPictureEnabled
        self.onVideoFeedLoaded = onVideoFeedLoaded
        self.onVideoFeedFailedToLoad = onVideoFeedFailedToLoad
        self.onPipWillStart = onPipWillStart
        self.onPipDidStart = onPipDidStart
        self.onPipFailedToStart = onPipFailedToStart
        self.onPipWillStop = onPipWillStop
        self.onPipDidStop = onPipDidStop
        self.onPipRestoreUserInterface = onPipRestoreUserInterface
        self.onGetFeedID = onGetFeedID
        self.onGetVideoFeedHandler = onGetVideoFeedHandler
    }

    public func makeUIViewController(context: Context) -> FireworkVideo.VideoFeedViewController {
        let videoFeedVC = VideoFeedViewController(layout: layout, source: source, adConfiguration: adConfiguration)
        videoFeedVC.viewConfiguration = viewConfiguration
        videoFeedVC.isPictureInPictureEnabled = isPictureInPictureEnabled
        videoFeedVC.delegate = context.coordinator
        videoFeedVC.pictureInPictureDelegate = context.coordinator

        onGetFeedID?(videoFeedVC.feedID)

        if let onGetVideoFeedHandler = onGetVideoFeedHandler {
            onGetVideoFeedHandler(VideoFeedHandler(videoFeedVC: videoFeedVC))
        }
        return videoFeedVC
    }

    public func updateUIViewController(_ uiViewController: FireworkVideo.VideoFeedViewController, context: Context) {
        if !context.coordinator.hasCalledAppearanceTransitionMethods {
            uiViewController.beginAppearanceTransition(true, animated: false)
            uiViewController.endAppearanceTransition()
            context.coordinator.hasCalledAppearanceTransitionMethods = true
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}
