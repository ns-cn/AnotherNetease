//
//  YuRemoteSearch.swift
//  Yu
//
//  Created by tangyujun on 2022/5/26.
//

import Foundation

// MARK: 搜索类型枚举定义
enum YuSearchType: Int16{
    case SONG = 1
    case ARTIST = 100
}

// MARK: [API] 歌曲搜索
extension YuData {
    func searchSong(key: String, offset: Int16 = 0){
        let url = urlBuilder("/cloudsearch?keywords=\(key)&type=\(YuSearchType.SONG.rawValue)&offset=\(offset)")
        remoteJsonHandler(url: url, dataType: YuRemoteSearchSongResponse.self) { data, err in
            
        }
    }
}

// MARK: [Model] 歌曲搜索响应体
struct YuRemoteSearchSongResponse: Codable{
    var code: Int16         // 状态码
    var result: YuRemoteSearchSongResponseResult    // 结果集
}

struct YuRemoteSearchSongResponseResult: Codable{
    var songs: [YuRemoteSearchSongResponseResultSongs]
    var songCount: Int64
}
struct YuRemoteSearchSongResponseResultSongs: Codable{
    var id: Int64       // 歌曲id
    var name: String    // 歌曲名称
    var ar: [YuRemoteResponseArtist]    // 歌手
}


// MARK: [API] 歌手搜索
extension YuData{
    func searchArtist(key: String, offset: Int16 = 0){
        let url = urlBuilder("/cloudsearch?keywords=\(key)&type=\(YuSearchType.ARTIST.rawValue)&offset=\(offset)")
        remoteJsonHandler(url: url, dataType: YuRemoteSearchArtitstResponse.self) { data, err in
            
        }
    }
}

// MARK: [Model] 歌手搜索响应体
struct YuRemoteSearchArtitstResponse: Codable{
    var code: Int16         // 状态码
    var result: YuRemoteSearchArtistResponseResult      // 结果
}
struct YuRemoteSearchArtistResponseResult: Codable{
    var artists: [YuRemoteResponseArtist]   // 结果集
    func toArtists() -> [YuArtist]{     // 转换为本地的模型
        var localArtists:[YuArtist] = []
        for artist in artists{
            localArtists.append(artist.toArtist())
        }
        return localArtists
    }
}
