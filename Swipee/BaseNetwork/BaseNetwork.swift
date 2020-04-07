//
//  BaseNetwork.swift
//  Swipee
//
//  Created by Dipanjan Pal on 07/04/20.
//  Copyright © 2020 Dipanjan Pal. All rights reserved.
//

import Foundation

class BaseNetworking{
    
    //MARK: - common fetch api function
    
    //since we are working with only one api link thus have taken endpoint and baseurl in same
    //constant. Not taking endpoint seperately for every api call from user.
    static func fetch(completion : @escaping (_ model : SwipeeModel?, _ error : Bool, _ errMsg : String?) -> ()){
        if let url = URL(string: Common.BASEURL) {
            do {
                var contents = try String(contentsOf: url)
                contents.remove(at: contents.startIndex)
                print("content after handling / ===>>>", contents)
                if let data = contents.data(using: String.Encoding.utf8){
                    do {
                        let response = try JSONDecoder().decode(SwipeeModel.self, from: data)
                        print("response of data ===>>>", response)
                        //since we will have no error at this point thus we can pass response
                        //and make error false. And there won't be any error msg.
                        completion(response,false, nil)
                    }
                    catch let err{
                        let errMsg = "data decoding error"
                        print("\(errMsg) ===>>>", err)
                        //since we will have error at this point thus we will make error true
                        // and there will an error msg.
                        completion(nil,true, errMsg)
                    }
                }
                else{
                    let errMsg = "can't convert data to string"
                    print(errMsg)
                    //since we will have error at this point thus we will make error true
                    // and there will an error msg.
                    completion(nil,true, errMsg)
                }
            } catch let err {
                let errMsg = "link fetching error"
                print("errMsg ===>>", err)
                //since we will have error at this point thus we will make error true
                // and there will an error msg.
                completion(nil,true, errMsg)
            }
        } else {
            let errMsg = "can't build URL"
            print(errMsg)
            //since we will have error at this point thus we will make error true
            // and there will an error msg.
            completion(nil,true, errMsg)
        }
    }
}
