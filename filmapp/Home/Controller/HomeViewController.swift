//
//  HomeViewController.swift
//  filmapp
//
//  Created by MacBook Pro on 6/12/21.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var homeContentCollectionView: UICollectionView!
    private var homeViewModel = HomeViewModel()
    
    private lazy var dataSource = homeViewModel.makeDataSource(collectionView: homeContentCollectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homeContentCollectionView.delegate = self
        self.homeContentCollectionView.tag = 1002
        
        self.homeContentCollectionView.collectionViewLayout = createLayout()
        self.homeContentCollectionView.register(UINib.init(nibName: String(describing: MovieCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.self))
        
        homeViewModel.getNowPlayingList(completion: {[weak self] (response, error) in
            if error == nil {
                self?.homeViewModel.update(with: response!, dataSource: self!.dataSource)
            } else {}
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
        
        
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1002 {
            let storyBoard = UIStoryboard.init(name: "Movie", bundle: nil)
            if let controller = storyBoard.instantiateViewController(withIdentifier: "MovieViewController") as? MovieViewController {
                controller.movieId = self.homeViewModel.nowPlaying[indexPath.item].id ?? 0
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }

}
