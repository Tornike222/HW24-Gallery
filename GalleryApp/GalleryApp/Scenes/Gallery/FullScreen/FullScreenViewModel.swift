//
//  FullScreenViewModel.swift
//  GalleryApp
//
//  Created by telkanishvili on 09.05.24.
//

import Foundation

class FullScreenViewModel {
    //MARK: - Properties
    internal var index: IndexPath?
    internal var modelArray: [Photo]
    
    //MARK: - Init
    init(modelArray: [Photo], index: IndexPath?) {
        self.modelArray = modelArray
        self.index = index
    }
}
