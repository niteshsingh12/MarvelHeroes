//
//  SquadCell.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import UIKit
import Combine

final class SquadCell: UICollectionViewCell {

    static let reuseIdentifer = "squad-cell-reuse-identifier"

    // MARK: - UI Properties

    lazy var heroNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()

    lazy var heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40.0
        return imageView
    }()

    // MARK: - Loacl Properties

    private var bindings = Set<AnyCancellable>()
    var imageLoader: ImageLoaderProtocol?
    var hero: MarvelHero!
    
    // MARK: - Dependency Injection
    
    func injectDependency(imageLoader: ImageLoaderProtocol, hero: MarvelHero) {
        self.imageLoader = imageLoader
        self.hero = hero
        initializeViewData()
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        heroImageView.image = nil
    }

    // MARK: - Helper Methods

    private func setup() {

        let subviews = [heroNameLabel, heroImageView]
        subviews.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        self.backgroundColor = .yellow
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            heroImageView.heightAnchor.constraint(equalToConstant: 80),
            heroImageView.widthAnchor.constraint(equalToConstant: 80),

            heroNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            heroNameLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor),
            heroNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            heroNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9)
        ])
        backgroundColor = .systemBackground
    }
    
    private func initializeViewData() {
        self.heroNameLabel.text = hero.name
        self.fetchImage(url: hero.imagePath.absoluteString)
    }
    
    private func fetchImage(url: String) {
        
        imageLoader?.loadImage(urlString: url)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                    case .failure: self.heroImageView.image = .placeholder
                    default: ()
                }
            }, receiveValue: { (image) in
                self.heroImageView.image = image
            })
            .store(in: &self.bindings)
    }
}
