//
//  Coordinator.swift
//  PetDemo
//
//  Created by Peter Robert on 24.10.2022.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}
