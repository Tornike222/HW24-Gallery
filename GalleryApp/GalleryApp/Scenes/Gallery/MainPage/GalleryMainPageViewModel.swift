//
//  GalleryMainPageViewModel.swift
//  GalleryApp
//
//  Created by telkanishvili on 08.05.24.
//

import Foundation
import NetworkPackage

//MARK: - Protocol GalleryMainPageViewModelDelegate
protocol GalleryMainPageViewModelDelegate: AnyObject {
    func viewModelUpdatedData()
}
//MARK: - class GalleryMainPageViewModel
class GalleryMainPageViewModel {
    var modelArray = [Photo()]
    weak var delegate: GalleryMainPageViewModelDelegate?
    
    //MARK: - Model is already set
    func didViewModelSet(){
        fetchData()
    }
    //MARK: - Fetch data from api
    private func fetchData() {
        let baseUrl = "https://api.unsplash.com"
        let endpoint = "/photos"
        let perPageCount = "/?per_page=100"
        let apiKey = "&client_id=2NAG4DjBzaJyf-TDNs8VJ1jksY-lg4rp5CCfUQTAKuw#"
        let urlString = baseUrl + endpoint + perPageCount + apiKey
        NetworkService().getData(urlString: urlString) { (result: [Photo]?, Error) in
            guard let result = result else { return }
            self.modelArray = result
            self.viewModelUpdate()
        }
    }
    //MARK: - Update delegate
    private func viewModelUpdate(){
        delegate?.viewModelUpdatedData()
    }

}
