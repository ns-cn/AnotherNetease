//
//  YuRemoteTop.swift
//  Yu
//
//  Created by tangyujun on 2022/5/26.
//

import Foundation


// MARK: 新歌速递类型
enum RemoteTopSongType: Int16{
    case All = 0        // 全部
    case China = 7      // 华语
    case EandA = 96     // 欧美
    case Japan = 8      // 日本
    case Korea = 16     // 韩国
}

// MARK: [API] 热门歌手
extension YuData {
    func topArtist(offset: Int16 = 0, limit: Int16 = 30) -> [YuArtist]{
        let url = urlBuilder("/top/artists?offset=0&limit=30")
        var localArtists: [YuArtist] = []
        remoteJsonHandler(url: url, dataType: YuRemoteTopArtistResponse.self) { data, err in
            if data != nil{
                localArtists = data!.toLocal()
            }
        }
        return localArtists
    }
}

// MARK: [Model] 热门歌手请求响应体
struct YuRemoteTopArtistResponse: Codable{
    let code: Int64                         // 响应码
    let more: Bool                          // 是否还有更多
    let artists: [YuRemoteResponseArtist]   // 歌手
    func toLocal() -> [YuArtist]{     // 转换为本地的模型
        var localArtists:[YuArtist] = []
        for artist in artists{
            localArtists.append(artist.toLocal())
        }
        return localArtists
    }
}

// MARK: [API] 新歌速递
extension YuData{
    func topSong(offset: Int16 = 0, type: RemoteTopSongType = .All) -> [YuArtist]{
        let url = urlBuilder("/top/song?type=\(type.rawValue)")
        var localArtists: [YuArtist] = []
        remoteJsonHandler(url: url, dataType: YuRemoteTopArtistResponse.self) { data, err in
            if data != nil{
                localArtists = data!.toLocal()
            }
        }
        return localArtists
    }
}
// MARK: [Model] 新歌速递请求响应体
struct YuRemoteTopSongRespongse: Codable{
    var code: Int16             // 状态码
    var data: [YuRemoteResponseSong]        // 歌曲明细
}
