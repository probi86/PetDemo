//
//  AnimalDetailViewController.swift
//  PetDemo
//
//  Created by Peter Robert on 24.10.2022.
//

import UIKit
import Kingfisher

class PetDetailViewController: UIViewController {
    
    //MARK: - IVars
    
    @IBOutlet weak var petImageView: UIImageView!
    
    
    var viewModel: PetDetailViewModel?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel?.pet.name
        
        if let largePhoto = viewModel?.pet.photos?.first?.large, let url = URL(string: largePhoto) {
            petImageView.layer.cornerRadius = 10.0
            petImageView.layer.borderWidth = 2.0
            petImageView.layer.borderColor = UIColor.placeholderText.cgColor
            
            
            petImageView.kf.setImage(with: url, options: .optionsForFadeIn())
        } else {
            petImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }

        // Do any additional setup after loading the view.
    }
    
}
