//
//  CollectionViewController.swift
//  ImagePicker
//
//  Created by Dirk Milotz on 10/27/16.
//  Copyright © 2016 Dirk Milotz. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController:  UICollectionViewController{
    
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    @IBAction func goToEditorView(_ sender: Any) {
        let editorController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        //self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController!.pushViewController(editorController, animated: true)
        
    }
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        collectionView?.reloadData()
        //TODO: Implement flowLayout here.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        print(memes)
        collectionView?.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    // MARK: Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.memes.count)
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
       // cell.nameLabel.text = meme.name
        cell.memeImage?.image =  meme.memeImage
        print("Returning CELLL")
        return cell
    }
    
   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}
