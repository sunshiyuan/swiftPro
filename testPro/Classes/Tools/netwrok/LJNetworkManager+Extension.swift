 //
//  LJNetworkManager+Extension.swift
//  testPro
//
//  Created by ljkj on 2018/7/4.
//  Copyright © 2018年 ljkj. All rights reserved.
//

import Foundation

// MARK: -封装wb的网络请求方法
extension LJNetworkManager {
    
    /// 加载微博数据字典数组
    ///
    /// - Parameters:
    ///   - since_id: 返回比since_id大的微博，默认0
    ///   - max_id: 返回比max_id小的微博 默认 0
    ///   - completion: 完成回调 list
    func statusList(since_id:Int64 = 0,max_id:Int64 = 0, completion:@escaping (_ list:[[String:Any]]?,_ isSuccess:Bool)->()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
//        let params = ["access_token":"2.00hUXEeC31bUKE02e9483882bnmvXE"]
        // swift 中int 可以转为any 但是 Int64不可以
        let params = ["since_id":"\(since_id)",
            "max_id":"\(max_id > 0 ? max_id - 1 : 0)"]
        tokenRequest(urlString: urlString, parameters: params) { (json, isSuccess) in
            
            // 从json中取出 accessToken
            // 如果 as? 失败  restul为nil
            // 服务器返回的数据，按照时间倒序排序的
            let result = (json as? NSDictionary)?["statuses"] as? [[String:Any]]
            completion(result,isSuccess)
        }
    }
    
    
    /// 返回微博的未读数量
    func unreadCount(completion:@escaping(_ count:Int) -> ()) {
        
        guard let uid = userAccount.uid else {
            return
        }
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json";
        let params = ["uid":uid]
        tokenRequest(urlString: urlString, parameters: params) { (json, isSuccess) in
            
            print("取出数据信息\(json ?? "无数据")")
            let dict = json as? [String:Any]
            let count = dict?["status"] as? Int
            completion(count ?? 0)

        }
        
    }
    
}


// MARK: - Oauth相关方法
extension LJNetworkManager {
    
    
    /// 加载accessToken
    func loadAccessToken(code:String,completion:@escaping(_ isSuccess:Bool)->()) {
        
        let url = "https://api.weibo.com/oauth2/access_token"
        let params = [
            "client_id":LJAppKey,
            "client_secret":LJAppSecret,
            "grant_type":"authorization_code",
            "code":code,
            "redirect_uri":ljAppDirectUrl
                    ]
        
        // 发起网络请求
        request(method: .POST, URLString: url, parameters: params) { (json, isSuccess) in
        
            self.userAccount.yy_modelSet(with: json as? [String:Any] ?? [:])
            self.loadUserInfo(completion: { (dict) in
                
                self.userAccount.yy_modelSet(with: dict)
                self.userAccount.saveAccount()
                print(self.userAccount)
                completion(isSuccess)

            })
            
        }
        
    }
    
}


// MARK: - 用户信息
extension LJNetworkManager {
    
    
    /// 加载用户信息 用户登录后立即执行
    func loadUserInfo(completion:@escaping(_ dict:[String:Any])->()) {
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        guard let uid = userAccount.uid else {
            return
        }
        let params = ["uid":uid]
        // 发起请求
        tokenRequest(urlString: urlString, parameters: params) { (json, isSuccess) in
            
            print(json)
            // 完成回调
            completion(json as? [String:Any] ?? [:])
        }
        
    }
    
}
 
// MARK: - 发布
 extension LJNetworkManager {
    
    
    /// 发布
    func postStatus(text:String, image:UIImage?,completion:@escaping(_ result:[String:Any]?,_ isSuccess:Bool)->())-> () {
        
        // url
        let urlString: String
        if image == nil {
            urlString = "https://api.weibo.com/2/statuses/update.json"
        }else {
            urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
        }
        
        // 参数字典
        let params = ["status":text]
        
        // 如果图片不为空，需要设置name和data
        var name:String?
        var data:Data?
        if image != nil {

            name = "pic"
            data = UIImagePNGRepresentation(image!)
        }
        // 发起网络请求
        tokenRequest(method: .POST, urlString: urlString, parameters: params, name: name, data: data) { (json, isSuccess) in
            
             completion(json as? [String:Any], isSuccess)
        }
        
    }
    
 }



