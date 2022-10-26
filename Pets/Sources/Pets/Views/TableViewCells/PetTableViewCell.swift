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
    
    @IBOutlet weak var petImageViewWidthConstraint: NSLayoutConstraint!
    
    var pet: Pet? {
        didSet {
            petNameLabel.text = pet?.name.htmlDecode(depth: 2)
            petSubtitleLabel.text = pet?.description?.htmlDecode(depth: 2)
            petImageView.image = UIImage(systemName: "photo.circle")
            petImageView.kf.cancelDownloadTask()
            petBreedLabel.text = pet?.breed
            
            if let smallPhoto = pet?.photos?.first?.large, let url = URL(string: smallPhoto) {
                petImageViewWidthConstraint.constant = petImageView.frame.size.height
                petImageView.kf.setImage(with: url, placeholder: petImageView.image, options: .optionsForFadeIn())
                
            } else {
                petImageViewWidthConstraint.constant = 0
            }
        }
    }
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        petImageView.layer.cornerRadius = petImageView.frame.size.height / 2.0
    }
    
    //MARK: - Overriden
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.2 : 0.0) {
            self.alpha = highlighted ? 0.5 : 1.0
        }
    }
    
}
