//
//  SwiftUIViewController.swift
//  SampleApp
//
//  Created by linjie jiang on 8/21/24.
//

import UIKit
import SwiftUI
import FireworkVideoUI
import FireworkVideo

struct SwiftUIListView: View {
    var body: some View {
        List {
            Text("Non-feed Cell").frame(height: 100)
            VideoFeedSwiftUIView(
                source: .channelPlaylist(channelID: "bJDywZ", playlistID: "g206q5"),
                viewConfiguration: getVideoFeedContentConfiguration(),
                isPictureInPictureEnabled: true,
                onVideoFeedLoaded: {
                    debugPrint("Video feed loaded successfully.")
                },
                onVideoFeedFailedToLoad: { error in
                    debugPrint("Video feed did fail loading with error: \(error.localizedDescription)")
                }
            ).frame(height: 240)
            Text("Non-feed Cell").frame(height: 100)
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
            ).frame(height: 500)
        }
    }

    private func getVideoFeedContentConfiguration() -> VideoFeedContentConfiguration {
        var viewConfiguration = VideoFeedContentConfiguration()
        viewConfiguration.itemView.autoplay.isEnabled = true
        viewConfiguration.playerView.playbackButton.isHidden = false
        return viewConfiguration
    }

    private func getStoryBlockConfiguration() -> StoryBlockConfiguration {
        var viewConfiguration = StoryBlockConfiguration()
        viewConfiguration.playbackButton.isHidden = false
        viewConfiguration.fullScreenPlayerView.playbackButton.isHidden = false
        return viewConfiguration
    }
}

class SwiftUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let listView = SwiftUIListView()
        let hostingController = UIHostingController(rootView: listView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }
}
