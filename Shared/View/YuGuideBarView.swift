//
//  SideBar.swift
//  Yu
//
//  Created by tangyujun on 2022/5/24.
//

import SwiftUI

struct YuVGuideBarView: View{
    @EnvironmentObject var data: YuData
    var prop: Properties
    var body: some View {
        VStack{
            LogoView()
            HStack(){
                TextField(text: $data.keyword){}
                Button {
                    print(data.keyword)
                } label: {
                    Image(systemName: "magnifyingglass")
                }

            }
            guideButton(image: "heart.fill", text: "收藏") {
                
            }
            guideButton(image: "heart.fill", text: "收藏") {
                
            }
            guideButton(image: "heart.fill", text: "收藏") {
                
            }
            Spacer()
        }
        .frame(width: (prop.isLandscape ? prop.size.width : prop.size.height)/4 > 300 ? 300 :
                    (prop.isLandscape ? prop.size.width : prop.size.height)/4)
    }
    
    @ViewBuilder
    func guideButton(image: String, text: String, action: @escaping ()->Void) -> some View{
        Button(action: action) {
            HStack{
                Image(systemName: image)
                Text(text)
            }
        }

    }
}

struct YuHGuideBarView: View{
    @EnvironmentObject var data: YuData
    var prop: Properties
    var body: some View {
        TabView(selection: $data.viewType) {
            NavigationView{
                NavigationLink(destination: YuSearchView()){
                    Text("sdfsd")
                }
            }
            YuSearchView()
                .tabItem{
                    Text("SearchTab")
                }
            
            YuExploreView()
                .tabItem {
                    HStack{
                        Text("播放")
                        Image(systemName: "play.fill")
                            .foregroundColor(.blue)
                    }
                }
            
            YuFraviteView()
                .tabItem{
                    Text("FraviteTab")
                }
        }
    }
    
    @ViewBuilder
    func guideButton(image: String, text: String, action: @escaping ()->Void) -> some View{
        Button(action: action) {
            VStack{
                Image(systemName: image)
                Text(text)
            }
        }

    }
}



struct LogoView: View {
    @State var hoverTitle: Bool = false
    var body: some View {
        Group {
            ZStack{
                HStack {
                    LogoText(text: "网", degrees: 30)
                    LogoText(text: "愈", degrees: -30)
                    LogoText(text: "云", degrees: 30)
                }
                .foregroundColor(.white)
                .float(color2: .green)
                .frame(maxWidth: .infinity, alignment: .center)
                Text("by tangyujun.com")
                    .font(.subheadline)
                    .blur(radius: 0.4)
                    .opacity(0.1)
//                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)
                    .float()
            }
            .onHover(perform: { hover in
                withAnimation(.easeInOut) {
                    hoverTitle = hover
                }
            })
            .frame(maxHeight: 56)
        }
    }
    
    @ViewBuilder
    func LogoText(text: String, degrees: Double) -> some View{
        Text(text)
            .font(.largeTitle)
            .fontWeight(.bold)
            .scaleEffect(hoverTitle ? 1.1 : 1)
            .rotation3DEffect(Angle(degrees: degrees), axis: (x: 1, y: 1, z: 0))
            .rotationEffect(Angle(degrees: hoverTitle ? degrees : 0))
    }
}
