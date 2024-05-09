//
//  ImageAPIModel.swift
//  GalleryApp
//
//  Created by telkanishvili on 08.05.24.
//

import Foundation

struct Photo: Decodable, Hashable {
    var urls: Url?
}

struct Url: Decodable, Hashable {
    var regular: String?
}
