//
//  File.swift
//  AnotherNetease
//
//  Created by tangyujun on 2022/5/12.
//

import Foundation

extension DataCenter {
    func getTopArtist(){
        URLSession.shared.dataTask(with: URL(string: urlBuilder("/top/artists?offset=0&limit=30"))!) {(data, response, error) in
            if error != nil {
                print("error: \(error!.localizedDescription)")
                return //also notify app of failure as needed
            }
            do{
                let data = try decoder.decode(TopArtistResponse.self, from: data!)
                DispatchQueue.main.async {
                    self.topArtist = data.artists
                }
            }catch let err{
                print("error", err)
            }
        }.resume()
    }
}

struct TopArtistResponse: Codable{
    let code: Int64         // 响应码
    let more: Bool          // 是否还有更多
    let artists: [Artist]   // 歌手
}
