//
//  NextViewController.swift
//  CodeTimerManager
//
//  Created by mac on 2019/2/15.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    let codeManager: CodeTimerManager = CodeTimerManager.init(type: .login, buttonTitle: "获取验证码")
    let codeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.white
        codeButton.frame = CGRect(x: 100, y: 200, width: 100, height: 30)
        codeButton.setTitleColor(.black, for: .normal)
        codeButton.layer.borderColor = UIColor.black.cgColor
        codeButton.layer.cornerRadius = 3
        codeButton.layer.borderWidth = 1;
        codeButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        view.addSubview(codeButton)
        
        let dismissBttuon = UIButton()
        dismissBttuon.setTitle("返回上一级页面", for: .normal)
        dismissBttuon.setTitleColor(.black, for: .normal)
        dismissBttuon.frame = CGRect(x: 100, y: 100, width: 200, height: 30)
        dismissBttuon.addTarget(self, action: #selector(viewDismiss), for: .touchUpInside)
        view.addSubview(dismissBttuon)
        
        codeManager.start("13438380293", codeButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func buttonClick() {
        codeManager.timerStart()
    }
    
    @objc func viewDismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    deinit {
        codeManager.finish()
        print("\(self)已释放")
    }
}
