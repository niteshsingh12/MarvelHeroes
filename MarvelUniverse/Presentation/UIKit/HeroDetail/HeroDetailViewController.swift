//
//  HeroDetailViewController.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation
import UIKit
import Combine

final class HeroDetailViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate {
    
    //MARK: Properties
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_img_unavailable")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var fillerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 28, weight: .heavy)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var squadButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.addTarget(self, action: #selector(didTapAddToSquad), for: .touchUpInside)
        return button
    }()
        
    private var cancellables = Set<AnyCancellable>()
    var viewModel: HeroesViewModel
    private var hero: MarvelHero
    var imageLoader: ImageLoaderProtocol
    
    var isRecruited = false {
        didSet {
            if isRecruited {
                squadButton.setTitle("🔥 Fire from Squad", for: .normal)
                squadButton.backgroundColor = .clear
            } else {
                squadButton.setTitle("💪🏿 Recruit to Squad", for: .normal)
                squadButton.backgroundColor = .red
            }
        }
    }
    
    //MARK: Initializer
    
    init(viewModel: HeroesViewModel, hero: MarvelHero, imageLoader: ImageLoaderProtocol) {
        self.viewModel = viewModel
        self.hero = hero
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBindings()
        fetchImage()
        viewModel.isHeroInSquad(hero: hero)
    }
    
    //MARK: View Bindings
    
    func setupBindings() {
        
        viewModel.$squadOperation
            .sink(receiveValue: { (operation) in
                switch operation {
                    case .added:
                        self.isRecruited = true
                    case .removed:
                        self.isRecruited = false
                }
            })
            .store(in: &cancellables)
    }
    
    //MARK: Methods
    
    private func setup() {
        
        view.addSubview(scrollView)
        view.insertSubview(coverImageView, belowSubview: scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(fillerView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(squadButton)
        
        titleLabel.text = hero.name
        if let description = hero.description, !description.isEmpty {
            descriptionLabel.text = hero.description
            containerStackView.addArrangedSubview(descriptionLabel)
        }
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: view.topAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 300),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  20),
            
            squadButton.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor),
            squadButton.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            squadButton.heightAnchor.constraint(equalToConstant: 40),
            
            fillerView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    /*
      Fetched image from cache or remote url
    */
    private func fetchImage() {
                
        imageLoader.loadImage(urlString: hero.imagePath.absoluteString)
            .sink(receiveCompletion: { (completion) in
                
                switch completion {
                    case .failure: self.coverImageView.image = .placeholder
                    default: ()
                }
                
            }, receiveValue: { (image) in
                self.coverImageView.image = image
            })
            .store(in: &self.cancellables)
    }
    
    //MARK: Button Action
    
    @objc func didTapAddToSquad() {
        viewModel.squadOperation == .added ? viewModel.removeHeroFromSquad(hero: hero) : viewModel.addHeroToSquad(hero: hero)
    }
}
