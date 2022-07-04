//
//  SquadRow.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation
import SwiftUI

struct SquadRowView: View {
    
    let hero: MarvelHero
    
    var body: some View {
        VStack {
            CacheAsyncImage(url: hero.imagePath, content: { (phase) in
                switch phase {
                    case .success(let image):
                        image
                            .modifier(dimension: 80)
                    default:
                        Image(systemName: "person.circle.fill")
                            .modifier(dimension: 80)
                }
            })
            Text(hero.name)
                .font(.headline)
                .lineLimit(2)
                .frame(width: 80, height: 30)
        }
    }
}
