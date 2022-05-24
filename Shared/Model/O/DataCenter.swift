//
//  Netease.swift
//  AnotherNetease
//
//  Created by tangyujun on 2022/5/12.
//

import Foundation
import AVFoundation


var decoder = JSONDecoder()
var encoder = JSONEncoder()

enum SearchType{
    case SONG(String,Int16)
    case ARTIST(String, Int16)
}

let HOST: String = "https://api.tangyujun.com"

class DataCenter: ObservableObject {
    
    // 初始化相关
    @Published var volume: Float = (UserDefaults.standard.float(forKey: "com.tangyujun.app.an.volume")){
        didSet {
            UserDefaults.standard.set(volume, forKey: "com.tangyujun.app.an.volume")
        }
    }
    
    // 搜索相关
    var storagedUserInput: String = ""
    var storagedOffset: Int = 0
    
    let SONG: SearchType = SearchType.SONG("歌曲", 1)
    let ARTIST: SearchType = SearchType.ARTIST("歌手", 100)
    @Published var playlist: [Song] = (getStoraged()){
        didSet {
            do {
                let playlistjson = try encoder.encode(self.playlist)
                UserDefaults.standard.set(playlistjson, forKey: "com.tangyujun.app.an.playlist")
            }catch let err{
                print("fail to storage playlist: ", err)
            }
        }
    }
    @Published var topArtist: [Artist] = []
    
    // 正在播放相关
    @Published var current: Int = -1        // 当前正在播放歌曲在播放列表的序列
    @Published var currentSource: Source?   // 当前正在播放歌曲的资源信息, 资源地址
    @Published var currentSong: Song?       // 当前正在播放的歌曲信息
    @Published var lyrics: [Lyric] = []     // 歌词
    @Published var loopType: Int = 1   // 0: 单曲循环, 1: 循环播放, 2: 随机播放
    
    @Published var topLyric: String = ""
    @Published var currentLyric: String = ""
    @Published var bottomLyric: String = ""
    @Published var emptyLyric: Bool = true
    @Published var playSeconds: Int = 0{    // 当前播放的秒数
        didSet{
            var currentIndex = 0
            if playSeconds != 0{
                for index in 0..<lyrics.count{
                    let current = lyrics[index]
                    if playSeconds >= current.time{
                        if index == lyrics.count - 1 || playSeconds < lyrics[index + 1].time{
                            currentIndex = index
                        }
                    }
                }
            }
            topLyric = (currentIndex - 1) >= 0 ? lyrics[currentIndex - 1].lyric : ""
            currentLyric = lyrics.count > currentIndex ? lyrics[currentIndex].lyric : ""
            bottomLyric = lyrics.count > (currentIndex + 1) ? lyrics[currentIndex + 1].lyric : ""
            emptyLyric = topLyric.isEmpty && currentLyric.isEmpty && bottomLyric.isEmpty
//            print("----", topLyric, currentLyric, bottomLyric)
        }
    }
        
        
        
    // 收藏
    @Published var favorites: [Song] = (getFavorite()){
        didSet {
            do {
                let favoritesjson = try encoder.encode(self.favorites)
                UserDefaults.standard.set(favoritesjson, forKey: "com.tangyujun.app.an.favorites")
            }catch let err{
                print("fail to storage playlist: ", err)
            }
        }
    }
    
    // 搜索相关
    @Published var searcnType: SearchType = SearchType.SONG("歌曲", 1)
    @Published var songSearchResult: [Song] = []
    @Published var artistSearchResult: [Artist] = []
    @Published var hasMore: Bool = false
    @Published var keyword: String = ""
    @Published var userInput: String = "周杰伦"

    static func getStoraged() -> [Song]{
        do{
            let playlistjson = UserDefaults.standard.data(forKey: "com.tangyujun.app.an.playlist") ?? "[]".data(using: .utf8)!
            return try decoder.decode([Song].self, from: playlistjson)
        }catch let err{
            print("fail to load playlist: ", err)
            return []
        }
    }
    static func getFavorite() -> [Song]{
        do{
            let favoritesjson = UserDefaults.standard.data(forKey: "com.tangyujun.app.an.favorites") ?? "[]".data(using: .utf8)!
            return try decoder.decode([Song].self, from: favoritesjson)
        }catch let err{
            print("fail to load playlist: ", err)
            return []
        }
    }
    
    
    func toggleFavorite(song: Song){
        if isFavorite(id: song.id){
            favorites.removeAll { item in
                item.id == song.id
            }
        }else{
            favorites.append(song)
        }
    }
    
    // 判断歌曲是否被收藏
    func isFavorite(id: Int64) -> Bool{
        for favorite in favorites {
            if favorite.id == id{
                return true
            }
        }
        return false
    }
}

struct Song: Identifiable, Codable{
    var id: Int64       // id
    var name: String    // 歌曲名称
    var artists: [Artist]   // 歌手
    var sources: [Source] = []   // 歌曲地址
    
    func artistsDisplay() -> String{
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

struct Source: Identifiable, Codable, Hashable{
    var id: UUID = UUID()
    var quality: String
    var url: String
}

struct Artist: Identifiable,Codable{
    var id: Int64           // id
    var name: String        // 姓名
    var picUrl: String      // 封面
    var albumSize: Int64    // 专辑数量
}

struct Lyric: Identifiable {
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
func urlBuilder(_ path: String) -> String{
    return (HOST + path).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
}

//class SongPlayerItem: AVPlayerItem{
//    var id: Int64       // id
//    var name: String    // 歌曲名称
//    var artists: [Artist]   // 歌手
//    init(id: Int64, name: String, artists: [Artist] ){
//        self.id = id
//        self.name = name
//        self.artists = artists
//    }
//    func artistsDisplay() -> String{
//        var builder: String = ""
//        var isFirst: Bool = true
//        for artist in artists {
//            if isFirst {
//                builder += "\(artist.name)"
//                isFirst = false
//            }else{
//                builder += ",\(artist.name)"
//            }
//        }
//        return builder
//    }
//}
