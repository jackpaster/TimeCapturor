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
       
        //    imageView.contentMode = UIViewContentMode.Center
          //  imageView.clipsToBounds  = true
    
    @IBOutlet var titleLable: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds  = true
        contentView.addSubview(imageView)
        print("frame with \(frame.size.width)")
        let textFrame = CGRect(x: 0, y: 32, width: frame.size.width, height: frame.size.height/3)
        titleLable = UILabel(frame: textFrame)
        titleLable.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        titleLable.textAlignment = .Center
        contentView.addSubview(titleLable)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
}
