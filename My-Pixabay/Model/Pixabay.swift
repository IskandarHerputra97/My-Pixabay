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

//class PixabayRealm: Object, Codable {
//    @objc dynamic var total: Int
//    @objc dynamic var hits: [Hits]
//
//    init(total: Int, hits: [Hits]) {
//        self.total = total
//        self.hits = hits
//    }
//
//    required init() {
//        fatalError("init() has not been implemented")
//    }
//}
//
//class Hits: Object, Codable {
//    @objc dynamic var id: Int
//    @objc dynamic var pageURL: URL
//    @objc dynamic var previewURL: URL
//
//    init(id: Int, pageURL: URL, previewURL: URL) {
//        self.id = id
//        self.pageURL = pageURL
//        self.previewURL = previewURL
//    }
//
//    required init() {
//        fatalError("init() has not been implemented")
//    }
//}

class RecentSearchRealm: Object {
    @objc dynamic var searchWord: String?
    
    convenience init(searchWord: String) {
        self.init()
        self.searchWord = searchWord
    }
}
