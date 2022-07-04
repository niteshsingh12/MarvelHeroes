//
//  CharacterRepresentable.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation
import SwiftUI

struct CharacterViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UINavigationController {
        return AppCoordinator().start()
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
    
    typealias UIViewControllerType = UINavigationController
}
