//
//  SideView.swift
//  AnotherNetease
//
//  Created by tangyujun on 2022/5/13.
//

import SwiftUI
import AVFoundation


struct SideView: View{
    @EnvironmentObject var datacenter: DataCenter
    @Binding var isSideShow: Bool
    @Binding var isPlaying: Bool
    @Binding var progress: Double
    @Binding var audioPlayer: AVPlayer?
    var body: some View{
        HStack{
            ScrollView(showsIndicators: false){
                
                ForEach(0..<datacenter.playlist.count,id: \.self){index in
                    let song = datacenter.playlist[index]
                    HStack{
                        Text(song.name)
                            .font(.subheadline)
                            .lineLimit(2)
                        Spacer()
                        Text(song.artistsDisplay())
                            .padding(.trailing, 3)
                        Image(systemName: datacenter.isFavorite(id: song.id) ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(datacenter.isFavorite(id: song.id) ? .red.opacity(0.5) : .black)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    datacenter.toggleFavorite(song: song)
                                }
                            }
                            .float()
                        Image(systemName: "trash.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                            .onTapGesture(perform: {
                                if song.id == datacenter.currentSong?.id {
                                    playOffset(offset: 1, keepPlayingStatus: true)
                                }
                                withAnimation(.easeInOut) {
                                    datacenter.removeRows(index)
                                }
                            })
                            .float()
                    }
                    .padding(.all , 15)
                    .background(Color.green)
                    .frame(maxHeight: .infinity)
                    .float()
                    .padding(.vertical, 4)
                    .onTapGesture {
                        // 已经是当前歌曲,则直接播放
                        if song.id == datacenter.currentSong?.id {
                            if !isPlaying{
                                audioPlayer?.play()
                            }
                            return
                        }
                        // 播放新歌曲
                        play(item: song)
                    }
                }.onDelete(perform: datacenter.deleteRow)
            }
            if datacenter.playlist.count > 0 {
                HStack {
                    Spacer()
                    Image(systemName: "delete.backward.fill")
                        .resizable()
                        .frame(width: 12, height: 24)
                        .foregroundColor(.red)
                        .onTapGesture(perform: {
                            withAnimation(.easeInOut) {
                                audioPlayer?.pause()
                                datacenter.playlist = []
                                datacenter.currentSong = nil
                                datacenter.emptyLyric = true
                                datacenter.lyrics.removeAll()
                                datacenter.topLyric = ""
                                datacenter.currentLyric = ""
                                datacenter.bottomLyric = ""
                                progress = 0
                                isPlaying = false
                                isSideShow = false
                            }
                        })
                        .float()
                    Spacer()
                }
                .frame(width: 14)
                .float()
                .padding(.all, 4)
            }
        }
//        .background(content: {
//            Color.blue
//        })
        .cornerRadius(8)
        .frame(width: 320)
        .onTapGesture(perform: {
            withAnimation(.easeInOut) {
                isSideShow = false
            }
        })
