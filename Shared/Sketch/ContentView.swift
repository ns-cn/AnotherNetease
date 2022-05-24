//
//  ContentView.swift
//  Shared
//
//  Created by tangyujun on 2022/5/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @ObservedObject var data: YuData = YuData()
    
    
    @ObservedObject var datacenter: DataCenter = DataCenter()
    @State var isSideShow: Bool = false
    @State var audioPlayer: AVPlayer?
//    @State var player: AVAudioPlayer?
    @State var progress: Double = 0
    // 播放器状态
    @State var isPlaying: Bool = false
    
    
    @State var warn: Bool = false
    @State var viewType: ContentViewType = .FAVORITE
    
    @State var songToDisplay: [Song] = []
    var body: some View {
        ResponsiveView{prop in
            HStack{
                if prop.isLandscape && prop.size.width > 670{
                    YuOldSideBar(viewType: $viewType, isSideShow: $isSideShow, songToDisplay: $songToDisplay, prop: prop)
                        .environmentObject(datacenter)
                }else{
                    YuSideBar(prop: prop)
                        .environmentObject(data)
                }
                MainContentView(isSideShow: $isSideShow, audioPlayer: $audioPlayer, progress: $progress, isPlaying: $isPlaying, viewType: $viewType, songToDisplay: $songToDisplay, prop: prop)
                    .environmentObject(datacenter)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 480, minHeight: 320)
        .ignoresSafeArea(.container, edges: .leading)
    }
}
