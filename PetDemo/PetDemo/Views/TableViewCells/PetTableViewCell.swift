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
    @IBOutlet weak var petSubtitleLabel: UILabel!
    
    var pet: Pet? {
        didSet {
            petNameLabel.text = pet?.name
            petSubtitleLabel.text = pet?.description
            petImageView.kf.cancelDownloadTask()
            
            if let smallPhoto = pet?.photos?.small, let url = URL(string: smallPhoto) {
                petImageView.kf.setImage(with: url)
            }
            
        }
    }
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
