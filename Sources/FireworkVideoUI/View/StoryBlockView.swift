//
//  File.swift
//  
//  Created by linjie jiang on 8/16/24.
//

import UIKit
import FireworkVideo

public class StoryBlockView: UIView {
    public var source: StoryBlockContentSource {
        storyBlockViewController.source
    }

    public var delegate: StoryBlockViewControllerDelegate? {
        get { storyBlockViewController.delegate }
        set { storyBlockViewController.delegate = newValue }
    }

    public var viewConfiguration: StoryBlockConfiguration {
        get { storyBlockViewController.viewConfiguration }
        set { storyBlockViewController.viewConfiguration = newValue }
    }

    public var feedID: String {
        storyBlockViewController.feedID
    }

    public var isPictureInPictureEnabled: Bool {
        get { storyBlockViewController.isPictureInPictureEnabled }
        set { storyBlockViewController.isPictureInPictureEnabled = newValue }
    }

    public var pictureInPictureDelegate: (any PictureInPictureControllerDelegate)? {
        get { storyBlockViewController.pictureInPictureDelegate }
        set { storyBlockViewController.pictureInPictureDelegate = newValue }
    }

    private let storyBlockViewController: StoryBlockViewController

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

    public func play() {
        storyBlockViewController.play()
    }

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
