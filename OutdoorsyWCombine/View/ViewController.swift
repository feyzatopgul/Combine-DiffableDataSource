//
//  ViewController.swift
//  OutdoorsyWCombine
//
//  Created by fyz on 6/1/22.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var viewModel = VehiclesViewModel()
    private var model:[VehicleData]?
    private var subscription: Set<AnyCancellable> = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, VehicleData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, VehicleData>
    
    private lazy var dataSource = makeDataSource()
    
    private let sectionInsets = UIEdgeInsets(
      top: 50.0,
      left: 20.0,
      bottom: 50.0,
      right: 20.0)
    
    private let itemsPerRow: CGFloat = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = dataSource
        searchBar.delegate = self
        viewModel.fetch(searchTerm: "")
        setUp()
        applySnapshot()
    }
    private func loadImage(at indexPath: IndexPath){
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else {return}
            guard let url = self.viewModel.getUrl(at: indexPath) else {return}
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {return}
            DispatchQueue.main.async {
                if let cell = self.collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                    cell.imageView.image = image
                }
            }
        }
    }
    func setUp(){
        viewModel.$vehiclesModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapshot()
            }.store(in: &subscription)
    }
    
    //NSDiffableSourceSnapshot
    func applySnapshot(animatingDifferences: Bool = true){
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        self.model = viewModel.vehiclesModel.data
        if let model = self.model {
                snapshot.appendItems(model)}
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
    }
    //CollectionViewDiffableDataSource
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView,
                                    cellProvider: { (collectionView, indexPath, vehicle) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
                return UICollectionViewCell()
            }
            self.model = self.viewModel.vehiclesModel.data
            cell.label.text = self.model?[indexPath.row].attributes?.name
            cell.imageView.image = nil
            self.loadImage(at: indexPath)
            

//            self.viewModel.loadImage(index: indexPath.row) { image in
//
//                cell.imageView.image = image
//
//            }
//            let urlString = self.viewModel.getUrl(index: indexPath.row)
//            if let urlString = urlString, let url = URL(string: urlString), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    cell.imageView.image = image
//                }
//            }

            return cell
        })
        return dataSource
    }
}
 
extension ViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.fetch(searchTerm: searchText)
        setUp()
        applySnapshot()
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left*(itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

