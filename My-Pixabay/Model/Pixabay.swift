//
//  Pixabay.swift
//  My-Pixabay
//
//  Created by Iskandar Herputra Wahidiyat on 16/06/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import Foundation

struct Pixabay: Codable {
    let total: Int
    let hits: [Hits]
}

struct Hits: Codable {
    let id: Int
    let pageURL: URL
    let previewURL: URL
}
