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
    @IBOutlet weak var petDescriptionLabel: UILabel!
    @IBOutlet weak var petDetailsTableView: UITableView!
    
    @IBOutlet weak var petImageViewAspectRatioConstraint: NSLayoutConstraint!
    
    
    var viewModel: PetDetailViewModel?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel?.pet.name.htmlDecode(depth: 2)
        
        if let fullPhoto = viewModel?.pet.photos?.first?.full, let url = URL(string: fullPhoto) {
            petImageView.layer.cornerRadius = 10.0
            petImageView.layer.borderWidth = 2.0
            petImageView.layer.borderColor = UIColor.placeholderText.cgColor
            
            
            petImageView.kf.setImage(with: url, options: .optionsForFadeIn())
        } else {
            petImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            petImageViewAspectRatioConstraint.isActive = false
        }
        
        petDescriptionLabel.text = viewModel?.pet.description?.htmlDecode().htmlDecode(depth: 2)
        
        petDetailsTableView.dataSource = self
        petDetailsTableView.delegate = self
        petDetailsTableView.register(UINib(nibName: "PetDetailTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PetDetailTableViewCell")
    }
    
}

extension PetDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.pet.petDetails.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetDetailTableViewCell", for: indexPath) as! PetDetailTableViewCell
        if let detail = viewModel?.pet.petDetails[indexPath.row] {
            cell.textLabel?.text = detail.name
            cell.detailTextLabel?.text = detail.value
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pet Details"
    }
    
}
