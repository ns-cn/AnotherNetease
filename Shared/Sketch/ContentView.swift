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
    var body: some View {
        ResponsiveView{prop in
            VStack{
                switch data.viewType{
                case .SEARCH:
                    ScrollView{
                        
                    }
                case .LIKE:
                    YuFraviteView()
                case .TOP:
                    YuExploreView()
                default:
                    YuFraviteView()
                }
                
            }
        }
        .ignoresSafeArea(.container, edges: .leading)
    }
}
