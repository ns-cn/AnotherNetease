//
//  Home.swift
//  Yu (iOS)
//
//  Created by tangyujun on 2022/5/23.
//

import SwiftUI
import AVFoundation

struct Home: View {
    
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
                if prop.isLandscape && prop.size.width > 768{
                    LeftPartView(viewType: $viewType, isSideShow: $isSideShow, songToDisplay: $songToDisplay, prop: prop)
                        .environmentObject(datacenter)
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                        .float()
                }
                MainContentView(isSideShow: $isSideShow, audioPlayer: $audioPlayer, progress: $progress, isPlaying: $isPlaying, viewType: $viewType, songToDisplay: $songToDisplay)
                    .environmentObject(datacenter)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay{
//                ZStack(alignment: .leading){
//                    if !prop.isLandscape{
//                        Color.black
//                            .opacity(0.25)
//                            .ignoresSafeArea()
//                            .onTapGesture {
//                                withAnimation{
//                                    showMenu.toggle()
//                                }
//                            }
//                        SideBar(showMenu: $showMenu, prop: prop)
//                            .offset(x: showMenu ? 0 : -300)
//                    }
//                }
            }
        }
        .ignoresSafeArea(.container, edges: .leading)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
