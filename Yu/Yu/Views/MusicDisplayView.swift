//
//  SwiftUIView.swift
//  AnotherNetease
//
//  Created by tangyujun on 2022/5/12.
//

import SwiftUI
import AVFoundation

struct MusicDisplayView: View {
    var viewType: ContentViewType
    @EnvironmentObject var datacenter: DataCenter
    @Binding var audioPlayer: AVPlayer?
    @Binding var isPlaying: Bool
    @Binding var progress: Double
    
    @State var hoverMore: Bool = false
    var body: some View {
        HStack{
            ScrollView(.vertical, showsIndicators: false){
                switch viewType {
                case .SEARCH:
                    ForEach(datacenter.songSearchResult){song in
                        SongCard(song: song, isPlaying: $isPlaying, progress: $progress, audioPlayer: $audioPlayer)
                            .environmentObject(datacenter)
                    }
                default:
                    ForEach(datacenter.favorites){song in
                        SongCard(song: song, isPlaying: $isPlaying, progress: $progress, audioPlayer: $audioPlayer)
                            .environmentObject(datacenter)
                    }
                }
                if datacenter.hasMore && viewType == .SEARCH{
                    Group {
                        Image(systemName: "chevron.compact.down")
                            .frame(width: 15, height: 24)
                    }
                    .frame(maxWidth: .infinity)
                    .background {
                        Color.gray.opacity(hoverMore ? 0.5 : 0.2)
                    }
                    .onHover { hover in
                        hoverMore = hover
                    }
                    .onTapGesture {
                        datacenter.search(newSearch: false)
                    }
                }
            }
            Spacer()
        }
        .frame(minWidth: 480)
    }
}


struct SongCard: View{
    
    var song: Song
    
    @Binding var isPlaying: Bool
    @Binding var progress: Double
    @Binding var audioPlayer: AVPlayer?
    
    @EnvironmentObject var datacenter: DataCenter
    var body: some View{
        HStack{
            Text(song.name)
                .font(.headline)
                .lineLimit(2)
            Spacer()
            Text(toString(artists: song.artists))
                .lineLimit(2)
            Spacer()
            SongCardButtonView(imageSystemName: "play")
                .onTapGesture {
                    play(item: song)
                }
            SongCardButtonView(imageSystemName: "plus")
                .onTapGesture {
                    for playItem in datacenter.playlist{
                        if playItem.id == song.id{
                            return
                        }
                    }
                    datacenter.playlist.append(song)
                }
            SongCardButtonView(imageSystemName: datacenter.isFavorite(id: song.id) ? "heart.fill" : "heart")
                .foregroundColor(datacenter.isFavorite(id: song.id) ? .red : .black)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        datacenter.toggleFavorite(song: song)
                    }
                }
        }
        .frame(maxHeight: .infinity)
        .padding(.all, 15)
        .background(Color.green.opacity(0.6))
        .float()
        .padding(.horizontal, 5)
        .onTapGesture {
            print(song)
        }
    }
    
    func toString(artists: [Artist]) -> String{
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
                    print("error: \(error!.localizedDescription)")
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

struct SongCardButtonView: View{
    @State var hover: Bool = false
    var imageSystemName: String
    var body: some View{
        Image(systemName: imageSystemName)
            .resizable()
            .scaledToFit()
            .frame(width: hover ? 15 : 12)
            .aspectRatio(contentMode: .fit)
            .onHover { hover in
                self.hover = hover
            }
            .background(content: {
                if hover {
                    Rectangle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.green.opacity(0.8))
                        .blur(radius: 6)
                        .float(radius: 7)
                }
            })
            .frame(width: 15, height: 15)
            .float(radius: 0)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MusicDisplayView(viewType: .SEARCH, audioPlayer: .constant(nil),isPlaying: .constant(false), progress: .constant(0))
    }
}

