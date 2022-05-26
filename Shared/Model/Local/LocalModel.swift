//
//  LocalModel.swift
//  Yu
//
//  Created by tangyujun on 2022/5/25.
//

import Foundation


// MARK: 歌曲模型
struct YuSong: Codable{
    var id: Int64                   // 歌曲ID
    var name: String                // 歌曲名称
    var artists: [YuArtist]         // 歌手
    var album: YuAlbum?             // 专辑
    var artistsDisplay: String{     // 歌手显示内容,通过逗号分隔用于显示等
        get{
            var builder: String = ""
            var isFirst: Bool = true
            for artist in artists {
                if isFirst {
                    builder += "\(artist.name)"
                    isFirst = false
                }else{
                    builder += ",\(artist.name)"
                }
            }
            return builder
        }
    }
}

// MARK: 歌手模型
struct YuArtist: Codable{
    var id: Int64               // 歌手id
    var name: String            // 歌手名称
    var picUrl: String?         // 封面
    var albumSize: Int64?       // 专辑数量
}

// MARK: 专辑模型
struct YuAlbum: Codable{
    var id: Int64           // id
    var name: String        // 专辑名称
    var picUrl: String?      // 专辑封面
}

// MARK: 歌曲资源
struct YuSource: Identifiable, Codable{
    var id: UUID = UUID()
    var quality: String
    var url: String
}

// MARK: 歌词模型
struct YuLyric: Identifiable {
    var id: UUID = UUID()
//    var isBlur: Bool = true
    var lyric: String
    var time: Int

    init(time: Int, lyric: String) {
        self.time = time
        self.lyric = lyric
//        self.isBlur = isBlur
    }
}
