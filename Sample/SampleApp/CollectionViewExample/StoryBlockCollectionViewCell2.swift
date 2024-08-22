//
//  StoryBlockCollectionViewCell2.swift
//  SampleApp
//
//  Created by linjie jiang on 8/21/24.
//

import UIKit
import FireworkVideo
import FireworkVideoUI

class StoryBlockViewCollectionViewCell2: UICollectionViewCell {
    static let id = "\(StoryBlockViewCollectionViewCell2.self)"

    var source: StoryBlockContentSource?
    var indexPath: IndexPath?

    var storyBlockView: StoryBlockView? {
        didSet {
            if storyBlockView != oldValue {
                if let oldStoryBlockView = oldValue,
                   oldStoryBlockView.superview == self.contentView {
                    oldStoryBlockView.removeFromSuperview()
                }
                updateStoryBlockView()
            }
        }
    }

    private func updateStoryBlockView() {
        guard let storyBlockView = storyBlockView else {
            return
        }
        storyBlockView.delegate = self
        var viewConfiguration = StoryBlockConfiguration()
        viewConfiguration.playbackButton.isHidden = false
        viewConfiguration.fullScreenPlayerView.playbackButton.isHidden = false
        storyBlockView.viewConfiguration = viewConfiguration

        storyBlockView.translatesAutoresizingMaskIntoConstraints = false
        if storyBlockView.superview != contentView {
            if storyBlockView.superview != nil {
                storyBlockView.removeFromSuperview()
            }
            contentView.addSubview(storyBlockView)
        }
        NSLayoutConstraint.activate([
            storyBlockView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            storyBlockView.topAnchor.constraint(equalTo: contentView.topAnchor),
            storyBlockView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            storyBlockView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

extension StoryBlockViewCollectionViewCell2: StoryBlockViewControllerDelegate {
    func storyBlockDidLoadFeed(
        _ viewController: StoryBlockViewController
    ) {

    }

    func storyBlock(
        _ viewController: StoryBlockViewController,
        didFailToLoadFeed error: StoryBlockError
    ) {

    }
}
