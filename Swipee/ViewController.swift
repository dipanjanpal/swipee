//
//  ViewController.swift
//  Swipee
//
//  Created by Dipanjan Pal on 07/04/20.
//  Copyright © 2020 Dipanjan Pal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://gist.githubusercontent.com/anishbajpai014/d482191cb4fff429333c5ec64b38c197/raw/b11f56c3177a9ddc6649288c80a004e7df41e3b9/HiringTask.json") {
            do {
                var contents = try String(contentsOf: url)
                contents.remove(at: contents.startIndex)
                print("content after handling / ===>>>", contents)
                if let data = contents.data(using: String.Encoding.utf8){
                    do {
                        let response = try JSONDecoder().decode(SwipeeModel.self, from: data)
                        print("response of data ===>>>", response)
                    }
                    catch let err{
                        print("data decoding error ===>>>", err)
                    }
                }
                else{
                    print("can't convert data to string")
                }
            } catch let err {
                print("link fetching error ===>>", err)
            }
        } else {
            print("can't build URL")
        }
    }


}

