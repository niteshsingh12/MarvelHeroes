//
//  CharacterDetailView.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 02/07/22.
//

import SwiftUI

struct HeroDetailView: View {
    
    @State var hero: MarvelHero
    @Environment(\.presentationMode) var presentation
    @ObservedObject var viewModel: HeroesViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    CacheAsyncImage(url: hero.imagePath, content: { (phase) in
                        switch phase {
                            case .success(let image):
                                image.modifierWithHeight(height: 400)
                                    .mask(LinearGradient(gradient: Gradient(colors: [.clear, .blue]), startPoint: .top, endPoint: .bottom))
                            default:
                                Image(systemName: "person.circle.fill").modifierWithHeight(height: 400)
                        }
                    })
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(hero.name)
                            .lineLimit(1)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Spacer(minLength: 20)
                        
                        RecruitButton(viewModel: viewModel, hero: hero)
                        
                        Spacer(minLength: 20)
                        if let description = hero.description {
                            Text(description)
                        }
                    }
                    .frame(width: geometry.size.width - 20)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0))
                }
            }
            
            Button(action: { presentation.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.backward.circle.fill")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
            .padding(EdgeInsets(top: 40, leading: 40, bottom: 0, trailing: 0))
        }
        .edgesIgnoringSafeArea(.top)
        .navigationTitle(Text(""))
        .navigationBarHidden(true)
        .statusBar(hidden: true)
        .onAppear(perform: {
            viewModel.isHeroInSquad(hero: hero)
        })
    }
}



//struct CharacterDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        //CharacterDetailView()
//    }
//}
