//
//  SideBar.swift
//  Yu
//
//  Created by tangyujun on 2022/5/24.
//

import SwiftUI

struct YuSideBar: View {
    @EnvironmentObject var data: YuData
    var prop: Properties
    var body: some View {
        VStack{
            LogoView()
        }
        .frame(width: (prop.isLandscape ? prop.size.width : prop.size.height)/4 > 300 ? 300 :
                    (prop.isLandscape ? prop.size.width : prop.size.height)/4)
    }
}


struct YuOldSideBar: View {
    @EnvironmentObject var datacenter: DataCenter
    
    @Binding var viewType: ContentViewType
    @Binding var isSideShow: Bool
    @Binding var songToDisplay: [Song]
    var prop: Properties
    var body: some View {
        VStack{
            LogoView()
            GuideView(viewType: $viewType, isSideShow: $isSideShow, songToDisplay: $songToDisplay)
            Spacer()
        }
        .frame(width: (prop.isLandscape ? prop.size.width : prop.size.height)/4 > 300 ? 300 :
                    (prop.isLandscape ? prop.size.width : prop.size.height)/4)
    }
}
