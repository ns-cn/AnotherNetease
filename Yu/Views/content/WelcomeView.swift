//
//  WelcomeView.swift
//  AnotherNetease
//
//  Created by tangyujun on 2022/5/16.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        HStack{
            VStack{
                Text("Welcome~")
                    .fontWeight(.bold)
                    .font(.system(size: 45))
                    .rotation3DEffect(Angle(degrees: 30), axis: (x: 1, y: 1, z: 0))
            }
        }
        .navigationTitle("欢迎使用[网愈云]")
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
