//
//  RecruitButton.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation
import SwiftUI

struct RecruitButton: View {
    
    @ObservedObject private var viewModel: HeroesViewModel
    @State private var hero: MarvelHero
    
    init(viewModel: HeroesViewModel, hero: MarvelHero) {
        self.viewModel = viewModel
        self.hero = hero
    }
    
    var body: some View {
        Button(action: {
            viewModel.squadOperation == .added ? viewModel.removeHeroFromSquad(hero: hero) : viewModel.addHeroToSquad(hero: hero)
        }) {
            Text(viewModel.squadOperation == .added ? "🔥 Fire from Squad" : "💪🏿 Recruit to Squad")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 10, maxHeight: 10)
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(viewModel.squadOperation == .added ? Color.clear : Color.red)
                        .shadow(color: .gray, radius: 1, x: 0, y: 1)
                        .clipped()
                )
                .border(.red, width: 2)
        }
    }
}
