//
//  MyPageViewController.swift
//  Trace
//
//  Created by Minki on 2017. 10. 16..
//  Copyright © 2017년 Shifter. All rights reserved.
//

import UIKit
@IBDesignable
class MyPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false

        //self.initNavigationBar()
    }
}

extension MyPageViewController {
    func initNavigationBar() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-50, height: 63))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 9, width: UIScreen.main.bounds.width, height: 18))
        titleLabel.text = "MY PAGE"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        let tabSegmentedControl = UISegmentedControl(frame: CGRect(x: 0, y: 36, width: UIScreen.main.bounds.width, height: 27))
        tabSegmentedControl.selectedSegmentIndex = 0
        tabSegmentedControl.contentHorizontalAlignment = .center
        tabSegmentedControl.contentVerticalAlignment = .center
        tabSegmentedControl.insertSegment(withTitle: "MY PAGE", at: 0, animated: true)
        tabSegmentedControl.insertSegment(withTitle: "PEOPLE", at: 1, animated: true)
        containerView.addSubview(tabSegmentedControl)
        
        self.navigationItem.titleView = containerView
        
    }
}
