//
//  MyScrollView.swift
//  OriginalApp
//
//  Created by 妹尾駿 on H30/05/27.
//  Copyright © 平成30年 porme.inc. All rights reserved.
//

import UIKit

class MyScrollView: UIScrollView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        superview?.touchesBegan(touches, with: event)
    }

}
