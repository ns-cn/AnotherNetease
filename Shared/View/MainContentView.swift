//
//  ContentView.swift
//  AnotherNetease
//
//  Created by tangyujun on 2022/5/12.
//

import SwiftUI
import AVFoundation

struct MainContentView: View {
    @EnvironmentObject var datacenter: DataCenter
    @Binding var isSideShow: Bool
    @Binding var audioPlayer: AVPlayer?
//    @Binding var player: AVAudioPlayer?
    @Binding var progress: Double
    // 播放器状态
    @Binding var isPlaying: Bool
    
    
    @Binding var viewType: ContentViewType
    @Binding var songToDisplay: [Song]
    var body: some View {
        ZStack (alignment: .trailing){
            MainView(isSideShow: $isSideShow, progress: $progress, isPlaying: $isPlaying, audioPlayer: $audioPlayer, viewType: $viewType, songToDisplay: $songToDisplay)
                .environmentObject(datacenter)
                .onAppear(){
                    
                }
            if isSideShow {
                Color.white.opacity(0.8)
                    .onTapGesture {
                        withAnimation(.easeInOut){
                            isSideShow = false
                        }
                    }
            }
            SideView(isSideShow: $isSideShow, isPlaying: $isPlaying, progress: $progress, audioPlayer: $audioPlayer)
                .environmentObject(datacenter)
                .padding(.top, 15)
                .padding(.bottom, 15)
                .float()
        }
//        .frame(minWidth: 725,minHeight: 490)
    }
}

struct MainView: View{
    @EnvironmentObject var datacenter: DataCenter

    @Binding var isSideShow: Bool
    
    @Binding var progress: Double
    // 播放器状态
    @Binding var isPlaying: Bool
    @Binding var audioPlayer: AVPlayer?
    
//    @Binding var warn: Bool
    @Binding var viewType: ContentViewType
    @Binding var songToDisplay: [Song]
    
    var body: some View{
        HStack{
//            LeftPartView(viewType: $viewType, isSideShow: $isSideShow, songToDisplay: $songToDisplay, prop: <#Properties#>)
//                .environmentObject(datacenter)
//            Divider()
            VStack{
                VStack{
                    switch self.viewType{
                    case .FAVORITE:
                        FavoriteView( audioPlayer: $audioPlayer,isPlaying: $isPlaying, progress: $progress, songToDisplay: $songToDisplay).environmentObject(datacenter)
                    case .SEARCH:
                        SearchView( audioPlayer: $audioPlayer,isPlaying: $isPlaying, progress: $progress)
                            .environmentObject(datacenter)
                    case .TPOARTIST:
                        TopArtistView().environmentObject(datacenter)
                    case .DOWNLOAD:
                        DownloadView()
                    case .WELCOME:
                        WelcomeView()
                    }
                    Spacer()
                    Divider()
                    PlayController(progress: self.$progress, isPlaying: self.$isPlaying, isSideShow: $isSideShow, audioPlayer: $audioPlayer)
                        .cornerRadius(8)
                        .float()
                }
                .padding(.all, 5)
            }
        }
    }
}

extension View {
    func float(radius: CGFloat = 8, color1: Color = .white.opacity(0.8), color2:Color = .gray.opacity(0.8),
               shadowRadius: CGFloat = 4, offset: CGFloat = 4) -> some View{
        return self
            .cornerRadius(radius)
            .shadow(color: color1, radius: shadowRadius, x: -offset, y: -offset)
            .shadow(color: color2, radius: shadowRadius, x: offset, y: offset)
    }
}


enum ContentViewType{
    case FAVORITE
    case SEARCH
    case TPOARTIST
    case DOWNLOAD
    case WELCOME
}
