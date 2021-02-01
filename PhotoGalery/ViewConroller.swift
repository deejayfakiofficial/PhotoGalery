//
//  MainViewController.swift
//  PhotoGalery
//
//  Created by Stanislav Terentyev on 01.02.2021.
//

import UIKit

class ViewConroller: UIViewController {

  @IBOutlet weak var collectionview: UICollectionView!
  
  let networker = NetworkManager.shared
  
  var posts: [Post] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    networker.posts(query: "summer") { [weak self] posts, error in
      if let error = error {
        print("error", error)
        return
      }
      
      self?.posts = posts!
      DispatchQueue.main.async {
        self?.collectionview.reloadData()
      }
    }
    collectionview.collectionViewLayout = layout()
  }
    func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(200),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension:.absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .flexible(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 30
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 10
        layout.configuration = configuration
        return layout
    }

}

extension ViewConroller: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 20
    }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
    
    let post = posts[indexPath.item]
   
    
    cell.image = nil

    
    let representedIdentifier = post.id
    cell.representedIdentifier = representedIdentifier
    
    func image(data: Data?) -> UIImage? {
      if let data = data {
        return UIImage(data: data)
      }
      return UIImage(systemName: "cat")
    }
    
    networker.image(post: post) { data, error  in
      let img = image(data: data)
      DispatchQueue.main.async {
        if (cell.representedIdentifier == representedIdentifier) {
          cell.image = img
        }
      }
    }
    
    return cell
  }
  
}
