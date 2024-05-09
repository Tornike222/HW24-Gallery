//
//  GalleryMainPageViewController.swift
//  GalleryApp
//
//  Created by telkanishvili on 08.05.24.
//

import UIKit
import TinyConstraints

class GalleryMainPageViewController: UIViewController {
    //MARK: - ViewModel and properties
    internal var viewModel: GalleryMainPageViewModel
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Photo>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, Photo>
    
    internal var dataSource: DataSource!
    internal var snapshot = SnapShot()
    
    //MARK: - UI Components
    private let galleryLabel: UILabel = {
        let galleryLabel = UILabel()
        galleryLabel.text = "გალერეა"
        galleryLabel.textColor = .label
        galleryLabel.textAlignment = .center
        galleryLabel.font = UIFont.boldSystemFont(ofSize: 30)
        galleryLabel.textColor = #colorLiteral(red: 0.2318603396, green: 0.4763248563, blue: 0.9446834922, alpha: 1)
        return galleryLabel
    }()
    
    private let galleryCollectionView: UICollectionView = {
        let galleryCollectionFlowLayout = UICollectionViewFlowLayout()
        galleryCollectionFlowLayout.scrollDirection = .vertical
        galleryCollectionFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/3-2, height:  UIScreen.main.bounds.width/3-2)
        galleryCollectionFlowLayout.minimumLineSpacing = 2
        galleryCollectionFlowLayout.minimumInteritemSpacing = 2
        let galleryCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: galleryCollectionFlowLayout)
        galleryCollectionView.backgroundColor = .clear
        return galleryCollectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBackgroundColor()
    }
    
    init(viewModel: GalleryMainPageViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Setup UI
    private func setupUI() {
        addBackgroundColor()
        addGalleryLabel()
        addGalleryCollectionView()
        viewModel.didViewModelSet()
    }
    
   private func addBackgroundColor() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
   private func addGalleryLabel() {
        view.addSubview(galleryLabel)
        galleryLabel.top(to: view.safeAreaLayoutGuide, offset: 2)
        galleryLabel.left(to: view, offset: 30)
        galleryLabel.right(to: view, offset: -30)
    }
    
    private func addGalleryCollectionView() {
        view.addSubview(galleryCollectionView)
        galleryCollectionView.left(to: view)
        galleryCollectionView.right(to: view)
        galleryCollectionView.topToBottom(of: galleryLabel, offset: 10)
        galleryCollectionView.bottom(to: view)
        
        galleryCollectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "GalleryCollectionView")
        galleryCollectionView.delegate = self
    }
    //MARK: - DataSource Configuation
    private func configureDataSource() {
        dataSource = DataSource(collectionView: galleryCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, photo: Photo) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionView", for: indexPath) as? GalleryCollectionViewCell

            if let photoURL = photo.urls?.regular, let url = URL(string: photoURL) {
                cell?.galleryImageView.loadImageWith(url: url)
            }
            return cell
        }
    }
    //MARK: - Snapshot
    private func applySnapshot() {
        snapshot = SnapShot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.modelArray)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

//MARK: - Extension UICollectionViewDelegate
extension GalleryMainPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clickedPhotoIndex = indexPath
        let vc = FullScreenViewController(viewModel: FullScreenViewModel(modelArray: viewModel.modelArray, index: clickedPhotoIndex))
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Extension GalleryMainPageViewModelDelegate
extension GalleryMainPageViewController: GalleryMainPageViewModelDelegate {
    func viewModelUpdatedData() {
        applySnapshot()
    }
}
