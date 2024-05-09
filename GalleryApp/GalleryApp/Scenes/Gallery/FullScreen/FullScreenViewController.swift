//
//  FullScreenViewController.swift
//  GalleryApp
//
//  Created by telkanishvili on 08.05.24.
//

import UIKit
import TinyConstraints

class FullScreenViewController: UIViewController {
    //MARK: - ViewModel and properties
    internal var viewModel: FullScreenViewModel
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Photo>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, Photo>
    
    internal var dataSource: DataSource!
    internal var snapshot = SnapShot()
    
    //MARK: - UI Component CollectionView
    private let photoCollectionView: UICollectionView = {
        let photoCollectionFlowLayout = UICollectionViewFlowLayout()
        photoCollectionFlowLayout.scrollDirection = .horizontal
        photoCollectionFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
        photoCollectionFlowLayout.minimumLineSpacing = 0
        photoCollectionFlowLayout.minimumInteritemSpacing = 0
        let photoCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: photoCollectionFlowLayout)
        photoCollectionView.backgroundColor = .black
        photoCollectionView.allowsSelection = false
        photoCollectionView.isPagingEnabled = false
        
        return photoCollectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeVisibleNavigationBar()
        addPhotoCollectionView()
        configureDataSource()
        applySnapshot()
        scrollToIndex()
    }
    
    init(viewModel: FullScreenViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //Make navigation bar hidden
    private func makeVisibleNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - addCollectionView and register
    private func addPhotoCollectionView() {
        view.addSubview(photoCollectionView)
        photoCollectionView.edgesToSuperview()
        photoCollectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "GalleryCollectionView")
    }
    
    //MARK: - Make datasource and cells
    private func configureDataSource() {
        dataSource = DataSource(collectionView: photoCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, photo: Photo) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionView", for: indexPath) as? GalleryCollectionViewCell
            
            if let photoURL = photo.urls?.regular, let url = URL(string: photoURL) {
                cell?.galleryImageView.loadImageWith(url: url)
                cell?.galleryImageView.contentMode = .scaleAspectFit
            }
            return cell
        }
    }
    
    //MARK: - Snapshot functionality
    private func applySnapshot() {
        snapshot = SnapShot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.modelArray)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    //MARK: - scroll to index after choosing photo
    private func scrollToIndex() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) { [weak self] in
            self?.photoCollectionView.scrollToItem(at: self!.viewModel.index!, at: .centeredHorizontally, animated: false)
            self?.photoCollectionView.isPagingEnabled = true
        }
    }
}

