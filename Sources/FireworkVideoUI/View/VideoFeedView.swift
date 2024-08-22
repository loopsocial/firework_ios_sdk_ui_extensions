//
//  VideoFeedView.swift
//
//  Created by Luke Davis on 8/29/22.
//

import UIKit
import FireworkVideo

/**
 The `VideoFeedView` provides a `UIView` wrapper of the `FireworkVideo.VideoFeedViewController`. You can customize the `VideoFeedView` just like the `FireworkVideo.VideoFeedViewController`.
 */
public class VideoFeedView: UIView {
    /// The content source used for the video feed
    public var source: VideoFeedContentSource {
        feedViewController.source
    }

    /// The layout to be applied to the video feed
    public var layout: VideoFeedLayout {
        get { feedViewController.layout }
        set { feedViewController.layout = newValue }
    }

    /// An object that receives video feed events
    public weak var delegate: VideoFeedViewControllerDelegate? {
        get { feedViewController.delegate }
        set { feedViewController.delegate = newValue }
    }

    /// The view configuration for the video feed.
    public var viewConfiguration: VideoFeedContentConfiguration {
        get { feedViewController.viewConfiguration }
        set { feedViewController.viewConfiguration = newValue }
    }

    /// The feed ID.
    public var feedID: String {
        feedViewController.feedID
    }

    /// Indicate whether pip is enabled.
    public var isPictureInPictureEnabled: Bool {
        get { feedViewController.isPictureInPictureEnabled }
        set { feedViewController.isPictureInPictureEnabled = newValue }
    }

    /// The pip delegate.
    public var pictureInPictureDelegate: (any PictureInPictureControllerDelegate)? {
        get { feedViewController.pictureInPictureDelegate }
        set { feedViewController.pictureInPictureDelegate = newValue }
    }

    private let feedViewController: VideoFeedViewController

    /// Initializes VideoFeedView.
    /// - Parameters:
    ///   - layout: The video feed layout. Defaults to VideoFeedHorizontalLayout().
    ///   - source: The video content source. Defaults to `.discover`.
    ///   - adConfiguration: The ad configuration. See `AdConfiguration` default values.
    public init(
        layout: VideoFeedLayout = VideoFeedHorizontalLayout(),
        source: VideoFeedContentSource = .discover,
        adConfiguration: AdConfiguration = AdConfiguration()
    ) {
        self.feedViewController = VideoFeedViewController(
            layout: layout,
            source: source,
            adConfiguration: adConfiguration
        )
        super.init(frame: CGRect.zero)
    }

    override public init(frame: CGRect) {
        self.feedViewController = VideoFeedViewController()
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        self.feedViewController = VideoFeedViewController()
        super.init(coder: coder)
    }

    /**
     Force refreshes the video feed.

     Provides a way to force refresh the entire video feed. This is helpful when you support features like pull to refresh.

     - important: Any calls to this method while the Firework Video Player is presented will be ignored.

     - warning: This will replace all the items in the current feed.
     */
    public func refresh() {
        feedViewController.refresh()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        embed()
    }

    public override func removeFromSuperview() {
        super.removeFromSuperview()
        feedViewController.detachFromParent()
    }

    private func embed() {
        guard let parentVC = parentViewController else {
            return
        }

        guard feedViewController.parent == nil else {
            return
        }

        parentVC.attachChild(
            feedViewController,
            to: self
        )
    }
}
