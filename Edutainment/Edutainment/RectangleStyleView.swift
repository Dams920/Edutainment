//
//  RectangleStyleView.swift
//  Edutainment
//
//  Created by Damien Chailloleau on 17/03/2021.
//

import SwiftUI

struct RectangleStyleView: View {
    var width: CGFloat
    var height: CGFloat
    var colorOne: Color
    var colorTwo: Color
    var radius: CGFloat
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [colorOne, colorTwo]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: radius))
    }
}

struct RectangleStyleView_Previews: PreviewProvider {
    static var previews: some View {
        RectangleStyleView(width: 250, height: 50, colorOne: .blue, colorTwo: .white, radius: 10)
            .previewLayout(.sizeThatFits)
    }
}
