# VerificationCodeTimerManager
验证码倒计时管理器
## 安装
将CodeTimerManager文件拖入项目中
## 说明
项目功能，简单易用。

倒计时开始不论退出界面还是进入后台，都能继续倒计时（只要不杀死APP）。

可根据需求修改代码。
## 使用
在控制器中创建一个获取验证码按钮并初始化定时器管理
```swift
let codeManager: CodeTimerManager = CodeTimerManager.init(type: .login, buttonTitle: "获取验证码")
```
在```viewWillAppear```中调用```func start(_ phone: String?, _ button: UIButton)```开启定时器管理
```swift
override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        codeManager.start("134XXXXXXXXXX", codeButton)
    }
```
在```viewWillDisapper```中调用```func finish()```停止并移除定时器
```swift
override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        codeManager.finish()
    }
```
在按钮点击事件中启动定时器
```swift
@objc func buttonClick() {
        codeManager.timerStart()
    }
```
在```AppDelegate```中进入前台方法中调用发送进入前台通知方法
```swift
func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        CodeTimerManager.postForegroundNoti()
    }
```
在```AppDelegate```中进入后台方法中调用发送进入后台通知方法
```swift
func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        CodeTimerManager.postBackgroundNoti()
    }
```

### 枚举
设置对象codeType
```swift
enum codeType {
        case login      //登录
        case pay        //支付
        case regist     //注册
        case forget     //忘记密码
    }
```

## 详细使用请参看DEMO
