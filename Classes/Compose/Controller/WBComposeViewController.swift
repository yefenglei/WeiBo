//
//  WBComposeViewController.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/10/12.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBComposeViewController: UIViewController,WBComposeToolbarDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    /** 输入控件 */
    weak var textView:WBEmotionTextView!
    /** 键盘顶部的工具条 */
    weak var toolbar:WBComposeToolbar!
    /** 相册（存放拍照或者相册中选择的图片） */
    weak var photosView:WBComposePhotosView!
    /** 表情键盘 */
    private var _emotionKeyboard:WBEmotionKeyboard?
    var emotionKeyboard:WBEmotionKeyboard!{
        get{
            if(self._emotionKeyboard == nil){
                self._emotionKeyboard = WBEmotionKeyboard()
                // 键盘的宽度
                self._emotionKeyboard!.width=self.view.width
                self._emotionKeyboard!.height=216
            }
            return self._emotionKeyboard
        }
        set{
            self._emotionKeyboard=newValue
        }
    }
    /** 是否正在切换键盘 */
    var switchingKeyboard:Bool!=false
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor=UIColor.whiteColor()
        // 设置导航栏内容
        self.setupNav()
        // 添加输入控件
        self.setupTextView()
        // 添加工具条
        self.setupToolbar()
        // 添加相册
        self.setupPhotosView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 成为第一响应者（能输入文本的控件一旦成为第一响应者，就会叫出相应的键盘）
        self.textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit{
        CommonHelper.WBNotificationCenter.removeObserver(self)
    }

    // MARK: - 初始化方法
///  添加相册
    func setupPhotosView(){
        let photosView=WBComposePhotosView()
        photosView.y=100
        photosView.width=self.view.height
        // 随便写的
        photosView.height=self.view.height
        self.textView.addSubview(photosView)
        self.photosView=photosView
    }
///  添加工具条
    func setupToolbar(){
        let toolbar=WBComposeToolbar()
        toolbar.width=self.view.width
        toolbar.height=44
        toolbar.y=self.view.height-toolbar.height
        toolbar.delegate=self
        self.view.addSubview(toolbar)
        self.toolbar=toolbar
    }
///  设置导航栏内容
    func setupNav(){
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: self, action: "cancel")
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Done, target: self, action: "send")
        self.navigationItem.rightBarButtonItem!.enabled=false
        
        let name=WBAccountTool.account?.name
        let prefix="发微博"
        if(name != nil){
            let titleView=UILabel()
            titleView.width=200
            titleView.height=100
            titleView.textAlignment=NSTextAlignment.Center
            // 自动换行
            titleView.numberOfLines=0
            titleView.y=50
            
            let str="\(prefix)\n\(name!)"
            
            // 创建一个带有属性的字符串（比如颜色属性、字体属性等文字属性）
            let attrStr=NSMutableAttributedString(string: str)
            // 添加属性
            attrStr.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(16), range:(str as NSString).rangeOfString(prefix))
            attrStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12), range: (name! as NSString).rangeOfString(prefix))
            titleView.attributedText=attrStr
            self.navigationItem.titleView=titleView
        }else{
            self.title=prefix
        }
    }
    
///  添加输入控件
    func setupTextView(){
        // 在这个控制器中，textView的contentInset.top默认会等于64
        let textView = WBEmotionTextView(frame:CGRect.null)
        // 垂直方向上永远可以拖拽（有弹簧效果）
        textView.alwaysBounceVertical=true
        textView.frame=self.view.bounds
        textView.font=UIFont.systemFontOfSize(15)
        textView.delegate=self
        textView.placeholder="分享新鲜事..."
        self.view.addSubview(textView)
        self.textView=textView
        
        // 文字改变的通知
        CommonHelper.WBNotificationCenter.addObserver(self, selector: "textDidChange", name: UITextViewTextDidChangeNotification, object: textView)
        // 键盘通知
        // 键盘的frame发生改变时发出的通知（位置和尺寸）
        CommonHelper.WBNotificationCenter.addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        // 表情选中的通知
        CommonHelper.WBNotificationCenter.addObserver(self, selector: "emotionDidSelect:", name: WBConstant.WBEmotionDidSelectNotification, object: nil)
        // 删除文字的通知
        CommonHelper.WBNotificationCenter.addObserver(self, selector: "emotionDidDelete", name: WBConstant.WBEmotionDidDeleteNotification, object: nil)
    }
    
    // MARK: - 监听方法
