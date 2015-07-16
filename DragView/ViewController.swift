//
//  ViewController.swift
//  DragView
//
//  Created by BourneWeng on 15/7/16.
//  Copyright (c) 2015年 Bourne. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dragBadgeView = DragBadge(frame: CGRectMake(200, 200, 20, 20))
        self.view.addSubview(dragBadgeView)
//        dragBadgeView.dragColor = UIColor.redColor()
//        dragBadgeView.maxLength = 200
        dragBadgeView.setUp()
        
        dragBadgeView.title = "38"
    }



}

