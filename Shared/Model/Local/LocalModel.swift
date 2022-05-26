//
//  LocalModel.swift
//  Yu
//
//  Created by tangyujun on 2022/5/25.
//

import Foundation


// MARK: 歌曲模型
struct YuSong: Codable{
    // 歌曲ID
    var id: Int64
    // 歌曲名称
    var name: String
    // 歌手
    var artists: [YuArtist]
    // 歌手显示内容,通过逗号分隔用于显示等
    var artistsDisplay: String{
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
    // 歌手id
    var id: Int64
    // 歌手名称
    var name: String
    // 封面
    var picUrl: String?
    // 专辑数量
    var albumSize: Int64?
}

// MARK: 歌曲资源
struct YuSource: Identifiable, Codable{
    var id: UUID = UUID()
    var quality: String
    var url: String
}

// MARK: 歌词
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
