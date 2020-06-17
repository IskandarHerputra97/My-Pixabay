//
//  Pixabay.swift
//  My-Pixabay
//
//  Created by Iskandar Herputra Wahidiyat on 16/06/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import Foundation
import RealmSwift

struct Pixabay: Codable {
    let total: Int
    let hits: [Hits]
}

struct Hits: Codable {
    let id: Int
    let pageURL: URL
    let previewURL: URL
}

class RecentSearchRealm: Object {
    @objc dynamic var searchWord: String?
    
    convenience init(searchWord: String) {
        self.init()
        self.searchWord = searchWord
    }
}
