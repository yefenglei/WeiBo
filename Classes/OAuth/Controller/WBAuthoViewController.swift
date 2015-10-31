//
//  WBAuthoViewController.swift
//  WeiBo
//
//  Created by 叶锋雷 on 15/9/23.
//  Copyright © 2015年 叶锋雷. All rights reserved.
//

import UIKit

class WBAuthoViewController: UIViewController,UIWebViewDelegate,NSURLConnectionDelegate {

    var webview:UIWebView!
    var _Authenticated=false
    var _FailedRequest:NSURLRequest!
    let url=NSURL(string: "https://api.weibo.com/oauth2/authorize?client_id=1474004406&redirect_uri=http://www.baidu.com&response_type=code")!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.创建一个webview
        webview=UIWebView()
        webview.frame=self.view.bounds
        webview.delegate=self
        self.view.addSubview(webview)
        
        // 2.用webview加载登陆页面
        // 请求授权地址https://api.weibo.com/oauth2/authorize
        
        //必选	类型及范围	说明
        //client_id	true	string	申请应用时分配的AppKey。
        //redirect_uri	true	string	授权回调地址，站外应用需与设置的回调地址一致，站内应用需填写canvas page的地址。
        let request=NSURLRequest(URL: url)
        webview.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let scheme=request.URL?.scheme
        // 1.获取url
        let urlStr=request.URL!.absoluteString as NSString
        if(scheme?.lowercaseString=="https"){//判断是不是https,如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
            if(!_Authenticated){
                self._FailedRequest=request
                let conn=NSURLConnection(request: request, delegate: self)
                conn?.start()
                webView.stopLoading()
                return false
            }
        }
        
        // 2.判断是否为回掉地址
        let range=urlStr.rangeOfString("code=")
        if(range.length != 0){// 是回调地址
            // 截取code＝后面的参数值
            let fromIndex:Int=range.location+range.length
            let code:String=urlStr.substringFromIndex(fromIndex)
            // 利用code换取一个accessToken
            self.accessToken(code)
            // 禁止跳转回掉页面
            return false
        }
        return true
    }

    
    func accessToken(code:String){
        /*
        URL：https://api.weibo.com/oauth2/access_token
        
        请求参数：
        client_id：申请应用时分配的AppKey
        client_secret：申请应用时分配的AppSecret
        grant_type：使用authorization_code
        redirect_uri：授权成功后的回调地址
        code：授权成功后返回的code
        */

        // 1.拼接请求参数
        let params=NSMutableDictionary()
        params["client_id"] = WBConstant.WBAppKey
        params["client_secret"]=WBConstant.WBAppSecret
        params["grant_type"]="authorization_code"
        params["redirect_uri"]=WBConstant.WBRedirectURI
        params["code"]=code
        // 2.发送请求
        
        WBHttpTool.post("https://api.weibo.com/oauth2/access_token", params: params, success: { (responseObject) -> Void in
            let dictData:NSDictionary?=responseObject as? NSDictionary
            // 将字典数据 转为 模型
            let account=WBAccount(dictData: dictData!)
            // 存储账号信息
            WBAccountTool.saveAccount(account)
            // 切换窗口的根控制器
            let window=UIApplication.sharedApplication().keyWindow
            window?.switchRootViewController()
            }) { (error) -> Void in
                MBProgressHUD.hideHUD()
        }
    }
    // MARK: - UIWebViewDelegate
    func webViewDidFinishLoad(webView: UIWebView) {
        MBProgressHUD.hideHUD()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        MBProgressHUD.showMessage("数据加载中...")
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        MBProgressHUD.hideHUD()
    }
    
    // MARK: - NSURLConnectionDelegate
    func connection(connection: NSURLConnection, willSendRequestForAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        if(challenge.previousFailureCount==0){
            _Authenticated=true
            //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
            let cre = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
            challenge.sender?.useCredential(cre, forAuthenticationChallenge: challenge)
        }else{
            challenge.sender?.cancelAuthenticationChallenge(challenge)
        }
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        self._Authenticated=true
        //webview 重新加载请求。
        webview.loadRequest(_FailedRequest)
        // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
        connection.cancel()
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
