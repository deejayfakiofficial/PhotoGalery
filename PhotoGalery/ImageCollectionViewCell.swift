//
//  ImageCollectionViewCell.swift
//  PhotoGalery
//
//  Created by Stanislav Terentyev on 01.02.2021.
//

import UIKit
class ImageCollectionViewCell: UICollectionViewCell {
  

  @IBOutlet weak var imageView: UIImageView!
 
  
  var representedIdentifier: String = ""
  
 
  var image: UIImage? {
    didSet {
      imageView.image = image
    }
  }
  
  
}
