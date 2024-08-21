//
//  VideoFeedView.swift
//
//  Created by Luke Davis on 8/29/22.
//

import UIKit
import FireworkVideo

public class VideoFeedView: UIView {
    public var source: VideoFeedContentSource {
        feedViewController.source
    }

    var layout: VideoFeedLayout {
        get { feedViewController.layout }
        set { feedViewController.layout = newValue }
    }

    public var delegate: VideoFeedViewControllerDelegate? {
        get { feedViewController.delegate }
        set { feedViewController.delegate = newValue }
    }

    public var viewConfiguration: VideoFeedContentConfiguration {
        get { feedViewController.viewConfiguration }
        set { feedViewController.viewConfiguration = newValue }
    }

    public var feedID: String {
        feedViewController.feedID
    }

    public var isPictureInPictureEnabled: Bool {
        get { feedViewController.isPictureInPictureEnabled }
        set { feedViewController.isPictureInPictureEnabled = newValue }
    }

    public var pictureInPictureDelegate: (any PictureInPictureControllerDelegate)? {
        get { feedViewController.pictureInPictureDelegate }
        set { feedViewController.pictureInPictureDelegate = newValue }
    }

    private let feedViewController: VideoFeedViewController

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
