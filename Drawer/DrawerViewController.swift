//
//  ViewController.swift
//  Drawer
//
//  Created by wheng on 2017/7/4.
//  Copyright © 2017年 wheng. All rights reserved.
//

import UIKit

final class DrawerViewController: UIViewController {
    // 创建单例
    static let shared = DrawerViewController()
    
    var leftViewController: UIViewController?
    var mainNavViewController: UINavigationController!
    
    var maxWidth: CGFloat?
    var coverButton: UIButton?
    
    var alp:Double = 0.5

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 创建遮罩
        setCoverButton()
        
        view.backgroundColor = UIColor.blue
        
        leftViewController?.view.transform = CGAffineTransform.init(translationX: -maxWidth!, y: 0)
        
        addScreenEdgePanGestureRecognizer(view: mainNavViewController.view)
    }
    
    
    /// 创建抽屉
    ///
    /// - Parameters:
    ///   - leftVC: 左侧控制器
    ///   - mainNavVC: 主控制器
    ///   - drawerMaxWidth: 抽屉偏移
    /// - Returns: 抽屉控制器
    class func drawerWithViewController(leftVC: UIViewController?, mainNavVC: UINavigationController, drawerMaxWidth: CGFloat) -> DrawerViewController {
        let drawerViewController = DrawerViewController.shared
        
        drawerViewController.leftViewController = leftVC
        drawerViewController.mainNavViewController = mainNavVC
        
        drawerViewController.maxWidth = drawerMaxWidth
        
        if leftVC != nil {
            drawerViewController.view.addSubview((leftVC?.view)!)
            drawerViewController.addChildViewController(leftVC!)
        }
        
        drawerViewController.view.addSubview(mainNavVC.view)
        drawerViewController.addChildViewController(mainNavVC)
        
        
        return drawerViewController
    }
    
    
    /// 边缘手势
    ///
    /// - Parameter view: 添加手势的view
    func addScreenEdgePanGestureRecognizer(view: UIView) -> Void {
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: (#selector(screenEdgePanGestureRecongnizer(pan:))))
        pan.edges = UIRectEdge.left
        view.addGestureRecognizer(pan)
        
        return
    }
    
    
    /// 边缘手势的响应
    ///
    /// - Parameter pan: 边缘手势
    func screenEdgePanGestureRecongnizer(pan: UIScreenEdgePanGestureRecognizer) -> Void {
        
        let offsetX = pan.translation(in: pan.view).x
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            
            if pan.state == .changed && offsetX < self.maxWidth! {
                self.mainNavViewController.view.transform = CGAffineTransform.init(translationX: offsetX, y: 0)
                self.leftViewController?.view.transform = CGAffineTransform.init(translationX: -self.maxWidth! + offsetX, y: 0)
                self.coverButton?.alpha = 0.5 * offsetX / DRAWER_WIDTH
            } else if pan.state == .cancelled || pan.state == .ended || pan.state == .failed {
                if offsetX > SCREEN_WIDTH / 3 {
                    self.openDrawer(openDrawerWithDuration: (self.maxWidth! - offsetX)/self.maxWidth! * 0.2)
                } else {
                    self.closeDrawer(closeDrawerWithDuration: offsetX / self.maxWidth! * 0/2)
                }
            }
            
            
            
        }, completion: nil)
        
        return
    }
 
    /// 打开抽屉
    func openDrawer(openDrawerWithDuration: CGFloat = 0.2) -> Void {
//        coverButton?.alpha = CGFloat(alp)
        coverButton?.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: TimeInterval.init(openDrawerWithDuration), delay: 0, options: .curveLinear, animations: {
            self.coverButton?.alpha = CGFloat(self.alp)

            self.mainNavViewController.view.transform = CGAffineTransform.init(translationX: self.maxWidth!, y: 0)
            self.leftViewController?.view.transform = CGAffineTransform.identity
        }, completion: nil)
        return
    }
    
    /// 关闭抽屉
    func closeDrawer(closeDrawerWithDuration: CGFloat = 0.2) -> Void {
//        coverButton?.alpha = 0
        coverButton?.isUserInteractionEnabled = false
        var time = closeDrawerWithDuration
        if time == 0 {
            time = 0.2
        }
        UIView.animate(withDuration: TimeInterval(time), delay: 0, options: .curveLinear, animations: {
            self.coverButton?.alpha = 0;
            self.leftViewController?.view.transform = CGAffineTransform.init(translationX: -self.maxWidth!, y: 0)
            self.mainNavViewController.view.transform = CGAffineTransform.identity
        }, completion: nil)
        
        return
    }
    
    /// 创建抽屉按钮
    func setCoverButton() -> Void {
        guard coverButton != nil else {
            coverButton = UIButton(type: .custom)
            coverButton?.backgroundColor = UIColor.black
            self.coverButton?.alpha = 0
            coverButton?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            coverButton?.addTarget(self, action: #selector(closeDrawer), for: .touchUpInside)
            addPanGestureRecognizer(view: coverButton!)
            coverButton?.isUserInteractionEnabled = false
            mainNavViewController.view.addSubview(coverButton!)
            
            return
        }
    }
    
    
    /// 给遮罩按钮添加拖拽手势
    ///
    /// - Parameter view: 遮罩按钮
    func addPanGestureRecognizer(view: UIView) {
        let pan = UIPanGestureRecognizer.init(target: self, action: (#selector(panGestureRecognizer(pan:))))
        view.addGestureRecognizer(pan)
    }
    
    /// 拖拽手势响应
    func panGestureRecognizer(pan: UIPanGestureRecognizer) -> Void {
        let offsetX = pan.translation(in: pan.view).x
        
        if pan.state == .cancelled || pan.state == .failed || pan.state == .ended {
            
            if offsetX < 0 , SCREEN_WIDTH - maxWidth! + abs(offsetX) > SCREEN_WIDTH * 0.5 {
                
                closeDrawer(closeDrawerWithDuration: (maxWidth! + offsetX) / maxWidth! * 0.2)
            } else {
                openDrawer(openDrawerWithDuration: abs(offsetX) / maxWidth! * 0.2)
            }
        } else if pan.state == .changed {
            if offsetX < 0 , offsetX > -maxWidth! {
                self.coverButton?.alpha = 0.5 + 0.5 * offsetX / DRAWER_WIDTH
                
                mainNavViewController.view.transform = CGAffineTransform.init(translationX: self.maxWidth! + offsetX, y: 0)
                leftViewController?.view.transform = CGAffineTransform.init(translationX: offsetX, y: 0)
            }
        }
        
        return
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

