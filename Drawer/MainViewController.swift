//
//  MainViewController.swift
//  Drawer
//
//  Created by wheng on 2017/7/4.
//  Copyright © 2017年 wheng. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.red
        // Do any additional setup after loading the view.
        
        addLeftButtonItem()
    }
    
    func addLeftButtonItem() {
        let buttonItem = UIBarButtonItem.init(title: "抽屉", style: .plain, target: self, action: #selector(drawerAction))
        self.navigationItem.leftBarButtonItem = buttonItem
    }
    
    func drawerAction() {
        DrawerViewController.shared.openDrawer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
