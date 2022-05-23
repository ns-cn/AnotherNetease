//
//  TopArtistView.swift
//  AnotherNetease
//
//  Created by tangyujun on 2022/5/16.
//

import SwiftUI

struct TopArtistView: View {
    @EnvironmentObject var datacenter: DataCenter
    var body: some View{
        VStack{
            Group {
                Text("丑吗?丑就对了,还没做呢~")
                HStack{
                    ScrollView(.vertical, showsIndicators: false){
                        ForEach(datacenter.topArtist){item in
                            VStack{
                                Spacer()
                                HStack{
                                    Spacer()
                                    Text(item.name)
                                        .fontWeight(.bold)
                                        .font(.system(size: 16))
                                        .padding(.vertical, 6)
                                    Spacer()
                                }
                                .background(Color.green.blur(radius: 5).opacity(0.2))
                            }
                            .frame(height: 150)
                            .background(content: {
                                AsyncImage(url:URL(string: item.picUrl))
                                    .scaledToFit()
                                    .aspectRatio(contentMode:.fit)
                            })
                            .float()
                            .onTapGesture {
                                print(item)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("近期热门")
    }
}

struct TopArtistView_Previews: PreviewProvider {
    static var previews: some View {
        TopArtistView()
    }
}
