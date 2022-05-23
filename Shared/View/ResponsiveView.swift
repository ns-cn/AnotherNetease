//
//  ResponsiveView.swift
//  Yu (iOS)
//
//  Created by tangyujun on 2022/5/23.
//

import SwiftUI


// MARK custom View which will return the properties of the view
struct ResponsiveView<Content: View>: View {
    // Returning properties
    var content: (Properties) -> Content
    var body: some View {
        GeometryReader{proxy in
            let size = proxy.size
            let isLandscape = (size.width > size.height)
            let isPad = size.height >= 768
            content(Properties(isLandscape: isLandscape, isPad: isPad, size: size))
                .frame(width: size.width, height: size.height, alignment: .center)
        }
    }
}


struct Properties{
    var isLandscape: Bool
    var isPad: Bool
    var size: CGSize
}
