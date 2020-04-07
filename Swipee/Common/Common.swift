//
//  Common.swift
//  Swipee
//
//  Created by Dipanjan Pal on 07/04/20.
//  Copyright © 2020 Dipanjan Pal. All rights reserved.
//

import Foundation
import UIKit
class Common {
    static let BASEURL = "https://gist.githubusercontent.com/anishbajpai014/d482191cb4fff429333c5ec64b38c197/raw/b11f56c3177a9ddc6649288c80a004e7df41e3b9/HiringTask.json"
    
    //common alert function for all viewcontrollers
    static func alert(message : String, vc : UIViewController){
        let alert = UIAlertController(title: "Swipee", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.navigationController?.present(alert, animated: true, completion: nil)
    }
}
