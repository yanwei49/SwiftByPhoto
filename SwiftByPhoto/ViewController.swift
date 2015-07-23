//
//  ViewController.swift
//  SwiftByPhoto
//
//  Created by David Yu on 22/7/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, GroupViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageManager: PHCachingImageManager = PHCachingImageManager()
    var collectionView: UICollectionView!
    private let width = UIScreen.mainScreen().bounds.width
    private let height = UIScreen.mainScreen().bounds.height
    
    var assetsA = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageManager = PHCachingImageManager()
        createCollectionView()
    }
    
    //创建collectionView
    func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSizeMake((width-40)/4, (width-40)/4)
        
        collectionView = UICollectionView(frame: CGRectMake(10, 74, width-20, height-200), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(DisplayCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
    }
    
    
    //collectionView代理
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetsA.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! DisplayCollectionViewCell
        let asset = assetsA[indexPath.row] as PHAsset
        imageManager.requestImageForAsset(asset, targetSize: CGSizeMake((width-40)/4, (width-40)/4), contentMode: PHImageContentMode.AspectFill, options: nil) { (result, info) -> Void in
            cell.image = result
        }
        
        return cell
    }
    

    @IBAction func actionTakePhoto(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) == true {
            let pickVC = UIImagePickerController()
            pickVC.delegate = self
            //是否可编辑 
            pickVC.allowsEditing = false
            //摄像头   
            pickVC.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(pickVC, animated: true, completion: nil)
        }
    }

    @IBAction func actionAlbum(sender: UIButton) {
        let sheetVC = UIAlertController(title: "选择照片", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        sheetVC.addAction(UIAlertAction(title: "单选", style: UIAlertActionStyle.Destructive, handler: { (sheet) -> Void in
            let groupVC = GroupViewController()
            groupVC.delegate = self
            groupVC.type = SeletedPictureType.onePicture
            self.navigationController?.showViewController(groupVC, sender: nil)
        }))
  
        sheetVC.addAction(UIAlertAction(title: "多选", style: UIAlertActionStyle.Destructive, handler: { (sheet) -> Void in
            let groupVC = GroupViewController()
            groupVC.delegate = self
            groupVC.type = SeletedPictureType.morePicture
            groupVC.selectedAssets = self.assetsA
            self.navigationController?.showViewController(groupVC, sender: nil)
        }))
        sheetVC.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(sheetVC, animated: true, completion: nil)
    }
    
    //UIImagePickerController代理
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
    }
    
    //groupViewController代理
    func groupViewControllerDidSeletedAssets(assets: [PHAsset]) {
        assetsA.removeAll()
        assetsA.extend(assets)
        collectionView.reloadData()
    }
    
    func groupViewControllerDidSeletedAsset(asset: PHAsset) {
        assetsA.removeAll()
        assetsA.append(asset)
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

