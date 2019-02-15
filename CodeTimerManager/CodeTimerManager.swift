//
//  CodeTimerManager.swift
//  CodeTimerManager
//
//  Created by mac on 2019/2/15.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class CodeTimerManager: NSObject {
    
    enum codeType {
        case login      //登录
        case pay        //支付
        case regist     //注册
        case forget     //忘记密码
    }
    
    private var timer: Timer!                       //获取验证码定时器
    private var leftTime: TimeInterval?             //再次获取验证码剩余时间
    private let timeInterval: TimeInterval = 10     //获取验证码时间间隔
    var timerIsRun: Bool = false                    //定时器是否运行
    private var button: UIButton!                   //验证码按钮
    private var phone: String?                      //电话号码
    var type: codeType = .login                     //验证码类型
    private var getLeadTime: TimeInterval?          //获取剩余时间
    private var getLastTime: TimeInterval?          //获取退出时间
    private static let foreNotiName = "foreground"  //进入前台通知名字
    private static let backNotiName = "background"  //进入后台通知名字
    private var buttonTitle: String!                //验证码按钮标题
    
    ///初始化
    init(type: codeType, buttonTitle: String) {
        super.init()
        self.type = type
        self.buttonTitle = buttonTitle
        setObserver()
    }
    ///设置观察者
    private func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(fixLeadTime), name: NSNotification.Name(CodeTimerManager.foreNotiName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fixLastTime), name: NSNotification.Name(CodeTimerManager.backNotiName), object: nil)
    }
    ///获取时间
    private func getTime() {
        switch type {
        case .login:
            getLeadTime = codeTimer.loginLeadTime
            getLastTime = codeTimer.loginLastTime
        case .pay:
            getLeadTime = codeTimer.payLeadTime
            getLastTime = codeTimer.payLastTime
        case .regist:
            getLeadTime = codeTimer.registLeadTime
            getLastTime = codeTimer.registLastTime
        case .forget:
            getLeadTime = codeTimer.forgetLeadTime
            getLastTime = codeTimer.forgetLastTime
        }
    }
    ///设置时间
    private func setTime() {
        switch type {
        case .login:
            codeTimer.setloginLastTime(Date().timeIntervalSince1970)
            codeTimer.setLoginLeadTime(leftTime!)
        case .pay:
            codeTimer.setPayLastTime(Date().timeIntervalSince1970)
            codeTimer.setPayLeadTime(leftTime!)
        case .regist:
            codeTimer.setRegistLastTime(Date().timeIntervalSince1970)
            codeTimer.setRegistLeadTime(leftTime!)
        case .forget:
            codeTimer.setForgetLastTime(Date().timeIntervalSince1970)
            codeTimer.setForgetLeadTime(leftTime!)
        }
    }
    ///在viewWillAppear中调用
    func start(_ phone: String?, _ button: UIButton) {
        self.button = button
        self.phone = phone
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(leftTimeFunc), userInfo: nil, repeats: true)
        timer.fireDate = Date.distantFuture
        let now = Date().timeIntervalSince1970
        getTime()
        let leadTime = (getLeadTime ?? 0) - now + (getLastTime ?? 0)
        if leadTime > 0 {
            leftTime = leadTime
            timer.fireDate = Date.distantPast
            timerIsRun = true
        } else {
            leftTime = timeInterval
            if phone == nil || phone == "" {
                button.isEnabled = false
            } else {
                button.isEnabled = true
            }
            button.setTitle(buttonTitle, for: .normal)
        }
    }
    ///在viewWillDisapper中调用
    func finish() {
        timer.invalidate()
        timer = nil
        timerIsRun = false
        if leftTime == timeInterval {
            leftTime = 0
        }
        setTime()
    }
    ///倒计时
    @objc func leftTimeFunc() {
        let time = Int(round(leftTime ?? 0))
        if time == 0 {
            button?.setTitle(buttonTitle, for: .normal)
            button?.setTitle(buttonTitle, for: .disabled)
            if phone == nil || phone == "" {
                button?.isEnabled = false
            } else {
                button?.isEnabled = true
            }
            leftTime = timeInterval
            timer.fireDate = Date.distantFuture
            timerIsRun = false
            return
        }
        leftTime = leftTime! - 1
        button?.isEnabled = false
        button?.setTitle("\(time)", for: .disabled)
    }
    ///启动定时器
    func timerStart() {
        timer.fireDate = Date.distantPast
        timerIsRun = true
    }
    ///修正时间，用于从后台进入前台使用
    @objc private func fixLeadTime() {
        let now = Date().timeIntervalSince1970
        getTime()
        let leadTime = (getLeadTime ?? 0) - now + (getLastTime ?? 0)
        if leadTime > 0 {
            leftTime = leadTime
        } else {
            leftTime = timeInterval
            if phone == nil || phone == "" {
                button.isEnabled = false
            } else {
                button.isEnabled = true
            }
            button.setTitle(buttonTitle, for: .normal)
            timer.fireDate = Date.distantFuture
            timerIsRun = false
        }
    }
    ///保存进入后台时间
    @objc private func fixLastTime() {
        setTime()
    }
    ///发送进入前台通知，AppDelegate调用
    class func postForegroundNoti() {
        NotificationCenter.default.post(name: Notification.Name(CodeTimerManager.foreNotiName), object: nil)
    }
    ///发送进入后台通知，AppDelegate调用
    class func postBackgroundNoti() {
        NotificationCenter.default.post(name: Notification.Name(CodeTimerManager.backNotiName), object: nil)
    }
}

