//
//  GropViewController.swift
//  SwiftByPhoto
//
//  Created by David Yu on 22/7/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

import UIKit
import Photos

enum SeletedPictureType {
    case onePicture
    case morePicture
}

protocol GroupViewControllerDelegate {
    func groupViewControllerDidSeletedAsset(asset: PHAsset);
    func groupViewControllerDidSeletedAssets(assets: [PHAsset]);
}

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DisplayViewControllerDelegate {

    var type: SeletedPictureType!
    //选中的asset数组
    var selectedAssets: [PHAsset]?
    var delegate: GroupViewControllerDelegate?
    
    private var collectionsFetchResults: PHFetchResult!
    private var _tableView: UITableView!
    private var imageManager: PHCachingImageManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        collectionsFetchResults = PHFetchResult()
        imageManager = PHCachingImageManager()
        //获取系统相册中的相册
        collectionsFetchResults = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.SmartAlbum, subtype: PHAssetCollectionSubtype.SmartAlbumUserLibrary, options: nil)
        
        createTableView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        _tableView.reloadData()
    }
    
    func createTableView() {
        _tableView = UITableView(frame: view.bounds, style: .Plain)
        _tableView.backgroundColor = UIColor.whiteColor()
        _tableView.registerClass(GroupTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        _tableView.tableFooterView = UIView()
        _tableView.delegate = self
        _tableView.dataSource = self
        view .addSubview(_tableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionsFetchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! GroupTableViewCell
        let collection = collectionsFetchResults[indexPath.row] as! PHAssetCollection
        let fecResult = PHAsset.fetchAssetsInAssetCollection(collection, options: nil) as PHFetchResult
        let asset = fecResult[indexPath.row] as! PHAsset
        imageManager.requestImageForAsset(asset, targetSize: CGSizeMake(40, 40), contentMode: PHImageContentMode.AspectFill, options: nil) { (result, info) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cell.iconImage = result;
                cell.name = "\(collection.localizedTitle!)" + " (" + "\(fecResult.count)" + ")"
            })
        }
        
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let displayVC = DisplayViewController()
        let collection = collectionsFetchResults[indexPath.row] as! PHAssetCollection
        let assetFetchResult = PHAsset.fetchAssetsInAssetCollection(collection, options: nil) as PHFetchResult
        displayVC.fetchResult = assetFetchResult
        displayVC.type = type
        displayVC.delegate = self
        if selectedAssets != nil {
            displayVC.selectedAssets = selectedAssets
        }
        navigationController?.showViewController(displayVC, sender: nil)
    }
    
    //DisplayViewController代理
    func displayViewControllerDidSeletedAsset(asset: PHAsset) {
        self.navigationController?.popViewControllerAnimated(false)
        delegate?.groupViewControllerDidSeletedAsset(asset)
    }
    
    func displayViewControllerDidSeletedAssets(assets: [PHAsset]) {
        self.navigationController?.popViewControllerAnimated(false)
        delegate?.groupViewControllerDidSeletedAssets(assets)
    }
}
