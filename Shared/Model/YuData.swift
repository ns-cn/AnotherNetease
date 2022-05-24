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
    @Published var volume: Float = (UserDefaults.standard.float(forKey: "com.tangyujun.app.an.volume")){
        didSet {
            UserDefaults.standard.set(volume, forKey: "com.tangyujun.app.an.volume")
        }
    }
    
}
