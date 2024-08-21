//
//  File.swift
//  
//
//  Created by linjie jiang on 8/21/24.
//

import Foundation
import FireworkVideo

public typealias VideoFeedLoadedClosure = (() -> Void)
public typealias VideoFeedFailedToLoadClosure = ((_ error: VideoFeedError) -> Void)
public typealias StoryBlockLoadedClosure = (() -> Void)
public typealias StoryBlockFailedToLoadClosure = ((_ error: StoryBlockError) -> Void)
public typealias PipWillStartClosure = (() -> Void)
public typealias PipDidStartClosure = (() -> Void)
public typealias PipFailedToStartClosure = ((_ error: Error?) -> Void)
public typealias PipWillStopClosure = (() -> Void)
public typealias PipDidStopClosure = (() -> Void)
public typealias PipRestoreUserInterfaceClosure = ((_ completionHandler: @escaping (Bool) -> Void) -> Void)
public typealias GetFeedIDClosure = ((_ feedID: String) -> Void)
