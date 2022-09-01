//
//  FireworkVideoUITests.swift
//
//  Created by Luke Davis on 8/29/22.
//

import XCTest
import UIKit
import FireworkVideo
@testable import FireworkVideoUI

final class FireworkVideoUITests: XCTestCase {

    var containerVC: UIViewController!

    override func setUp() {
        containerVC = UIViewController()
    }

    override func tearDown() {
        containerVC = nil
    }

    func testInitialization() {
        let sut = VideoFeedView(frame: .zero, source: .channel(channelID: UUID().uuidString))
        switch sut.feedViewController.source {
        case .channel: break
        default:
            XCTFail("Expected same source as that was used to create the view")
        }
    }
    
    func testAttachesWhenIntersectsParent() throws {
        let frame = CGRect(origin: .zero, size: .init(width: 10, height: 10))
        containerVC.view.frame = frame
        let sut = VideoFeedView(frame: frame)
        containerVC.view.addSubview(sut)
        // Force a subview layout because we are not actually rendering
        sut.layoutSubviews()
        XCTAssertNotNil(sut.feedViewController.parent, "Expected feed to be attached to a parent view controller")
        XCTAssertNotNil(sut.feedViewController.view.superview, "Expected feed view to be attached to a superview")
    }

    func testDetachedWhenDoesNotIntersectParent() throws {
        let frame = CGRect(origin: .zero, size: .init(width: 10, height: 10))
        containerVC.view.frame = frame
        let sut = VideoFeedView(frame: frame.offsetBy(dx: 10, dy: 0))
        containerVC.view.addSubview(sut)
        // Force a subview layout because we are not actually rendering
        sut.layoutSubviews()
        XCTAssertNil(sut.feedViewController.parent, "Expected feed not to be attached to a parent view controller when not on screen")
        XCTAssertNil(sut.feedViewController.view.superview, "Expected feed not to be attached to a superview when not on screen")
    }

    func testAttachesWhenScrolledHorizontallyOnScreen() throws {
        let frame = CGRect(origin: .zero, size: .init(width: 10, height: 10))
        containerVC.view.frame = frame
        let sut = VideoFeedView(frame: frame)
        let scrollView = UIScrollView(frame: frame)
        containerVC.view.addSubview(scrollView)
        scrollView.addSubview(sut)
        scrollView.contentSize = CGSize(width: frame.width * 2, height: frame.height)
        scrollView.bounds = CGRect(origin: scrollView.contentOffset, size: scrollView.contentSize)
        scrollView.contentOffset = CGPoint(x: -frame.width, y: 0)
        XCTAssertNotNil(sut.feedViewController.parent, "Expected feed to be attached to a parent view controller")
        XCTAssertNotNil(sut.feedViewController.view.superview, "Expected feed view to be attached to a superview")
    }

    func testDetachedWhenScrolledHorizontallyOffScreen() throws {
        let frame = CGRect(origin: .zero, size: .init(width: 10, height: 10))
        containerVC.view.frame = frame
        let sut = VideoFeedView(frame: frame)
        let scrollView = UIScrollView(frame: frame)
        containerVC.view.addSubview(scrollView)
        scrollView.addSubview(sut)
        scrollView.contentSize = CGSize(width: frame.width, height: frame.height)
        scrollView.bounds = CGRect(origin: scrollView.contentOffset, size: scrollView.contentSize)
        scrollView.contentOffset = CGPoint(x: frame.width, y: 0)
        XCTAssertNil(sut.feedViewController.parent, "Expected feed to be detached from parent view controller when scrolled out of bounds")
        XCTAssertNil(sut.feedViewController.view.superview, "Expected feed to be detached from superview when scrolled out of bounds")
    }

    func testAttachesWhenScrolledVerticallyOnScreen() throws {
        let frame = CGRect(origin: .zero, size: .init(width: 10, height: 10))
        containerVC.view.frame = frame
        let sut = VideoFeedView(frame: frame)
        let scrollView = UIScrollView(frame: frame)
        containerVC.view.addSubview(scrollView)
        scrollView.addSubview(sut)
        scrollView.contentSize = CGSize(width: frame.width, height: frame.height * 2)
        scrollView.bounds = CGRect(origin: scrollView.contentOffset, size: scrollView.contentSize)
        // Force a subview layout because we are not actually rendering
        sut.layoutSubviews()
        scrollView.contentOffset = CGPoint(x: 0, y: -frame.height)
        XCTAssertNotNil(sut.feedViewController.parent, "Expected feed to be attached to a parent view controller")
        XCTAssertNotNil(sut.feedViewController.view.superview, "Expected feed view to be attached to a superview")
    }

    func testDetachedWhenScrolledVerticallyOffScreen() throws {
        let frame = CGRect(origin: .zero, size: .init(width: 10, height: 10))
        containerVC.view.frame = frame
        let sut = VideoFeedView(frame: frame)
        let scrollView = UIScrollView(frame: frame)
        containerVC.view.addSubview(scrollView)
        scrollView.addSubview(sut)
        scrollView.contentSize = CGSize(width: frame.width, height: frame.height)
        scrollView.bounds = CGRect(origin: scrollView.contentOffset, size: scrollView.contentSize)
        // Force a subview layout because we are not actually rendering
        sut.layoutSubviews()
        scrollView.contentOffset = CGPoint(x: 0, y: frame.height)
        XCTAssertNil(sut.feedViewController.parent, "Expected feed to be detached from parent view controller when scrolled out of bounds")
        XCTAssertNil(sut.feedViewController.view.superview, "Expected feed to be detached from superview when scrolled out of bounds")
    }

    func testDelegateProxy() throws {
        let sut = VideoFeedView(frame: .zero)
        let delegate = VideoFeedViewControllerDelegateStub()
        sut.delegate = delegate
        XCTAssertNotNil(sut.feedViewController.delegate, "Expected to be set from VideoFeedView")
        XCTAssertTrue(sut.feedViewController.delegate === delegate, "Expected same delegate instance to be used on on the feed view controller")
    }

    func testViewConfigurationProxy() throws {
        let sut = VideoFeedView(frame: .zero)
        var config = sut.viewConfiguration
        config.backgroundColor = .red
        sut.viewConfiguration = config
        XCTAssertEqual(sut.feedViewController.viewConfiguration, config, "Expected feed configuration to be updated")
    }
}

class VideoFeedViewControllerDelegateStub: VideoFeedViewControllerDelegate {
    func videoFeedDidLoadFeed(_ viewController: VideoFeedViewController) {}
    func videoFeed(_ viewController: VideoFeedViewController, didFailToLoadFeed error: VideoFeedError) {}
}
