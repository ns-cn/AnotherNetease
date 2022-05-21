//
//  Playing.swift
//  AnotherNetease
//
//  Created by tangyujun on 2022/5/12.
//

import Foundation


// 拓展数据中心与正在播放相关的内容
extension DataCenter {
    
    func removeRows(_ offsets: Int){
        playlist.remove(at: offsets)
    }
    func deleteRow(at offsets: IndexSet) {
        playlist.remove(atOffsets: offsets)
     }
    func play(song: Song){
        for index in 0..<playlist.count{
            if playlist[index].id == song.id {
                current = index
                currentSong = playlist[current]
                lyrics.removeAll()
                return
            }
        }
        var newItem: Song = Song(id: song.id, name: song.name, artists: [])
        for artist in song.artists {
            newItem.artists.append(Artist(id: artist.id, name: artist.name, picUrl: "", albumSize: 0))
        }
        playlist.append(newItem)
        current = playlist.count - 1
        currentSong = playlist[current]
        print(lyrics)
    }
    
    func getUrl(songId: Int64){
        let url: String = urlBuilder("/song/url?id=\(songId)")
        URLSession.shared.dataTask(with: URL(string: url)!) {(data, response, error) in
            if error != nil {
                print("error: \(error!.localizedDescription)")
                print("cause by url: ", url)
                return //also notify app of failure as needed
            }
            do{
                let parsed = try decoder.decode(UrlQueryResponse.self, from: data!)
                for urlQueryItem in parsed.data{
                    if songId == urlQueryItem.id{
                        DispatchQueue.main.sync {
                        }
                    }
                }
            }catch let err{
                print("error", err)
                print("cause by url: ", url)
            }
        }
    }
    
    func refreshUrl() -> [Source]{
        let id: Int64? = self.currentSong?.id
        if id != nil{
            let url: String = urlBuilder("/song/url?id=\(id!)&realIP=116.25.146.177")
            var sources: [Source] = []
            URLSession.shared.dataTask(with: URL(string: url)!) {(data, response, error) in
                if error != nil {
                    print("error: \(error!.localizedDescription)")
                    print("cause by url: ", url)
                    return //also notify app of failure as needed
                }
                do{
                    let parsed = try decoder.decode(UrlQueryResponse.self, from: data!)
                    for urlQueryItem in parsed.data{
                        if id == urlQueryItem.id && urlQueryItem.url != nil{
                            sources.append(Source(quality: "\(urlQueryItem.br/1000)K", url: urlQueryItem.url!))
                        }
                    }
                }catch let err{
                    print("error", err)
                    print("cause by url: ", url)
                }
            }
            return sources
        }
        return []
    }
}

extension Song{
    
}

struct UrlQueryResponse: Codable{
    var code: Int16
    var data: [UrlQueryItemResponse]
}

struct UrlQueryItemResponse: Codable{
    var id: Int64
    var br: Int64
    var url: String?
}
