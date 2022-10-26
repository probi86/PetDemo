//
//  Kingfisher+Extensions.swift
//  StonksTrading
//
//  Created by Peter Robert on 18.08.2022.
//

import Foundation
import Kingfisher
import UIKit

extension KingfisherOptionsInfo {
    
    static func optionsForFadeIn() -> KingfisherOptionsInfo {
        return [
            .transition(.fade(0.2)),
            .loadDiskFileSynchronously
        ]
    }
    
}
