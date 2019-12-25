//
//  HomeListController.swift
//  swiftProject
//
//  Created by yangshichuan on 2019/12/4.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

import UIKit

class HomeListController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        print("我是首页")
        let logImage: UIImage = UIImage.init(named: "platback_camera_selected_icon")!
        
        let image: UIImage = UIImage.createQRCode(withData: "THING_SHARE_0c024e04-a31d-42d8-8df7-971e909711c2", logoImage: logImage, imageSize: 200)
        
        self.imageView.image = image
        
        
        
        
    }
    @IBAction func clickNetworkButton(_ sender: Any) {
        let monitor:MonitorViewController = MonitorViewController.init()
        self.present(monitor, animated: true, completion: nil)
        
    }
}
