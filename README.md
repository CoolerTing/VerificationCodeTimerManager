# VerificationCodeTimerManager
验证码倒计时管理器
## 安装
将CodeTimerManager文件拖入项目中
## 说明
项目功能，简单易用。

倒计时开始不论退出界面还是进入后台，都能继续倒计时（只要不杀死APP）。

可根据需求修改代码。
## 使用
在```viewWillAppear```中调用```swfit func start(_ phone: String?, _ button: UIButton)```


## 参数
* frame：控件的frame
* space：控件的头尾距父视图的间距
* margin：每一个输入框的间距
* count：输入框的个数

### 枚举
设置对象inputType
```swift
enum codeType {
        case login      //登录
        case pay        //支付
        case regist     //注册
        case forget     //忘记密码
    }
```
