//
//  SideBar.swift
//  Yu (iOS)
//
//  Created by tangyujun on 2022/5/23.
//

import SwiftUI

struct SideBar: View {
    @Binding var showMenu: Bool
    var prop: Properties
    var body: some View {
        ScrollView {
            VStack{
                Text("hello")
            }
            .padding()
        }
        .frame(width: (prop.isLandscape ? prop.size.width : prop.size.height)/4 > 300 ? 300 :
                (prop.isLandscape ? prop.size.width : prop.size.height)/4)
        .background{
            Color.gray
                .ignoresSafeArea()
        }
    }
}
