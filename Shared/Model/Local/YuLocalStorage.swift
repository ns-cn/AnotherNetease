//
//  YuLocalLoad.swift
//  Yu
//
//  Created by tangyujun on 2022/5/25.
//

import Foundation

extension YuData{
    
    // MARK: 音量相关本地持久化
    static func loadVolume() -> Float {
        UserDefaults.standard.float(forKey: "com.tangyujun.app.yu.volume")
    }
    func saveVolume() -> Void {
        UserDefaults.standard.set(volume, forKey: "com.tangyujun.app.an.volume")
    }
    
    // MARK: 播放列表本地持久化
    static func loadPlayList() -> [YuSong]{
        do{
            let playlistjson = UserDefaults.standard.data(forKey: "com.tangyujun.app.yu.playlist") ?? "[]".data(using: .utf8)!
            return try decoder.decode([YuSong].self, from: playlistjson)
        }catch let err{
            print("fail to load playlist: ", err)
            return []
        }
    }
    func savePlayList() -> Void{
        do {
            let playlistjson = try encoder.encode(self.playlist)
            UserDefaults.standard.set(playlistjson, forKey: "com.tangyujun.app.yu.playlist")
        }catch let err{
            print("fail to storage playlist: ", err)
        }
    }
    
    // MARK: 收藏列表本地持久化
    static func loadFavorite() -> [YuSong]{
        do{
            let favoritesjson = UserDefaults.standard.data(forKey: "com.tangyujun.app.yu.favorites") ?? "[]".data(using: .utf8)!
            return try decoder.decode([YuSong].self, from: favoritesjson)
        }catch let err{
            print("fail to load playlist: ", err)
            return []
        }
    }
    func saveFavorite() -> Void{
        do {
            let favoritesjson = try encoder.encode(self.favorites)
            UserDefaults.standard.set(favoritesjson, forKey: "com.tangyujun.app.yu.favorites")
        }catch let err{
            print("fail to storage playlist: ", err)
        }
    }
    
}