//        .animation(.easeIn)
        .offset(x: isSideShow ? 0 : 320, y: 0)
    }
    
    
    func playOffset(offset: Int, keepPlayingStatus: Bool = false){
        if datacenter.playlist.count == 0{
            return
        }
        if datacenter.currentSong == nil {
            play(item: datacenter.playlist[0])
            return
        }
        let max: Int = datacenter.playlist.count
        var currentIndex: Int = 0
        for index in 0..<max {
            let song = datacenter.playlist[index]
            if datacenter.currentSong!.id == song.id{
                currentIndex = index
                break
            }
        }
        currentIndex += offset + max
        currentIndex %= max
        play(item: datacenter.playlist[currentIndex], keepPlayingStatus: keepPlayingStatus)
    }
    
    func newAvPlayer(url: URL){
        let item: AVPlayerItem = AVPlayerItem(url: url)
        self.audioPlayer = AVPlayer(playerItem: item)
        self.audioPlayer?.volume = datacenter.volume
        self.audioPlayer?.addPeriodicTimeObserver(forInterval: CMTime.init(value: CMTimeValue(1.0), timescale: CMTimeScale(1.0)), queue: DispatchQueue.main) {_ in
            let currt = CMTimeGetSeconds(audioPlayer!.currentTime())
            let total = CMTimeGetSeconds(audioPlayer!.currentItem?.asset.duration ?? CMTime.zero)
            self.progress = currt/total
            self.datacenter.playSeconds = Int(currt)
            let playerProgress = currt/total
            if playerProgress > 0.99{
                newAvPlayer(url: url)
                var offset: Int = datacenter.loopType
                if datacenter.loopType == 2{
                    offset = Int(arc4random_uniform(UInt32(datacenter.playlist.count)))
                }
                playOffset(offset: offset)
            }else{
                self.progress = currt/total
            }
        }
    }


    func play(item: Song, keepPlayingStatus: Bool = false){
        let oldStatus: Bool = isPlaying
        isPlaying = false
        datacenter.play(song: item)
//        var sources = datacenter.refreshUrl()
        let id: Int64? = datacenter.currentSong?.id
        if id != nil{
            let url: String = urlBuilder("/song/url?id=\(id!)&realIP=116.25.146.177")
            print(url)
            URLSession.shared.dataTask(with: URL(string: url)!) {(data, response, error) in
                if error != nil {
                    print("error: \(String(describing: error)), \(error!.localizedDescription)")
                    print("cause by url: ", url)
                    return //also notify app of failure as needed
                }
                do{
                    let parsed = try decoder.decode(UrlQueryResponse.self, from: data!)
                    var sources: [Source] = []
                    for urlQueryItem in parsed.data{
                        if id == urlQueryItem.id && urlQueryItem.url != nil{
                            sources.append(Source(quality: "\(urlQueryItem.br/1000)K", url: urlQueryItem.url!))
                        }
                    }
                    DispatchQueue.main.sync {
                        datacenter.currentSong?.sources = sources
                        print(datacenter.currentSong?.sources ?? [])
                        
                        if datacenter.currentSong?.sources.count ?? 0 > 0{
                            datacenter.currentSource = datacenter.currentSong?.sources[0]
                        }
                        let musicUrl = datacenter.currentSource?.url
                        if musicUrl == nil{
                            print("could not find any available url for \(datacenter.currentSong?.name ?? "")!")
                            return
                        }
                //        let musicUrl = "https://music.163.com/song/media/outer/url?id=\(songId).mp3"
                        let url: URL = URL(string: musicUrl!)!
                        let item: AVPlayerItem = AVPlayerItem(url: url)
                        if self.audioPlayer == nil{
                            newAvPlayer(url: url)
                        }
                        audioPlayer?.pause()
                        audioPlayer?.replaceCurrentItem(with: item)
                        audioPlayer?.seek(to: .zero, completionHandler: { _ in
                            if keepPlayingStatus{
                                if oldStatus{
                                    audioPlayer?.play()
                                    isPlaying = true
                                }
                            }else{
                                audioPlayer?.play()
                                isPlaying = true
                            }
                        })
                    }
                }catch let err{
                    print("error", err)
                    print("cause by url: ", url)
                }
            }.resume()
            
            let lyricUrl: String = urlBuilder("/lyric?id=\(id!)&realIP=116.25.146.177")
            print(url)
            var lyrics: [Lyric] = []
            URLSession.shared.dataTask(with: URL(string: lyricUrl)!) {(data, response, error) in
                if error != nil {
                    print("error: \(String(describing: error)), \(error!.localizedDescription)")
                    print("cause by url: ", url)
                    return //also notify app of failure as needed
                }
                do{
                    let parsed = try decoder.decode(LyricResponse.self, from: data!)
                    lyrics = parsed.lrc?.toLyrics() ?? []
//                    print(lyrics)
                    DispatchQueue.main.sync {
                        datacenter.lyrics.removeAll()
                        datacenter.lyrics.append(contentsOf: lyrics)
                    }
                }catch let err{
                    print("error", err)
                    print("cause by url: ", url)
                }
            }.resume()
        }
    }
}

struct SideView_Previews: PreviewProvider {
    static var previews: some View {
        SideView( isSideShow: .constant(true), isPlaying: .constant(false), progress: .constant(0), audioPlayer: .constant(nil))
    }
}
