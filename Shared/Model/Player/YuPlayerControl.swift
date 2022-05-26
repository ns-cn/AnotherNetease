//
//  YuPlayerControl.swift
//  Yu
//
//  Created by tangyujun on 2022/5/25.
//

import Foundation

enum PlayLoopType{
    case SINGLE     // 单曲循环
    case AHEAD      // 顺序播放
    case CIRCLE     // 列表循环
    case RANDOM     // 列表随机
    case NOPE       // 不循环
    case NOTSIGNED  // 未指定
}

extension YuData{
    
    
    func playNext(roundType: PlayLoopType = .NOTSIGNED){
        
        
    }
    
    func play(){
        
    }
    
    func puase(){
        
    }
}
