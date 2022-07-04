//
//  HeroListView.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 30/06/22.
//

import SwiftUI
import Combine

struct HeroListView: View {
    
    @ObservedObject private var viewModel = DependencyFactory().createHeroesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                
                if !viewModel.squadHeroes.isEmpty {
                    ScrollView (.horizontal) {
                        HStack {
                            ForEach(viewModel.squadHeroes, id: \.id) { (hero) in
                                NavigationLink {
                                    HeroDetailView(hero: hero, viewModel: viewModel)
                                } label: {
                                    SquadRowView(hero: hero)
                                }
                            }
                        }
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                
                List {
                    ForEach(viewModel.heroes, id: \.id) { (hero) in
                        NavigationLink {
                            HeroDetailView(hero: hero, viewModel: viewModel)
                        } label: {
                            HeroRowView(hero: hero)
                        }
                    }
                }
                .makeToolbarItems()
                .navigationTitle(viewModel.squadHeroes.isEmpty ? "Heroes" : "My Squad")
            }
            .onAppear {
                viewModel.fetchRemoteHeroes()
                viewModel.getSquadHeroes()
            }
        }
    }
}

struct HeroListView_Previews: PreviewProvider {
    static var previews: some View {
        HeroListView()
    }
}
