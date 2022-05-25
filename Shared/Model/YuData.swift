//
//  YuData.swift
//  Yu
//
//  Created by tangyujun on 2022/5/24.
//

import Foundation
import AVFoundation

class YuData: ObservableObject{
    //MARK: 播放器相关
    var player: AVPlayer?
    // 音量
    @Published var volume: Float = (loadVolume()){
        didSet { saveVolume() }
    }
    // MARK: 播放状态相关
    @Published var playlist: [YuSong] = (loadPlayList()){
        didSet { savePlayList() }
    }
    @Published var isPlaying: Bool = false
    @Published var current: Int = -1        // 当前正在播放歌曲在播放列表的序列
    @Published var currentSource: YuSource?   // 当前正在播放歌曲的资源信息,
    @Published var currentSong: YuSong?       // 当前正在播放的歌曲信息
    @Published var lyrics: [Lyric] = []     // 歌词
    @Published var loopType: Int = 1        // 0: 单曲循环, 1: 循环播放, 2: 随机播放
    @Published var topLyric: String = ""        // 刚播放过的歌词
    @Published var currentLyric: String = ""    // 当前显示歌词
    @Published var bottomLyric: String = ""     // 底部歌词
    @Published var emptyLyric: Bool = true  // 是否没有歌词
    @Published var playSeconds: Int = 0     // 播放进度
    
    
    
    // MARK: 界面状态相关
    @Published var viewType: YuViewType = .PLAYLIST
    
    
    // MARK: 搜索相关
    var keyword: String = ""
    @Published var searchResults: [YuSong] = []
    
    // MARK: 收藏相关
    @Published var favorites: [YuSong] = (loadFavorite()){
        didSet { saveFavorite() }
    }

}
