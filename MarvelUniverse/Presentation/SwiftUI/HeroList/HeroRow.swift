//
//  HeroRowView.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 30/06/22.
//

import SwiftUI

struct HeroRowView: View {
    
    var hero: MarvelHero
    
    var body: some View {
        HStack {
            CacheAsyncImage(url: hero.imagePath, content: { (phase) in
                switch phase {
                    case .success(let image):
                        image
                            .modifier(dimension: 50)
                    default:
                        Image(systemName: "person.circle.fill")
                            .modifier(dimension: 50)
                }
            })
            Text(hero.name)
                .lineLimit(1)
        }
    }
}

struct HeroRowView_Previews: PreviewProvider {
    static var previews: some View {
        HeroRowView(hero: MarvelHero(id: 1, name: "Iron Man", description: "Defender and leader", thumbnail: HeroImage(path: "http://i.annihil.us/u/prod/marvel/i/mg/2/80/4c002f35c5215", imageExtension: "jpg"), isFavorite: false))
    }
}
