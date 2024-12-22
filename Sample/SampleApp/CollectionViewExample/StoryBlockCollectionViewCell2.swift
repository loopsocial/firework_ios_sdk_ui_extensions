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

    func embed(_ storyBlockView: StoryBlockView) {
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
            for subview in contentView.subviews where subview is StoryBlockView {
                subview.removeFromSuperview()
            }
            contentView.addSubview(storyBlockView)
            NSLayoutConstraint.activate([
                storyBlockView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                storyBlockView.topAnchor.constraint(equalTo: contentView.topAnchor),
                storyBlockView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                storyBlockView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
        }
    }

    func getStoryBlockView() -> StoryBlockView? {
        return contentView.subviews.first(where: { $0 is StoryBlockView }) as? StoryBlockView
    }
}

extension StoryBlockViewCollectionViewCell2: StoryBlockViewControllerDelegate {
    func storyBlockDidLoadFeed(
        _ viewController: StoryBlockViewController
    ) {
        debugPrint("Story block loaded successfully.")
    }

    func storyBlock(
        _ viewController: StoryBlockViewController,
        didFailToLoadFeed error: StoryBlockError
    ) {
        debugPrint("Story block did fail loading with error: \(error.localizedDescription)")
    }
}
