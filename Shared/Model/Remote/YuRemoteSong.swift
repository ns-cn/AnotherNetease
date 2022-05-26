//
//  YuRemoteSongInfo.swift
//  Yu
//
//  Created by tangyujun on 2022/5/26.
//

import Foundation
// MARK: [API] 获取歌曲信息
extension YuData{
    func getSongUrl(_ id: Int64) -> YuSource? {
        let url = urlBuilder("/song/url?id=\(id)&realIP=116.25.146.177")
        var source: YuSource?
        remoteJsonHandler(url: url, dataType: YuRemoteSongUrlResponse.self) { data, err in
            if let item = data?.data?[0]{
                if item.url != nil{
                    source = YuSource(quality: "\(item.br/1000)K", url: item.url!)
                    return
                }
            }
        }
        return source
    }
}

// MARK: [Model] 远程歌曲地址请求响应体
struct YuRemoteSongUrlResponse: Codable{
    var code: Int16
    var data: [YuRemoteSongUrlResponseItem]?     // 歌曲地址明细
}
// 远程歌曲地址请求响应体明细
struct YuRemoteSongUrlResponseItem: Codable{
    var id: Int64   // ID
    var br: Int64   //
    var url: String?    // 歌曲地址
}

// MARK: [API] 获取歌词信息
extension YuData{
    func getSongLyric(_ id: Int64) -> [YuLyric]{
        let url = urlBuilder("/lyric?id=\(id)&realIP=116.25.146.177")
        var lyrics: [YuLyric] = []
        remoteJsonHandler(url: url, dataType: YuRemoteSongLyricResponse.self) { data, err in
            if let responseLyric = data?.lrc{
                lyrics = responseLyric.toLocal()
            }
        }
        return lyrics
    }
}

// MARK: [Model] 远程歌曲歌词请求响应体
struct YuRemoteSongLyricResponse: Codable{
    var lrc: YuRemoteSongLyricResponseDetail?
}
// 远程歌曲歌词请求响应体歌词明细
struct YuRemoteSongLyricResponseDetail: Codable{
    var lyric: String?
    func toLocal() -> [YuLyric]{
        if (lyric != nil){
            if let lines = lyric?.components(separatedBy: ["\n"]){
                var lyrics: [YuLyric] = []
                for line in lines{
                    if let leftTimeIndex = line.firstIndex(of: "["), let rightTimeIndex = line.firstIndex(of: "]"){
                        let str = line[line.index(after: leftTimeIndex)..<rightTimeIndex]
                        let timeIntegers = str.components(separatedBy: [":", "."])
                        let count =  timeIntegers.count - 1
                        var time: Int = 0
                        // [01:43.352]
                        for index in 0..<timeIntegers.count - 1{
                            if index == count - 1{
                                time += (timeIntegers[index] as NSString).integerValue
                            }else{
                                time += (timeIntegers[index] as NSString).integerValue * (60 ^ (count - 1 - index))
                            }
                        }
                        let lyricString: String = String(line[line.index(after: rightTimeIndex)..<line.endIndex])
                        if !lyricString.isEmpty{
                            lyrics.append(YuLyric(time: time, lyric: lyricString))
                        }
                    }
                }
                return lyrics
            }
        }
        return []
    }
}