///  删除文字
    func emotionDidDelete(){
        self.textView.deleteBackward()
    }
    ///  表情被选中了
    ///
    ///  - parameter notification: 通知
    func emotionDidSelect(notification:NSNotification){
        let emotion=notification.userInfo![WBConstant.WBSelectEmotionKey] as! WBEmotion
        self.textView.insertEmotion(emotion)
    }
    ///  键盘的frame发生改变时调用（显示、隐藏等）
    ///
    ///  - parameter notification: 通知
    func keyboardWillChangeFrame(notification:NSNotification){
        // 如果正在切换键盘，就不要执行后面的代码
        if(self.switchingKeyboard == true){
            return
        }else{
            let userInfo=notification.userInfo!
            // 动画持续时间
            let duration=userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
            // 键盘的frame
            let keyboardF=userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
            
            // 执行动画
            UIView.animateWithDuration(duration, animations: { () -> Void in
                // 工具条的Y值 == 键盘的Y值 - 工具条的高度
                if(keyboardF.origin.y > self.view.height){
                    // 键盘的Y值已经远远超过了控制器view的高度
                    self.toolbar.y=self.view.height-self.toolbar.height
                }else{
                    self.toolbar.y=keyboardF.origin.y-self.toolbar.height
                }
            })
        }
    }
    
    func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func send(){
        if(self.photosView.photos.count>0){
            self.sendWithImage()
        }else{
            self.sendWithoutImage()
        }
        // dismiss
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
///  发布带有图片的微博
    func sendWithImage(){
        // URL: https://upload.api.weibo.com/2/statuses/upload.json
        // 参数:
        /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
        /**	access_token true string*/
        /**	pic true binary 微博的配图。*/
        
        // 1.请求管理者
        let mgr=AFHTTPRequestOperationManager()
        
        // 2.拼接请求参数
        let params=NSMutableDictionary()
        params["access_token"]=WBAccountTool.account!.access_token
        params["status"]=self.textView.fullText()
        
        // 3.发送请求
        mgr.POST("https://upload.api.weibo.com/2/statuses/upload.json", parameters: params, constructingBodyWithBlock: { (formData:AFMultipartFormData) -> Void in
            // 拼接文件数据
            let image=self.photosView.photos[0]
            let data=UIImageJPEGRepresentation(image, 1.0)!
            formData.appendPartWithFileData(data, name: "pic", fileName: "test.jpg", mimeType: "image/jpeg")
            }, success: { (operation:AFHTTPRequestOperation, responseObject) -> Void in
                MBProgressHUD.showSuccess("发送成功")
            }) { (operation:AFHTTPRequestOperation, error) -> Void in
                MBProgressHUD.showError("发送失败")
        }
    }
    
///  发布没有图片的微博
    func sendWithoutImage(){
        // URL: https://api.weibo.com/2/statuses/update.json
        // 参数:
        /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
        /**	access_token true string*/
        
        // 1.请求管理者
        let mgr=AFHTTPRequestOperationManager()
        
        // 2.拼接请求参数
        let params=NSMutableDictionary()
        params["access_token"]=WBAccountTool.account!.access_token
        params["status"]=self.textView.fullText()
        
        // 3.发送请求
        mgr.POST("https://api.weibo.com/2/statuses/update.json", parameters: params, success: { (operation:AFHTTPRequestOperation, responseObject) -> Void in
            MBProgressHUD.showSuccess("发送成功")
            }) { (operation, error) -> Void in
                MBProgressHUD.showError("发送失败")
        }
    }
///  监听文字改变
    func textDidChange(){
        self.navigationItem.rightBarButtonItem!.enabled=self.textView.hasText()
    }
    
    // MARK: - UITextViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    // MARK: - WBComposeToolbarDelegate
    func composeToolbar(toolbar: WBComposeToolbar, didClickButton buttonType: WBComposeToolbarButtonType) {
        switch(buttonType){
        case WBComposeToolbarButtonType.HWComposeToolbarButtonTypeCamera:
            // 拍照
            self.openCamera()
            break
        case WBComposeToolbarButtonType.HWComposeToolbarButtonTypePicture:
            // 相册
            self.openAlbum()
            break
        case WBComposeToolbarButtonType.HWComposeToolbarButtonTypeMention:
            // @
            break
        case WBComposeToolbarButtonType.HWComposeToolbarButtonTypeTrend:
            // #
            break
        case WBComposeToolbarButtonType.HWComposeToolbarButtonTypeEmotion:
            self.switchKeyboard()
            break
        }
    }
    
    // MARK: - 其他方法
///  切换键盘
    func switchKeyboard(){
        // self.textView.inputView == nil : 使用的是系统自带的键盘
        if(self.textView.inputView == nil){
            // 切换为自定义的表情键盘
            self.textView.inputView=self.emotionKeyboard
            
            // 显示键盘按钮
            self.toolbar.showKeyboardButton=true
        }else{
            // 切换为系统自带的键盘
            self.textView.inputView=nil
            
            // 显示表情按钮
            self.toolbar.showKeyboardButton=false
        }
        
        // 开始切换键盘
        self.switchingKeyboard=true
        
        // 退出键盘
        self.textView.endEditing(true)
        
        // 结束切换键盘
        self.switchingKeyboard=false
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_MSEC*100)), dispatch_get_main_queue(), { () -> Void in
            // 弹出键盘
            self.textView.becomeFirstResponder()
        })
    }
    
    func openCamera(){
        self.openImagePickerController(UIImagePickerControllerSourceType.Camera)
    }
    
    func openAlbum(){
        // 如果想自己写一个图片选择控制器，得利用AssetsLibrary.framework，利用这个框架可以获得手机上的所有相册图片
        // UIImagePickerControllerSourceTypePhotoLibrary > UIImagePickerControllerSourceTypeSavedPhotosAlbum
        self.openImagePickerController(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    func openImagePickerController(type:UIImagePickerControllerSourceType){
        if(UIImagePickerController.isSourceTypeAvailable(type)==false){
            return
        }
        let ipc=UIImagePickerController()
        ipc.sourceType=type
        ipc.delegate = self
        self.presentViewController(ipc, animated: true, completion: nil)
    }
    // MARK: - UIImagePickerControllerDelegate
    ///  从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
    ///
    ///  - parameter picker: UIImagePickerController
    ///  - parameter info:   info description
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        // info中就包含了选择的图片
        let image=info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 添加图片到photosView中
        self.photosView.addPhoto(image)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
