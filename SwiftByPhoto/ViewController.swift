//
//  ViewController.swift
//  SwiftByPhoto
//
//  Created by David Yu on 22/7/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageManager: PHCachingImageManager = PHCachingImageManager()
    var collectionView: UICollectionView!
    private let width = UIScreen.main.bounds.width
    private let height = UIScreen.main.bounds.height
    
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
        layout.itemSize = CGSize(width: (width-40)/4, height: (width-40)/4)
        
        collectionView = UICollectionView(frame: CGRect(x: 10, y: 74, width: width-20, height: height-200), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(YWDisplayCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
    }
    
    
    //collectionView代理
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetsA.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! YWDisplayCollectionViewCell
        let asset = assetsA[indexPath.row] as PHAsset
        imageManager.requestImage(for: asset, targetSize: CGSize(width: (width-40)/4, height: (width-40)/4), contentMode: PHImageContentMode.aspectFill, options: nil) { (result, info) -> Void in
            cell.image = result
        }
        
        return cell
    }
    

    @IBAction func actionTakePhoto(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            let pickVC = UIImagePickerController()
            pickVC.delegate = self
            //是否可编辑 
            pickVC.allowsEditing = false
            //摄像头   
            pickVC.sourceType = UIImagePickerControllerSourceType.camera
            self.present(pickVC, animated: true, completion: nil)
        }
    }

    @IBAction func actionAlbum(sender: UIButton) {
        let sheetVC = UIAlertController(title: "选择照片", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        sheetVC.addAction(UIAlertAction(title: "单选", style: UIAlertActionStyle.destructive, handler: { (sheet) -> Void in
            let groupVC = YWGroupViewController()
            groupVC.delegate = self
            groupVC.type = .onePicture
            self.navigationController?.show(groupVC, sender: nil)
        }))
  
        sheetVC.addAction(UIAlertAction(title: "多选", style: UIAlertActionStyle.destructive, handler: { (sheet) -> Void in
            let groupVC = YWGroupViewController()
            groupVC.delegate = self
            groupVC.type = .morePicture
            groupVC.selectedAssets = self.assetsA
            self.navigationController?.show(groupVC, sender: nil)
        }))
        sheetVC.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(sheetVC, animated: true, completion: nil)
    }
    
    //UIImagePickerController代理
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
    }
    
}

extension ViewController: YWGroupViewControllerDelegate {
    //groupViewController代理
    func groupViewControllerDidSeletedAssets(assets: [PHAsset]) {
        assetsA.removeAll()
        assetsA.append(contentsOf: assets)
        collectionView.reloadData()
    }
    
    func groupViewControllerDidSeletedAsset(asset: PHAsset) {
        assetsA.removeAll()
        assetsA.append(asset)
        collectionView.reloadData()
    }
}


