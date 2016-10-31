//
//  MemeDetailViewController.swift
//  ImagePicker
//
//  Created by Dirk Milotz on 10/27/16.
//  Copyright © 2016 Dirk Milotz. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController:  UIViewController{
    
    
    // MARK: Properties
    
    var meme: Meme!
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        self.imageView!.image = meme.memeImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
