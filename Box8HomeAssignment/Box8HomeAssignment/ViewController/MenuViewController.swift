//
//  MenuViewController.swift
//  Box8HomeAssignment
//
//  Created by Kavya on 9/27/18.
//  Copyright © 2018 Level. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    

    @IBOutlet weak var menuCollectionView: UICollectionView!
    var categoryObj : Category?
    var categoryArray : NSMutableArray?
    var selectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.menuCollectionView.register(UINib.init(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "menuCollectionViewCell")
        self.menuCollectionView.delegate = self
        self.menuCollectionView.dataSource = self
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100.0, height: 30.0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        self.menuCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        self.menuCollectionView.allowsMultipleSelection = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.menuCollectionView.scrollToItem(at:self.selectedIndexPath!, at: .right, animated: false)
    }
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension MenuViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "menuCollectionViewCell"
        var cell : MenuCollectionViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MenuCollectionViewCell
        if cell == nil {
            collectionView.register(UINib(nibName : "MenuCollectionViewCell", bundle :nil), forCellWithReuseIdentifier: cellIdentifier)
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MenuCollectionViewCell
        }
        cell.menuLabel.text = self.categoryArray?.object(at: indexPath.row) as? String
        if indexPath == self.selectedIndexPath {
            cell.highlightLabel.backgroundColor = UIColor.red
        }else {
            cell.highlightLabel.backgroundColor = UIColor.white
        }
        cell.layoutIfNeeded()
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        collectionView.reloadData()
    }
    

}

