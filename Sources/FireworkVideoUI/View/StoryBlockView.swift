//
//  StoryBlockView.swift
//  
//  Created by linjie jiang on 8/16/24.
//

import UIKit
import FireworkVideo

/**
 The `StoryBlockView` provides a `UIView` wrapper of the `FireworkVideo.StoryBlockViewController`. You can customize the `StoryBlockView` just like the `FireworkVideo.StoryBlockViewController`.
 */
public class StoryBlockView: UIView {
    /// The content source used for the video feed
    public var source: StoryBlockContentSource {
        storyBlockViewController.source
    }

    /// An object that receives video feed events
    public var delegate: StoryBlockViewControllerDelegate? {
        get { storyBlockViewController.delegate }
        set { storyBlockViewController.delegate = newValue }
    }

    /// The view configuration for the story block.
    public var viewConfiguration: StoryBlockConfiguration {
        get { storyBlockViewController.viewConfiguration }
        set { storyBlockViewController.viewConfiguration = newValue }
    }

    /// The feed ID.
    public var feedID: String {
        storyBlockViewController.feedID
    }

    /// Indicate whether pip is enabled.
    public var isPictureInPictureEnabled: Bool {
        get { storyBlockViewController.isPictureInPictureEnabled }
        set { storyBlockViewController.isPictureInPictureEnabled = newValue }
    }

    /// The pip delegate.
    public var pictureInPictureDelegate: (any PictureInPictureControllerDelegate)? {
        get { storyBlockViewController.pictureInPictureDelegate }
        set { storyBlockViewController.pictureInPictureDelegate = newValue }
    }

//    public var loadResult: StoryBlockLoadResult? {
//        storyBlockViewController.loadResult
//    }

    private let storyBlockViewController: StoryBlockViewController

    /// Initializes StoryBlockView.
    /// - Parameters:
    ///   - source: The video content source. Defaults to `.discover`.
    ///   - adConfiguration: The ad configuration. See `AdConfiguration` default values.
    public init(
        source: StoryBlockContentSource = .discover,
        adConfiguration: AdConfiguration = AdConfiguration()
    ) {
        self.storyBlockViewController = StoryBlockViewController(
            source: source,
            adConfiguration: adConfiguration
        )
        super.init(frame: CGRect.zero)
    }

    override public init(frame: CGRect) {
        self.storyBlockViewController = StoryBlockViewController()
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        self.storyBlockViewController = StoryBlockViewController()
        super.init(coder: coder)
    }

    /**
     Resumes playback if the story block has been paused.

     If the story block is already playing then this method performs no action.

     - important: Calls to this method are ignored when the story block has entered fullscreen
     */
    public func play() {
        storyBlockViewController.play()
    }

    /**
     Stops playback if the story block is already playing.

     If the story block is already paused then this method performs no action.

     - important: Calls to this method are ignored when the story block has entered fullscreen
     */
    public func pause() {
        storyBlockViewController.pause()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        embed()
    }

    public override func removeFromSuperview() {
        super.removeFromSuperview()
        storyBlockViewController.detachFromParent()
    }

    private func embed() {
        guard let parentVC = parentViewController else {
            return
        }

        guard storyBlockViewController.parent == nil else {
            return
        }

        parentVC.attachChild(
            storyBlockViewController,
            to: self
        )
    }
}
