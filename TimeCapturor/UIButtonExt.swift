//
//  UIButtonExt.swift
//  TimeCapturor
//
//  Created by YangTengfei on 12/30/15.
//  Copyright © 2015 TengfeiYang. All rights reserved.
//

import UIKit

extension UIButton {
    func centerLabelVerticallyWithPadding(spacing:CGFloat) {
        // update positioning of image and title
        let imageSize = self.imageView!.frame.size
        self.titleEdgeInsets = UIEdgeInsets(top:0,
            left:-imageSize.width,
            bottom:-(imageSize.height + spacing),
            right:0)
        let titleSize = self.titleLabel!.frame.size
        self.imageEdgeInsets = UIEdgeInsets(top:-(titleSize.height + spacing),
            left:0,
            bottom: 0,
            right:-titleSize.width)
        
        // reset contentInset, so intrinsicContentSize() is still accurate
        let trueContentSize = CGRectUnion(self.titleLabel!.frame, self.imageView!.frame).size
        let oldContentSize = self.intrinsicContentSize()
        let heightDelta = trueContentSize.height - oldContentSize.height
        let widthDelta = trueContentSize.width - oldContentSize.width
        self.contentEdgeInsets = UIEdgeInsets(top:heightDelta/2.0,
            left:widthDelta/2.0,
            bottom:heightDelta/2.0,
            right:widthDelta/2.0)
    }
}