//
//  GroupTableViewCell.swift
//  SwiftByPhoto
//
//  Created by David Yu on 22/7/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    private var icon: UIImageView!
    private var title: UILabel!
    
    var name: String? {
        didSet {
            title.text = name
        }
    }
    
    var iconImage: UIImage? {
        didSet {
            icon.image = iconImage
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        icon = UIImageView(frame: CGRectMake(10, 10, 60, 60))
        icon.backgroundColor = UIColor.whiteColor()
        self.addSubview(icon)
        
        title = UILabel(frame: CGRectMake(80, 20, UIScreen.mainScreen().bounds.width-100, 40))
//        title.font = UIFont.systemFontOfSize(14)
        self.addSubview(title)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
