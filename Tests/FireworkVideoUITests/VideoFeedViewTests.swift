//
//  FireworkVideoUITests.swift
//  FireworkVideoDebug
//
//  Created by Luke Davis on 8/29/22.
//

import XCTest
import UIKit
import FireworkVideo
@testable import FireworkVideoUI

final class FireworkVideoUITests: XCTestCase {

    var feedViewController: VideoFeedViewController!
    var containerVC: UIViewController!

    override func setUp() {
        containerVC = UIViewController()
        feedViewController = VideoFeedViewController(layout: VideoFeedHorizontalLayout(), source: .discover)
    }

    override func tearDown() {
        containerVC = nil
        feedViewController = nil
    }
    
    func testAttachesWhenIntersectsParent() throws {
        let frame = CGRect(origin: .zero, size: .init(width: 10, height: 10))
        containerVC.view.frame = frame
        let sut = VideoFeedView(frame: frame, feedViewController: feedViewController)
        containerVC.view.addSubview(sut)
        // Force a subview layout because we are not actually rendering
        sut.layoutSubviews()
        XCTAssertNotNil(feedViewController.parent, "Expected feed to be attached to a parent view controller")
        XCTAssertNotNil(feedViewController.view.superview, "Expected feed view to be attached to a superview")
    }

    func testAttachesWhenDoesNotIntersectParent() throws {
        let frame = CGRect(origin: .zero, size: .init(width: 10, height: 10))
        containerVC.view.frame = frame
        let sut = VideoFeedView(frame: frame.offsetBy(dx: 10, dy: 0), feedViewController: feedViewController)
        containerVC.view.addSubview(sut)
        // Force a subview layout because we are not actually rendering
        sut.layoutSubviews()
        XCTAssertNil(feedViewController.parent, "Expected feed not to be attached to a parent view controller when not on screen")
        XCTAssertNil(feedViewController.view.superview, "Expected feed not to be attached to a superview when not on screen")
    }
}
