//
//  String+Extensions.swift
//  PetDemo
//
//  Created by Peter Robert on 26.10.2022.
//

import Foundation

public extension String {
    func htmlDecode(depth: Int = 1) -> String {
        guard let data = data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let decodedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil).string {
            if depth > 1 {
                return decodedString.htmlDecode(depth: depth - 1)
            }
            return decodedString
        }
        
        return self
    }
}
