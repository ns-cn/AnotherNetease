//
//  Menu.swift
//  AnotherNetease
//
//  Created by tangyujun on 2022/5/13.
//

import SwiftUI


struct LeftPartView: View {
    @State var hoverSearch: Bool = false
    @State var hoverSetting: Bool = false
    
    @EnvironmentObject var datacenter: DataCenter
    @Binding var viewType: ContentViewType
    @Binding var isSideShow: Bool
    @Binding var songToDisplay: [Song]
    var prop: Properties
    var body: some View {
        VStack{
            // 头
            LogoView()
            // 网络
            GuideView(viewType: $viewType, isSideShow: $isSideShow, songToDisplay: $songToDisplay)
            
            Spacer()
            Group{
                HStack {
                    Image(systemName: "theatermasks.fill")
                        .resizable()
                        .frame(width: 28, height: 24)
                        .padding(8)
                        .scaleEffect(hoverSetting ? 1.2 : 1)
                        .foregroundColor( hoverSetting ? .cyan.opacity(0.8) : .black)
                        .float()
                        .onHover { hover in
                            withAnimation(.easeInOut) {
                                hoverSetting = hover
                            }
                        }
                        .onTapGesture {
                        }
                    Spacer()
                    Image(systemName: "pip.remove")
                        .resizable()
                        .frame(width: 28, height: 24)
                        .padding(8)
                        .scaleEffect(hoverSetting ? 1.2 : 1)
                        .foregroundColor( hoverSetting ? .cyan.opacity(0.8) : .black)
                        .float()
                        .onHover { hover in
                            withAnimation(.easeInOut) {
                                hoverSetting = hover
                            }
                        }
                        .onTapGesture {
//                            NSApplication.shared.terminate(0)
                        }
                }
            }
        }
        .frame(width: (prop.isLandscape ? prop.size.width : prop.size.height)/4 > 300 ? 300 :
                (prop.isLandscape ? prop.size.width : prop.size.height)/4)
    }
}



struct LogoView: View {
    @State var hoverTitle: Bool = false
    
//    @Binding var isSideShow: Bool
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
                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)
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



struct MenuView: View{
    
    var imageName: String
    var textDisplay: String
    @State var hover: Bool = false
    var body: some View{
        HStack{
            Image(systemName: imageName)
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.all, 15)
                .foregroundColor(.red.opacity(0.5))
                .float(radius: 15, color1: .white, color2: .gray)
            Text(textDisplay)
                .float()
//                .scaleEffect(hover ? 1.3 : 0)
            Spacer()
        }
        .background(content:{
            Color.gray.opacity(hover ? 0.5 : 0.3)
        })
        .cornerRadius(15)
        .padding(.all,2)
        .padding(.horizontal, 5)
        .float(radius: 15, color1: .white)
        .onHover { hover in
            self.hover = hover
        }
    }
}


struct GuideView: View {
    
    @EnvironmentObject var datacenter: DataCenter
    @State var hoverSearch: Bool = false
    
    
    
    @Binding var viewType: ContentViewType
    @Binding var isSideShow: Bool
    @Binding var songToDisplay: [Song]
    var body: some View {
        VStack {
            // 网络
            Group {
                HStack {
                    TextField(text: $datacenter.userInput){
                    }
                    .onSubmit({
                        self.viewType = .SEARCH
                        datacenter.search(newSearch: true)
                        songToDisplay = datacenter.songSearchResult
                    })
                    .font(.title2)
                    .padding(.all, 12)
                    .cornerRadius(15)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(alignment: .center)
                    .float(radius: 15, color1: .white.opacity(0.8), color2: .white.opacity(0.8))
                    .background(){
                        RoundedRectangle(cornerRadius: 4, style: .continuous).fill(Color.gray.opacity(0.3))
                    }
                    //                        .overlay(RoundedRectangle(cornerRadius: 4, style: .continuous).stroke(Color(red: 220 / 255, green: 220 / 255, blue: 220 / 255), lineWidth: 1)) //填充圆角边框
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .scaleEffect(hoverSearch ? 1.2 : 1)
                        .padding(.all, 15)
                        .foregroundColor(.red.opacity(0.5))
                        .onTapGesture {
                            self.viewType = .SEARCH
                            datacenter.search(newSearch: true)
                            songToDisplay = datacenter.songSearchResult
                        }
                        .onHover(perform: { hover in
                            withAnimation(.easeInOut) {
                                hoverSearch = hover
                            }
                        })
                        .background(content: {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color.gray.opacity(hoverSearch ? 0.5 : 0.3))
                        })
                        .cornerRadius(15)
                        .frame(width: 42, height: 42)
                        .float(radius: 4, color1: .white.opacity(0.8))
                }
                .padding(.all, 5)
                MenuView(imageName: "thermometer.sun", textDisplay: "近期热门")
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            viewType = .TPOARTIST
                            datacenter.getTopArtist()
                        }
                    }
                //                    MenuView(imageName: "music.mic", textDisplay: "top歌手")
            }
            // 个人
            Group {
                MenuView(imageName: "heart.fill", textDisplay: "收藏")
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            viewType = .FAVORITE
                            songToDisplay = datacenter.favorites
                        }
                    }
                MenuView(imageName: "music.note.list", textDisplay: "播放列表")
                    .onTapGesture {
                        withAnimation(.easeInOut){
                            isSideShow = true
                        }
                    }
            }
            Divider()
            // 本地
            Group {
                MenuView(imageName: "icloud.and.arrow.down.fill", textDisplay: "下载管理")
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            viewType = .DOWNLOAD
                        }
                    }
            }
        }
    }
}



struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(imageName: "heart.fill", textDisplay: "收藏")
    }
}
