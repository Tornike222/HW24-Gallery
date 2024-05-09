//
//  GalleryCollectionViewCell.swift
//  GalleryApp
//
//  Created by telkanishvili on 08.05.24.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    //MARK: - UI Components
    let galleryImageView = UIImageView()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGalleryImageViewToView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Add Image View as subview
    func addGalleryImageViewToView() {
        addSubview(galleryImageView)
        galleryImageView.edgesToSuperview()
    }
}
