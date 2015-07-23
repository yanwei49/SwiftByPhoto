//
//  DisplayCollectionViewCell.swift
//  SwiftByPhoto
//
//  Created by David Yu on 22/7/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

import UIKit

class DisplayCollectionViewCell: UICollectionViewCell {
    
    private var imageView: UIImageView!
    private var button: UIButton!
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var selectState: Bool? {
        didSet {
            if selectState == true {
                button.alpha = 0.8
                button.backgroundColor = UIColor.blackColor()
            }else {
                button.alpha = 1
                button.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.redColor()
        
        imageView = UIImageView(frame: self.bounds)
        imageView.backgroundColor = UIColor.whiteColor()
        self.addSubview(imageView)
        
        button = UIButton(frame: self.bounds)
        button.userInteractionEnabled = false
        button.backgroundColor = UIColor.clearColor()
        self.addSubview(button)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
