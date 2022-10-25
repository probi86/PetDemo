//
//  Coordinator.swift
//  PetDemo
//
//  Created by Peter Robert on 24.10.2022.
//

import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set } 
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
