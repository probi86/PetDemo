//
//  String+Extensions.swift
//  PetDemo
//
//  Created by Peter Robert on 26.10.2022.
//

import Foundation

extension String {
    func htmlDecode(depth: Int = 1) -> String {
        
        //Replaced the attributed string method with this simpler form, because it cases error logs. TODO: Investigate
        return self
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&#39;", with: "'")
            .replacingOccurrences(of: "&#039;", with: "'")
        
        
//        guard let data = data(using: .utf8) else {
//            return self
//        }
//
//        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
//            .documentType: NSAttributedString.DocumentType.html,
//            .characterEncoding: String.Encoding.utf8.rawValue
//        ]
//
//        if let decodedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil).string {
//            if depth > 1 {
//                return decodedString.htmlDecode(depth: depth - 1)
//            }
//            return decodedString
//        }
//
//        return self
    }
}