class codeTimer: NSObject {
    /*
     验证码定时器管理类(全局变量)
     将不同类型验证码分开记录，防止同时发送时，倒计时冲突
     可滋行根据需求添加
    */
    private static var _payLastTime: TimeInterval?          //支付验证密码离开时间
    private static var _loginLastTime: TimeInterval?        //登录验证码离开时时间
    private static var _registLastTime: TimeInterval?       //注册验证码离开时时间
    private static var _forgetLastTime: TimeInterval?       //忘记验证码离开时时间
    private static var _payLeadTime: TimeInterval?          //支付验证码剩余时间
    private static var _loginLeadTime: TimeInterval?        //登录验证码剩余时间
    private static var _registLeadTime: TimeInterval?       //注册验证码剩余时间
    private static var _forgetLeadTime: TimeInterval?       //忘记验证码剩余时间
    
    static var payLastTime: TimeInterval? {
        return _payLastTime
    }
    
    static func setPayLastTime(_ lasttime: TimeInterval) {
        _payLastTime = lasttime
    }
    
    static var loginLastTime: TimeInterval? {
        return _loginLastTime
    }
    
    static func setloginLastTime(_ lasttime: TimeInterval) {
        _loginLastTime = lasttime
    }
    
    static var registLastTime: TimeInterval? {
        return _registLastTime
    }
    
    static func setRegistLastTime(_ lasttime: TimeInterval) {
        _registLastTime = lasttime
    }
    
    static var forgetLastTime: TimeInterval? {
        return _forgetLastTime
    }
    
    static func setForgetLastTime(_ lasttime: TimeInterval) {
        _forgetLastTime = lasttime
    }
    
    static var payLeadTime: TimeInterval? {
        return _payLeadTime
    }
    
    static func setPayLeadTime(_ leadtime: TimeInterval) {
        _payLeadTime = leadtime
    }
    
    static var loginLeadTime: TimeInterval? {
        return _loginLeadTime
    }
    
    static func setLoginLeadTime(_ leadtime: TimeInterval) {
        _loginLeadTime = leadtime
    }
    
    static var registLeadTime: TimeInterval? {
        return _registLeadTime
    }
    
    static func setRegistLeadTime(_ leadtime: TimeInterval) {
        _registLeadTime = leadtime
    }
    
    static var forgetLeadTime: TimeInterval? {
        return _forgetLeadTime
    }
    
    static func setForgetLeadTime(_ leadtime: TimeInterval) {
        _forgetLeadTime = leadtime
    }
}
