//
//  TextView.swift
//  Edutainment
//
//  Created by Damien Chailloleau on 18/03/2021.
//

import SwiftUI

struct TextView: View {
    var texts: String
    var colors: Color
    var sizes: CGFloat
    
    var body: some View {
        Text(texts)
            .font(Font.custom("Pacifico-Regular", size: sizes))
            .foregroundColor(colors)
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView(texts: "No Questions Generated", colors: .red, sizes: 25)
            .previewLayout(.sizeThatFits)
    }
}
