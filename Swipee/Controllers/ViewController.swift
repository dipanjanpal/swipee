//
//  ViewController.swift
//  Swipee
//
//  Created by Dipanjan Pal on 07/04/20.
//  Copyright © 2020 Dipanjan Pal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var objSwipee : SwipeeModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //internet connection cehcking
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            fetchData()
        }else{
            print("Internet Connection not Available!")
        }
        
        
    }
    
    //MARK: api call
    
    func fetchData(){
        // common networking function is called. And we'll get back a model if call and convestion is success otherwise we'll get error flag true and an error msg.
        BaseNetworking.fetch { (model, err, errMsg) in
            if !err{
                
            }
            else{
                print("some error occured ===>>>", errMsg ?? "")
            }
        }
    }
}

