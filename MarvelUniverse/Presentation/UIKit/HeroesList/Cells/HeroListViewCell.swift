//
//  HeroListViewCell.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import UIKit
import Combine

final class HeroListViewCell: UICollectionViewListCell {
    
    // MARK: - Properties
    
    var hero: MarvelHero?
    var imageRepository: ImageLoaderProtocol?
    var bindings = Set<AnyCancellable>()
    
    var loadedImage: UIImage? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    func injectDependencies(imageRepository: ImageLoaderProtocol, hero: MarvelHero) {
        self.imageRepository = imageRepository
        self.hero = hero
        fetchImage(urlString: hero.imagePath.absoluteString)
    }
    
    // MARK: - Life Cycle
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var content = UIListContentConfiguration.subtitleCell().updated(for: state)
        content.image = self.loadedImage
        content.text = hero?.name
        
        content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        content.imageProperties.reservedLayoutSize = CGSize(width: 40, height: 40)
        content.imageProperties.cornerRadius = 5.0
        content.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
        content.textProperties.color = .label
        content.imageToTextPadding = 10
        content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        self.contentConfiguration = content
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Methods
    
    private func fetchImage(urlString: String) {
        
        imageRepository?.loadImage(urlString: urlString)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                    case .failure: self.loadedImage = .placeholder
                    default: ()
                }
            }, receiveValue: { (image) in
                self.loadedImage = image
            })
            .store(in: &self.bindings)
    }
}
