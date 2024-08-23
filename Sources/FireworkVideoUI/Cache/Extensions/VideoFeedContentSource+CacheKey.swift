//
//  File.swift
//  
//  Created by linjie jiang on 8/16/24.
//

import Foundation
import FireworkVideo

extension VideoFeedContentSource {
    var cacheKey: String {
        var result = "VideoFeedContentSource:"
        switch self {
        case .discover:
            result += "discover"
        case .channel(channelID: let channelID):
            result += "channel_channelID:\(channelID)"
        case .channelPlaylist(channelID: let channelID, playlistID: let playlistID):
            result += "channelPlaylist_channelID:\(channelID)_playlistID:\(playlistID)"
        case .playlistGroup(groupID: let groupID):
            result += "playlistGroup_groupID:\(groupID)"
        case .dynamicContent(channelID: let channelID, parameters: let parameters):
            var parametersString = ""
            let sortedKeys = Array(parameters.keys).sorted(by: <)
            for key in sortedKeys {
                let value = parameters[key]?.joined(separator: ",")
                parametersString += "\(key):\(value ?? "")"
            }
            result += "dynamicContent_channelID:\(channelID)_parameters:\(parametersString)"
        case .hashtagPlaylist(channelID: let channelID, filterExpression: let filterExpression):
            result += "hashtagPlaylist_channelID:\(channelID)_filterExpression:\(filterExpression)"
        case .skuPlaylist(channelID: let channelID, productIDs: let productIDs):
            result += "skuPlaylist_channelID:\(channelID)_productIDs:\(productIDs.joined(separator: ","))"
        case .singleContent(videoOrLiveStreamID: let videoOrLiveStreamID):
            result += "singleContent_videoOrLiveStreamID:\(videoOrLiveStreamID))"
        case .videoAds(adChannelId: let adChannelId, vastXml: let vastXml):
            result += "videoAds_adChannelId:\(adChannelId)_vastXml:\(vastXml)"
        case .unknownContent:
            result += "unknownContent"
        default:
            break
        }
        return result
    }
}
