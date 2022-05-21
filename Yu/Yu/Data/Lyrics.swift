//
//  Lyrics.swift
//  AnotherNetease
//
//  Created by tangyujun on 2022/5/18.
//

import Foundation

extension DataCenter{
    // 歌词相关功能,主要是获取歌词
    
    func refreshLyrics() -> [Lyric]{
        if let id: Int64 = self.currentSong?.id{
            let url: String = urlBuilder("/lyric?id=\(id)&realIP=116.25.146.177")
            var lyrics: [Lyric] = []
            URLSession.shared.dataTask(with: URL(string: url)!) {(data, response, error) in
                if error != nil {
                    print("error: \(String(describing: error)), \(error!.localizedDescription)")
                    print("cause by url: ", url)
                    return //also notify app of failure as needed
                }
                do{
                    let parsed = try decoder.decode(LyricResponse.self, from: data!)
                    lyrics = parsed.lrc?.toLyrics() ?? []
                }catch let err{
                    print("error", err)
                    print("cause by url: ", url)
                }
            }.resume()
            return lyrics
        }
        return []
    }
}


struct LyricResponse: Codable{
    var lrc: LyricResponseDetail?
}

struct LyricResponseDetail: Codable{
    var lyric: String?
    
    func toLyrics() -> [Lyric]{
        if (lyric != nil){
            if let lines = lyric?.components(separatedBy: ["\n"]){
                var lyrics: [Lyric] = []
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
                            lyrics.append(Lyric(time: time, lyric: lyricString))
                        }
                    }
                }
                return lyrics
            }
        }
        return []
    }
}
