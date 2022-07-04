//
//  SuperheroViewController.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation
import UIKit
import Combine

class HeroesViewController: UIViewController, ListBaseCoordinated {
    
    // MARK: - Datasource Properties
    
    typealias Datasource = UICollectionViewDiffableDataSource<HeroesViewModel.Section, MarvelHero>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HeroesViewModel.Section, MarvelHero>
    var dataSource: Datasource!
    var snapshot = Snapshot()
    
    // MARK: - Properties
    
    var viewModel: HeroesViewModel
    var imageLoader: ImageLoaderProtocol
    var isLoadingList : Bool = false
    var cancellables = Set<AnyCancellable>()
    var coordinator: ListBaseCoordinator?
    
    lazy var heroesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayoutForListCollectionView())
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()

    // MARK: - Initializer
    
    init(viewModel: HeroesViewModel, imageLoader: ImageLoaderProtocol) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifesycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        setupCollectionView()
        setup()
        setupDatasource()
        fetchDataSource()
        prepareNavigationItems()
    }
    
    /*
     Fetching squads in viewDidAppear(_:) as squads should be fetched everytime detail view is dismissed
    */
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.getSquadHeroes()
    }
    
    func setup() {
        
        let subviews = [heroesCollectionView]
        subviews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            heroesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            heroesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            heroesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            heroesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: - View - ViewModel Binders
    
    /*
     Binds view model to view, listens to changes in heroes and state properties of viewmodel and updates self if necessary
     */
    func setupBindings() {
        
        ///Heroes Observer
        viewModel.$heroes
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink(receiveCompletion: { [weak self] (completion) in
                self?.isLoadingList = false
            }, receiveValue: { [weak self] heroes in
                self?.updateHeroes(heroes: heroes)
                self?.isLoadingList = false
            })
            .store(in: &cancellables)
        
        ///Squad observer
        viewModel.$squadHeroes
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] heroes in
                self?.updateSquad(squad: heroes)
            })
            .store(in: &cancellables)
        
        ///State observer
        viewModel.$state
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .error(let error):
                    self?.showAlertForError(error: error)
                default: ()
                }
            })
            .store(in: &cancellables)
    }
    
    /*
     Fetching remote heroes 
    */
    func fetchDataSource() {
        self.viewModel.fetchRemoteHeroes()
    }
    
    // MARK: - Helper Methods
    
    func prepareNavigationItems() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo_marvel"))
    }
    
    /*
     Method updates heroes fetch remotely via API
     */
    func updateHeroes(heroes: [MarvelHero]) {
        
        snapshot.deleteSections([.hero])
        snapshot.appendSections([.hero])
        snapshot.appendItems(heroes, toSection: .hero)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    /*
     Method updates squad heroes fetched via database, deletes existing section and item and appends sections with new data, moves section above heroes section
     */
    func updateSquad(squad: [MarvelHero]) {
        
        snapshot.deleteSections([.squadHero])
        snapshot.deleteItems(squad)
        snapshot.appendSections([.squadHero])
        snapshot.appendItems(squad, toSection: .squadHero)
        
        if snapshot.sectionIdentifiers.contains(.hero) {
            snapshot.moveSection(.hero, afterSection: .squadHero)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension HeroesViewController {
    
    // MARK: - Alert Methods
    
    func showAlertForError(error: Error) {
        Alert.present(title: "Information", message: error.localizedDescription, actions: .retry(handler: {
            self.retryRequest()
        }), .okay, from: self)
    }
    
     /*
      Request retrier
     */
    func retryRequest() {
        fetchDataSource()
    }
}

// MARK: - Heroes Pagination

extension HeroesViewController {
    
    /*
     Pagination logic: Once view is scrolled till the end, api call for more heroes is made, in the meantime isLoadingList will be true, when API call is returned successfully, isLoadingList will turn false
    */
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if ((heroesCollectionView.contentOffset.y + heroesCollectionView.frame.size.height) >= heroesCollectionView.contentSize.height)
        {
            if !isLoadingList {
                loadMoreHeroes()
            }
        }
    }
    
    /*
     Invoked when scroll view is dragged till the end, make isLoadigList
     as true to prevent multiple calls
    */
    private func loadMoreHeroes() {
        
        isLoadingList = true
        fetchDataSource()
    }
}
