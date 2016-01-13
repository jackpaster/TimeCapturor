//
//  CollectionViewCell.swift
//  TimeCapturor
//
//  Created by YangTengfei on 12/21/15.
//  Copyright © 2015 TengfeiYang. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLable: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds  = true
        imageView.layer.cornerRadius = 2
        contentView.addSubview(imageView)

        let textFrame = CGRect(x: 0, y: frame.size.width-frame.size.width/7.5 , width: frame.size.width, height: frame.size.height/7.5)
        titleLable = UILabel(frame: textFrame)
        titleLable.font = UIFont(name: titleLable.font.fontName, size: 11) //rgb(127, 140, 141)
        titleLable.textColor = UIColor(red: 236 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1)
        titleLable.textAlignment = .Right
        titleLable.backgroundColor = UIColor(red: 44 / 255.0, green: 62 / 255.0, blue: 80 / 255.0, alpha: 0.3)//rgb(44, 62, 80)

        contentView.addSubview(titleLable)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
}
