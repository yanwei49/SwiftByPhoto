//
//  DisplayViewController.swift
//  SwiftByPhoto
//
//  Created by David Yu on 22/7/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

import UIKit
import Photos

protocol DisplayViewControllerDelegate {
    func displayViewControllerDidSeletedAsset(asset: PHAsset);
    func displayViewControllerDidSeletedAssets(assets: [PHAsset]);
}

class DisplayViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var fetchResult: PHFetchResult!
    //选中的asset数组
    var selectedAssets: [PHAsset]?
    var type: SeletedPictureType!
    var delegate: DisplayViewControllerDelegate?
    
    private var collectionView: UICollectionView!
    private var imageManager: PHCachingImageManager!
    private let width = UIScreen.mainScreen().bounds.width
    private let height = UIScreen.mainScreen().bounds.height
    private var rightItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        rightItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "actionRightItem")
        navigationItem.rightBarButtonItem = rightItem
        
        if selectedAssets == nil {
            selectedAssets = [PHAsset]()
        }else {
            rightItem.title = "确定"
        }
        
        imageManager = PHCachingImageManager()
        createCollectionView()
    }

    //创建collectionView
    func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSizeMake((width-40)/4, (width-40)/4)
        
        collectionView = UICollectionView(frame: CGRectMake(10, 10, width-20, height), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(DisplayCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
    }
    
    //右导航事件
    func actionRightItem() {
        navigationController?.popViewControllerAnimated(false)
        if type != SeletedPictureType.onePicture {
            self.navigationController?.popViewControllerAnimated(false)
            delegate?.displayViewControllerDidSeletedAssets(selectedAssets!)
        }
    }
    
    //collectionView代理
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! DisplayCollectionViewCell
        let asset = fetchResult[indexPath.row] as! PHAsset
        for var at: PHAsset in selectedAssets! {
            if at == asset {
                cell.selectState = true
            }
        }
        imageManager.requestImageForAsset(asset, targetSize: CGSizeMake((width-40)/4, (width-40)/4), contentMode: PHImageContentMode.AspectFill, options: nil) { (result, info) -> Void in
            cell.image = result
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! DisplayCollectionViewCell
        let asset = fetchResult[indexPath.row] as! PHAsset
        if type == SeletedPictureType.onePicture {
            self.navigationController?.popViewControllerAnimated(false)
            delegate?.displayViewControllerDidSeletedAsset(asset)
        }else {
            if cell.selectState == true {
                cell.selectState = false
                selectedAssets?.removeAtIndex((selectedAssets?.indexOf(asset))!)
            }else {
                cell.selectState = true
                selectedAssets?.append(asset)
            }
            if selectedAssets?.count != 0 {
                rightItem.title = "确定"
            }
        }
    }
    
}
