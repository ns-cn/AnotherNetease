//
//  PlayController.swift
//  AnotherNetease
//
//  Created by tangyujun on 2022/5/13.
//

import SwiftUI
import AVFoundation

struct PlayController: View {
    
    @EnvironmentObject var datacenter: DataCenter
    @Binding var progress: Double
    @Binding var isPlaying: Bool
    @Binding var isSideShow: Bool
    @Binding var audioPlayer: AVPlayer?
    
    @State var hoverVolume: Bool = false
    @State var hoverAll: Bool = false
    @State var hoverSide: Bool = false
    @State var hoverPin: Bool = false
    @State var isSliding: Bool = false
    @AppStorage("com.tangyujun.app.an.pinLyric") var pinLyric: Bool = true

    let loopIamge: [String] = ["repeat.1", "repeat", "shuffle"]
//    var observer: PlayStatusObserver?
    
    var body: some View {
        let volumeBinding = Binding<Float>(get: {
            self.datacenter.volume
        }, set: {
            self.datacenter.volume = $0
            self.audioPlayer?.volume = self.datacenter.volume
        })
        VStack{
            Slider(value: $progress, onEditingChanged: { isEditing in
                isSliding = isEditing
                if let totalTime = self.audioPlayer?.currentItem?.duration {
                    let totalSec = CMTimeGetSeconds(totalTime)
                    let playTimeSec = totalSec * progress
                    let currentTime = CMTimeMake(value: Int64(playTimeSec), timescale: 1)
                    self.audioPlayer!.seek(to: currentTime, completionHandler: { (finished) in
                    })
                }else{
                    progress = 0
                }
            })
            .font(.subheadline)
            .offset(x: 0, y: -5)
            ZStack{
                HStack {
                    VStack(alignment: .leading){
                        if datacenter.currentSong != nil {
                            Text(datacenter.currentSong!.name)
                                .font(.system(size: (pinLyric && !hoverAll && datacenter.emptyLyric) ? 20 : 18))
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .frame(maxWidth: !pinLyric || hoverAll || !datacenter.emptyLyric ? 180 : .infinity,
                                       alignment: !pinLyric || hoverAll || !datacenter.emptyLyric ? .leading : .center)
                                .float()
                            Text(datacenter.currentSong?.artistsDisplay() ?? "")
                                .lineLimit(1)
                                .frame(maxWidth: !pinLyric || hoverAll || !datacenter.emptyLyric ? 180 : .infinity,
                                       alignment: !pinLyric || hoverAll || !datacenter.emptyLyric ? .leading : .center)
                                .float()
                        }else{
                            Text("网愈云")
                                .font(.system(size: !(pinLyric && !hoverAll && datacenter.emptyLyric) ? 20 : 18))
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .frame(maxWidth: !pinLyric || hoverAll || !datacenter.emptyLyric ? 180 : .infinity,
                                       alignment: !pinLyric || hoverAll || !datacenter.emptyLyric ? .leading : .center)
                                .float()
                            Text("治愈你的心灵~")
                                .lineLimit(1)
                                .frame(maxWidth: !pinLyric || hoverAll || !datacenter.emptyLyric ? 180 : .infinity,
                                       alignment: !pinLyric || hoverAll || !datacenter.emptyLyric ? .leading : .center)
                                .float()
                        }
                        Spacer()
                    }
                    .padding(.leading, 6)
                    Spacer()
                }
                HStack{
                    VStack{
                        Text(datacenter.topLyric)
                            .rotation3DEffect(Angle(degrees: 30), axis: (x: 1, y: 0, z: 0), anchor: .bottom)
                            .float()
                            .blur(radius: 1)
                        Text(datacenter.currentLyric)
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                            .float()
                        Text(datacenter.bottomLyric)
                            .rotation3DEffect(Angle(degrees: -30), axis: (x: 1, y: 0, z: 0), anchor: .top)
                            .float()
                            .blur(radius: 1)
                    }
                }
                .offset(x: 0, y: -10)
                .opacity(hoverAll || !pinLyric || datacenter.emptyLyric ? 0 : 1)
                
                HStack{
                    Spacer()
                    // 音质选择
//                    Picker("", selection: $datacenter.currentSource) {
//                        ForEach(datacenter.currentSong?.sources ?? []){source in
//                            Text(source.quality).tag(source.quality)
//                        }
//                    }
//                    .frame(width: 66)
                    Image(systemName: "music.quarternote.3")
                        .opacity(hoverVolume ? 1 : 0.05)
                        .scaleEffect(1.3)
                        .float(radius: 0)
                        .foregroundColor(pinLyric ? .black : .gray.opacity(0.5))
                        .onHover { hover in
                            withAnimation(.easeInOut) {
                                hoverVolume = hover
                            }
                        }
                        .onTapGesture {
                            pinLyric.toggle()
                        }
                    Image(systemName: loopIamge[datacenter.loopType])
                        .opacity(hoverVolume ? 1 : 0.05)
                        .scaleEffect(1.3)
                        .float(radius: 0)
                        .onTapGesture {
                            datacenter.loopType = (datacenter.loopType + 1) % 3
                        }
                        .onHover { hover in
                            withAnimation(.easeInOut) {
                                hoverVolume = hover
                            }
                        }
                        
                    Slider(value: volumeBinding)
                        .font(.subheadline)
                        .opacity(hoverVolume ? 1 : 0.05)
                        .frame(width: 64)
                        .float()
                        .onHover { hover in
                            withAnimation(.easeInOut) {
                                hoverVolume = hover
                            }
                        }
                        .zIndex(0)
                    VStack{
                        Image(systemName: "sidebar.right")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .onHover(perform: { hover in
                                hoverSide = hover
                            })
                            .onTapGesture {
                                withAnimation(.easeInOut){
                                    isSideShow.toggle()
                                }
                            }
                            .float(radius: 0, shadowRadius: isSideShow ? 4 : 2, offset: isSideShow ? 4 : 2)
                            .scaleEffect(hoverSide ? 1.2 : 1)
                            .padding(.trailing, 14)
                    }
                }
                .padding(.bottom, 6)
                HStack {
                    PalyerControllerButton(imageSystemName: "chevron.left.2")
                        .onTapGesture {
                            var offset: Int = -1
                            if datacenter.loopType == 2{
                                offset = Int(arc4random_uniform(UInt32(datacenter.playlist.count)))
                            }
                            playOffset(offset: offset)
                        }
                    PalyerControllerButton(imageSystemName: isPlaying ? "pause.fill" : "play")
                        .onTapGesture {
                            withAnimation(.easeInOut){
                                if datacenter.currentSong == nil{
                                    playOffset(offset: 0)
                                }else if isPlaying{
                                    isPlaying = false
                                    audioPlayer?.pause()
                                }else{
                                    isPlaying = true
                                    audioPlayer?.play()
                                }
                            }
                        }
                    PalyerControllerButton(imageSystemName: "chevron.right.2")
                        .onTapGesture {
                            var offset: Int = 1
                            if datacenter.loopType == 2{
                                offset = Int(arc4random_uniform(UInt32(datacenter.playlist.count)))
                            }
                            playOffset(offset: offset)
                        }
                }
                .padding(.bottom, 6)
                .opacity(hoverAll || !pinLyric ? 1 : 0)
            }
            .padding(.bottom, 3)
            .frame(maxHeight: 45)
        }
        .onHover(perform: { hover in
            withAnimation(.easeInOut) {
                hoverAll = hover
            }
        })
        .background(){
            Color.black.opacity(0.1)
        }
        .rotation3DEffect(Angle(degrees: hoverAll ? 10 : 0), axis: (x: 1, y: 0, z: 0), anchor: .bottom)
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
                    print("error: \(error!.localizedDescription)")
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

struct LyricView: View{
    var body: some View{
        Text("歌词显示")
    }
}

struct PalyerControllerButton: View{
    
    @State var hover: Bool = false
    var imageSystemName: String
    init(imageSystemName: String){
        self.imageSystemName = imageSystemName
    }
    
    var body: some View{
        Image(systemName: imageSystemName)
            .resizable()
            .float(radius: 0, shadowRadius: hover ? 4 : 2, offset: hover ? 4 : 2)
            .scaleEffect(hover ? 1.2 : 1)
            .frame(width: 18, height: 18)
            .padding(.all, 14)
            .background(content: {
                Color.green.opacity(hover ? 0.5 : 0.7)
            })
            .float(shadowRadius: hover ? 4 : 2, offset: hover ? 4 : 2)
            .onHover { hover in
                self.hover = hover
            }
    }
}

extension PlayController{
    func PlayOrPause() {
        isPlaying.toggle()
        if isPlaying{
            audioPlayer?.pause()
        }else{
            audioPlayer?.play()
        }
    }
}

struct PlayController_Previews: PreviewProvider {
    static var previews: some View {
        PlayController(progress: .constant(0), isPlaying: .constant(true), isSideShow: .constant(true), audioPlayer: .constant(nil))
    }
}
