//
//  Search.swift
//  AnotherNetease
//
//  Created by tangyujun on 2022/5/12.
//

import Foundation

extension DataCenter {
    
    func search(newSearch: Bool){
        switch searcnType{
        case .SONG(_, let code):
            let sameInput = userInput == storagedUserInput
            if !sameInput || newSearch{
                storagedOffset = 0
            }
            let url = urlBuilder("/cloudsearch?keywords=\(userInput)&type=\(code)&offset=\(storagedOffset)")
            print(url)
            URLSession.shared.dataTask(with: URL(string: url)!) {(data, response, error) in
                if error != nil {
                    print("error: \(String(describing: error)), \(error!.localizedDescription)")
                    return //also notify app of failure as needed
                }
                do{
                    let data = try decoder.decode(SongSearchResponse.self, from: data!)
                    DispatchQueue.main.async {
                        if newSearch || !sameInput || !self.hasMore {
                            self.songSearchResult = []
                            for songSearchItem in data.result.songs {
                                self.songSearchResult.append(songSearchItem.toSong())
                            }
                        }else {
                            for songSearchItem in data.result.songs {
                                self.songSearchResult.append(songSearchItem.toSong())
                            }
                        }
                        self.storagedOffset = self.storagedOffset + data.result.songs.count
                        self.hasMore = data.result.songs.count == 30
                    }
                }catch let err{
                    print("error", err)
                }
            }.resume()
            storagedUserInput = userInput
        case .ARTIST(_, let code):
            URLSession.shared.dataTask(with: URL(string: "/cloudsearch?keywords=\(userInput)&type=\(code)")!) {(data, response, error) in
                if error != nil {
                    print("error: \(String(describing: error)), \(error!.localizedDescription)")
                    return //also notify app of failure as needed
                }
                do{
                    let data = try decoder.decode(ArtistSearchResponse.self, from: data!)
                    DispatchQueue.main.async {
                        self.artistSearchResult = data.result.artists
                    }
                }catch let err{
                    print("error", err)
                }
            }.resume()
        }
    }
}


struct SongSearchResponse: Codable{
    var code: Int16         // 状态码
    var result: SongSearchResult    // 结果集
}
struct SongSearchResult: Codable{
    var songs: [SongSearchResultSong]
    var songCount: Int64
}
struct SongSearchResultSong: Identifiable, Codable{
    var id: Int64
    var name: String
    var ar: [SongSearchResultArtist]
    
    func toSong() -> Song{
        var song: Song = Song(id: id,name: name, artists: [])
        for artist in ar {
            let artistItme: Artist = Artist(id: artist.id,name: artist.name,picUrl: "", albumSize: 0)
            song.artists.append(artistItme)
        }
        return song
    }
}
struct SongSearchResultArtist: Identifiable, Codable{
    var id: Int64           // id
    var name: String        // 姓名
}

struct ArtistSearchResponse: Codable{
    var code: Int16         // 状态码
    var result: ArtistSearchResult    // 结果集
    
    struct ArtistSearchResult: Codable{
        var artists: [Artist]
    }
}
