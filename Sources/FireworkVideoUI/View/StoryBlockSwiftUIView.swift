//
//  SwiftUIView.swift
//
//  Created by linjie jiang on 8/14/24.
//

import SwiftUI
import FireworkVideo

public struct StoryBlockHandler {
    private weak var storyBlockVC: StoryBlockViewController?

    init(storyBlockVC: StoryBlockViewController? = nil) {
        self.storyBlockVC = storyBlockVC
    }

    public func play() {
        storyBlockVC?.play()
    }

    public func pause() {
        storyBlockVC?.pause()
    }
}

public typealias GetStoryBlockHandlerClosure = (_ handler: StoryBlockHandler) -> Void

public struct StoryBlockSwiftUIView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = StoryBlockViewController

    public typealias UIViewType = StoryBlockView

    public class Coordinator: StoryBlockViewControllerDelegate, PictureInPictureControllerDelegate {
        private let parent: StoryBlockSwiftUIView
        var hasCalledAppearanceTransitionMethods = false

        init(parent: StoryBlockSwiftUIView) {
            self.parent = parent
        }

        public func storyBlockDidLoadFeed(
            _ viewController: StoryBlockViewController
        ) {
            parent.onStoryBlockLoaded?()
        }
        
        public func storyBlock(
            _ viewController: StoryBlockViewController,
            didFailToLoadFeed error: StoryBlockError
        ) {
            parent.onStoryBlockFailedToLoad?(error)
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

    private let source: StoryBlockContentSource
    private let adConfiguration: AdConfiguration
    private let viewConfiguration: StoryBlockConfiguration
    private let isPictureInPictureEnabled: Bool
    private let onStoryBlockLoaded: StoryBlockLoadedClosure?
    private let onStoryBlockFailedToLoad: StoryBlockFailedToLoadClosure?
    private let onPipWillStart: PipWillStartClosure?
    private let onPipDidStart: PipDidStartClosure?
    private let onPipFailedToStart: PipFailedToStartClosure?
    private let onPipWillStop: PipWillStopClosure?
    private let onPipDidStop: PipDidStopClosure?
    private let onPipRestoreUserInterface: PipRestoreUserInterfaceClosure?
    private let onGetFeedID: GetFeedIDClosure?
    private let onGetStoryBlockHandler: GetStoryBlockHandlerClosure?

    public init(
        source: StoryBlockContentSource = .discover,
        adConfiguration: AdConfiguration = AdConfiguration(),
        viewConfiguration: StoryBlockConfiguration = StoryBlockConfiguration(),
        isPictureInPictureEnabled: Bool = false,
        onStoryBlockLoaded: StoryBlockLoadedClosure? = nil,
        onStoryBlockFailedToLoad: StoryBlockFailedToLoadClosure? = nil,
        onPipWillStart: PipWillStartClosure? = nil,
        onPipDidStart: PipDidStartClosure? = nil,
        onPipFailedToStart: PipFailedToStartClosure? = nil,
        onPipWillStop: PipWillStopClosure? = nil,
        onPipDidStop: PipDidStopClosure? = nil,
        onPipRestoreUserInterface: PipRestoreUserInterfaceClosure? = nil,
        onGetFeedID: GetFeedIDClosure? = nil,
        onGetStoryBlockHandler: GetStoryBlockHandlerClosure? = nil
    ) {
        self.source = source
        self.adConfiguration = adConfiguration
        self.viewConfiguration = viewConfiguration
        self.isPictureInPictureEnabled = isPictureInPictureEnabled
        self.onStoryBlockLoaded = onStoryBlockLoaded
        self.onStoryBlockFailedToLoad = onStoryBlockFailedToLoad
        self.onPipWillStart = onPipWillStart
        self.onPipDidStart = onPipDidStart
        self.onPipFailedToStart = onPipFailedToStart
        self.onPipWillStop = onPipWillStop
        self.onPipDidStop = onPipDidStop
        self.onPipRestoreUserInterface = onPipRestoreUserInterface
        self.onGetFeedID = onGetFeedID
        self.onGetStoryBlockHandler = onGetStoryBlockHandler
    }

    public func makeUIViewController(context: Context) -> StoryBlockViewController {
        let storyBlockVC = StoryBlockViewController(source: source, adConfiguration: adConfiguration)
        storyBlockVC.viewConfiguration = viewConfiguration
        storyBlockVC.isPictureInPictureEnabled = isPictureInPictureEnabled
        storyBlockVC.delegate = context.coordinator
        storyBlockVC.pictureInPictureDelegate = context.coordinator

        onGetFeedID?(storyBlockVC.feedID)

        if let onGetStoryBlockHandler = onGetStoryBlockHandler {
            onGetStoryBlockHandler(StoryBlockHandler(storyBlockVC: storyBlockVC))
        }

        return storyBlockVC
    }

    public func updateUIViewController(_ uiViewController: StoryBlockViewController, context: Context) {
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
