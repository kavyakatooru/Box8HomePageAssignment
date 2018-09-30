//
//  HomeViewController.swift
//  Box8HomeAssignment
//
//  Created by Kavya on 9/26/18.
//  Copyright © 2018 Level. All rights reserved.
//

import UIKit

struct Category {
    var Fusion_Box : String?
    var Curries : String?
    var Biryani : String?
    var Wraps : String?
    var Ice_Cream : String?
}

class HomeViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet var sideMenuView: UIView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    var screenWidth : CGFloat?
    var imagesArray : NSMutableArray?
    var scrollView : UIScrollView!
    var numberOfPages : Int!
    var categoryObj : Category?
    var sideMenuOn : Bool?
    var categoryArray : NSMutableArray = ["FUSION BOX", "CURRIES", "BIRYANI", "WRAPS", "DESSERTS"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuOn = false
        self.setScrollViewLayout()
        self.setFlowLayout()
        self.categoriesCollectionView.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCollectionViewCell")
        self.sideMenuView.frame = CGRect(x: 0, y: 0, width: 0, height: self.view.frame.height)
        self.sideMenuView.clipsToBounds = true
        self.sideMenuView.translatesAutoresizingMaskIntoConstraints = true
        self.sideMenuView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sideMenuView.layoutIfNeeded()
        self.view.addSubview(self.sideMenuView)
        
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftAction))
        swipeLeft.direction = .left
        self.sideMenuView.addGestureRecognizer(swipeLeft)
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.pageControl.currentPage = 0
        for index in 0...numberOfPages-1 {
            let xOrigin : CGFloat = CGFloat(index) * self.screenWidth!
            let imageView = UIImageView()
            imageView.frame.origin = CGPoint(x: xOrigin, y: 0)
            imageView.frame.size = CGSize(width:self.screenWidth!, height: self.topView.frame.height)
            imageView.image = self.imagesArray?.object(at: index) as? UIImage
            imageView.contentMode = .scaleAspectFill
            self.topView.setNeedsLayout()
            self.topView.layoutIfNeeded()
            scrollView.addSubview(imageView)
        }
        
        self.topView.addSubview(self.pageControl)
        self.topView.setNeedsLayout()
        self.topView.layoutIfNeeded()
        self.pageControl.numberOfPages = (self.imagesArray?.count)!
    }
    func setFlowLayout() {
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: 200.0, height: 150.0)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .vertical
        self.categoriesCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    func setScrollViewLayout() {
        self.screenWidth = UIScreen.main.bounds.size.width
        let topViewImage = UIImage(named: "topViewImage")!
        self.imagesArray = NSMutableArray(array: [topViewImage,topViewImage,topViewImage,topViewImage])
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.screenWidth!, height: self.topView.frame.height))
        self.scrollView.delegate = self
        self.scrollView.indicatorStyle = .default
        self.scrollView.isPagingEnabled = true
        self.scrollView.isScrollEnabled = true
        self.numberOfPages = (self.imagesArray?.count)!
        self.scrollView.contentSize = CGSize(width: CGFloat(numberOfPages) * self.screenWidth!, height: self.topView.frame.height)
        self.topView.addSubview(self.scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth : CGFloat = scrollView.frame.size.width
        let fractionalPage : Double = Double(scrollView.contentOffset.x / pageWidth)
        self.pageControl.currentPage = lround(fractionalPage)
    }
    
    //MARK:IBActions
    
    @IBAction func sideMenuButtonAction(_ sender: UIBarButtonItem) {
        if !self.sideMenuOn! {
            self.sideMenuOn = true
            UIView.animate(withDuration: 0.5) {
                self.sideMenuView.frame = CGRect(x: 0, y: 0, width: 260, height: self.view.frame.size.height)
            }
        }
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            if !self.sideMenuOn! {
                self.sideMenuOn = true
                print("Screen edge swiped!")
                UIView.animate(withDuration: 0.5) {
                    self.sideMenuView.frame = CGRect(x: 0, y: 0, width: 260, height: self.view.frame.size.height)
                }
            }
        }
    }
    
    @objc func swipeLeftAction() {
        if self.sideMenuOn! {
            self.sideMenuOn = false
            UIView.animate(withDuration: 0.5) {
                self.sideMenuView.frame = CGRect(x: 0, y: 0, width: 0, height: self.view.frame.size.height)
            }
        }
        
    }
    
}

extension UIScrollView {
    func scrollTo(direction: ScrollDirection, animated: Bool = true) {
        self.setContentOffset(direction.contentOffsetWith(scrollView: self), animated: animated)
    }
    
    enum ScrollDirection {
        case Right
        case Left
        func contentOffsetWith(scrollView: UIScrollView) -> CGPoint {
            var contentOffset = CGPoint.zero
            switch self {
            case .Right:
                contentOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.size.width, y: 0)
            case .Left:
                contentOffset = CGPoint(x: -scrollView.contentInset.left, y: 0)
            }
            return contentOffset
        }
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "categoryCollectionViewCell"
        var cell : CategoryCollectionViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CategoryCollectionViewCell
        if cell == nil {
            
            collectionView.register(UINib(nibName : "CategoryCollectionViewCell", bundle :nil), forCellWithReuseIdentifier: cellIdentifier)
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CategoryCollectionViewCell
        }
        cell.foodNameLabel.text = self.categoryArray[indexPath.row] as? String
        cell.foodImage.image = UIImage(named: self.categoryArray[indexPath.row] as! String)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var newSize : CGSize = CGSize.zero
        newSize.height = 150
        
        let screenSize = UIScreen.main.bounds.size
        if indexPath.item % 4 == 0 || indexPath.item % 4 == 3 {
            newSize.width = screenSize.width * 0.39
        }
        else{
            newSize.width = screenSize.width * 0.57
        }
        if indexPath.row == 4 {
            newSize.width = screenSize.width * 0.7
        }
        return newSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuVC = MenuViewController(nibName: "MenuViewController", bundle : nil)
        menuVC.categoryArray = self.categoryArray
        menuVC.selectedIndexPath = indexPath
        self.navigationController?.pushViewController(menuVC, animated: true)
    }
}
