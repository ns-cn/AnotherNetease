//
//  YuRemote.swift
//  Yu
//
//  Created by tangyujun on 2022/5/26.
//

import Foundation

// json解码
var decoder = JSONDecoder()
// json编码
var encoder = JSONEncoder()

extension YuData {
    // MARK: [API] URL构建
    func urlBuilder(_ path: String) -> String{
        return "https://api.tangyujun.com\(path)"
    }
    
    // MARK: [API] 远程请求通用处理
    // 处理请求响应的
    func remoteHandle(url: String, printError: Bool = false,  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void){
        URLSession.shared.dataTask(with: URL(string: url)!) {(data, response, error) in
            if error != nil {
                if printError{
                    print("error: \(error!.localizedDescription)")
                    print("cause by url: ", url)
                }
                return
            }
            completionHandler(data, response, error)
        }.resume()
    }
    
    // MARK: [API] 远程请求转换json数据处理
    func remoteJsonHandler<T>(url: String, dataType type: T.Type, printError: Bool = false, completionHandler: @escaping (T?, Error?) -> Void) where T: Decodable{
        remoteHandle(url: url, printError: printError) { data, response, httpError in
            var parsed: T?
            if data != nil{
                var err: Error? = httpError
                do{
                    parsed = try decoder.decode(type, from: data!)
                }catch{
                    err = error
                }
                completionHandler(parsed, err)
            }
        }
    }
}

// MARK: [Model] 公共响应实体定义
struct YuRemoteResponseArtist: Codable{
    var id: Int64           // id
    var name: String        // 姓名
    var picUrl: String?      // 封面
    var albumSize: Int64?    // 专辑数量
    func toArtist() -> YuArtist{
        YuArtist(id: id, name: name)
    }
}

struct YuRemoteResponseSong: Codable{
    var id: Int64           // id
    var name: String        // 歌曲名称
    var artists: [YuRemoteResponseArtist]   // 歌手
}
