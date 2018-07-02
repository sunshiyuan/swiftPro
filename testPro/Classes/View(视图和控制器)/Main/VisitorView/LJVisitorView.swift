//
//  LJVisitorView.swift
//  testPro
//
//  Created by ljkj on 2018/6/30.
//  Copyright © 2018年 ljkj. All rights reserved.
//

import UIKit


/// 访客视图
class LJVisitorView: UIView {

    /// 使用字典访问访客视图
    /// - Parameter dict: [imageName / message ]
    /// 提示: 如果是首页 imageName = ""
    var visitorInfo:[String:String]? {
        didSet{
            // 1. 取出字典信息
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"]  else {
                    return
            }
            //2. 设置消息
            tiplable.text = message
            //3. 设置图像
            if imageName == "" {
                startAnimation()
                return
            }
            iconView.image = UIImage(named: imageName)
            // 其他控制器  隐藏小房子 遮罩
            houseIconView.isHidden = true
            markIconView.isHidden = true
        }
    }
    // MARK: -构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 旋转动画
    private func startAnimation() {
        let ani = CABasicAnimation(keyPath: "transform.rotation")
        ani.toValue = 2 * Double.pi
        ani.repeatCount = MAXFLOAT
        ani.duration = 15
        // 动画完成不删除，如果iconView被释放，动画一起销毁
        ani.isRemovedOnCompletion = false
        // 将图层添加到图层
        iconView.layer.add(ani, forKey: nil)
        
    }
    
    // MARK: - 私有控件
    /// 懒加载属性什么时候需要添加属性 只有调用 UIKit 控件的指定构造函数，其他都需要使用类型
    /// 图像视图
    private lazy var iconView:UIImageView  = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    /// 小房子
    private lazy var houseIconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    /// 遮罩图像
    private lazy var markIconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    /// 提示标签
    private lazy var tiplable:UILabel = UILabel.cz_label(withText: "关注一些人，回这里看看有什么惊喜关注一些人，回这里看看有什么惊喜", fontSize: 14, color: UIColor.darkGray)
    /// 注册按钮
    private lazy var registerButton: UIButton = UIButton.cz_textButton(
        "注册",
        fontSize: 16,
        normalColor: UIColor.orange,
        highlightedColor: UIColor.black,
        backgroundImageName: "common_button_white_disable")
    /// 登录按钮
    private lazy var loginButton: UIButton = UIButton.cz_textButton(
        "登录",
        fontSize: 16,
        normalColor: UIColor.darkGray,
        highlightedColor: UIColor.black,
        backgroundImageName: "common_button_white_disable")
    
    
}

// MARK: -设置界面
extension LJVisitorView {
    
    private func setupUI() {
        backgroundColor = UIColor.cz_color(withHex: 0xEDEDED)
        
        // 添加控件
        addSubview(iconView)
        addSubview(houseIconView)
        addSubview(markIconView)
        addSubview(tiplable)
        addSubview(registerButton)
        addSubview(loginButton)
        
        tiplable.textAlignment = .center
        
        // 代码布局 取消autoresizing
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        // 自动布局
        let margin:CGFloat = 20.0
        // 图像视图
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: -60))
        // 小房子
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: -10))
    
        // 提示标签
        addConstraint(NSLayoutConstraint(item: tiplable,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                          toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: tiplable,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: tiplable,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 236))
        // 注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: tiplable,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tiplable,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 100))
        // 登录按钮
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: tiplable,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tiplable,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: registerButton,
                                         attribute: .width,
                                         multiplier: 1.0,
                                         constant: 0))
        // 遮罩图像 VFL
        // views:定义 VFL 中的控件名称和实际名称的映射关系
        // metrics: 定义 VFL 中 () 指定的常数映射关系
        let viewDic = ["markIconView": markIconView,
                       "registerButton":registerButton] as [String : Any]
        let metrics = ["spacing":-35]
        addConstraints(NSLayoutConstraint.constraints(
            // 水平方向  H  距离左右边界  0
            withVisualFormat: "H:|-0-[markIconView]-0-|",
            options: [],
            metrics: nil,
            views: viewDic))
        addConstraints(NSLayoutConstraint.constraints(
            // markIconView 距离顶边为0 距离底边registerButton为0
            // withVisualFormat: "V:|-0-[markIconView]-0-[registerButton]",
            // withVisualFormat: "V:|-0-[markIconView]-(-35)-[registerButton]",
            withVisualFormat: "V:|-0-[markIconView]-(spacing)-[registerButton]",
            options: [],
            metrics: metrics,
            views: viewDic))
    }
}
