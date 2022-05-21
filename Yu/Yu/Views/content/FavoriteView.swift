//
//  Favorite.swift
//  AnotherNetease
//
//  Created by tangyujun on 2022/5/16.
//

import SwiftUI
import AVFoundation

struct FavoriteView: View {
    @EnvironmentObject var datacenter: DataCenter
    @Binding var audioPlayer: AVPlayer?
    @Binding var isPlaying: Bool
    @Binding var progress: Double
    @Binding var songToDisplay: [Song]
    
    @State var hoverMore: Bool = false
    var body: some View {
        MusicDisplayView(viewType: .FAVORITE, audioPlayer: $audioPlayer, isPlaying: $isPlaying, progress: $progress)
            .navigationTitle("收藏")
    }
}
