//
//  PetTableViewCell.swift
//  PetDemo
//
//  Created by Peter Robert on 25.10.2022.
//

import UIKit
import Kingfisher

class PetTableViewCell: UITableViewCell {
    
    //MARK: - IVars
    
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petBreedLabel: UILabel!
    @IBOutlet weak var petSubtitleLabel: UILabel!
    
    var pet: Pet? {
        didSet {
            petNameLabel.text = pet?.name
            petSubtitleLabel.text = pet?.description?.folding(options: .diacriticInsensitive, locale: .current)
            petImageView.image = UIImage(systemName: "photo.circle")
            petImageView.kf.cancelDownloadTask()
            petBreedLabel.text = pet?.breed
            
            if let smallPhoto = pet?.photos?.first?.large, let url = URL(string: smallPhoto) {
                petImageView.kf.setImage(with: url, options: .optionsForFadeIn())
            }
        }
    }
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        petImageView.layer.cornerRadius = petImageView.frame.size.height / 2.0
    }
    
}
