//
//  SearchView.swift
//  AnotherNetease
//
//  Created by tangyujun on 2022/5/16.
//

import SwiftUI
import AVFoundation

struct SearchView: View {
    @EnvironmentObject var datacenter: DataCenter
    @Binding var audioPlayer: AVPlayer?
    @Binding var isPlaying: Bool
    @Binding var progress: Double
    
    @State var hoverMore: Bool = false
    var body: some View {
        MusicDisplayView(viewType: .SEARCH, audioPlayer: $audioPlayer, isPlaying: $isPlaying, progress: $progress)
            .navigationTitle("搜索")
    }
}
