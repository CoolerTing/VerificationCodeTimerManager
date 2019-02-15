//
//  ViewController.swift
//  CodeTimerManager
//
//  Created by mac on 2019/2/15.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let nextButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nextButton.frame = CGRect(x: 100, y: 100, width: 200, height: 30)
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.setTitle("进入下一级页面", for: .normal)
        nextButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        view.addSubview(nextButton)
    }
    
    @objc func buttonClick() {
        let viewController = NextViewController()
        self.present(viewController, animated: true, completion: nil)
    }

}

