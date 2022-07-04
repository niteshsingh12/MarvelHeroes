//
//  Image+Extension.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation
import SwiftUI

extension Image {
    func modifier(dimension: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: dimension, height: dimension)
            .clipShape(Circle())
    }
    
    func modifierWithHeight(height: CGFloat) -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 400)
            .clipped()
    }
}
