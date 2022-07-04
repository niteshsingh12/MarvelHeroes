//
//  MVToolbar.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 02/07/22.
//

import SwiftUI

struct Toolbar: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("logo_marvel")
                }
            }
    }
}

extension View {
     func makeToolbarItems() -> some View {
        modifier(Toolbar())
    }
}
