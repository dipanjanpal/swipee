//
//  SwipeeModel.swift
//  Swipee
//
//  Created by Dipanjan Pal on 07/04/20.
//  Copyright © 2020 Dipanjan Pal. All rights reserved.
//

import Foundation
struct SwipeeModel : Codable {
    let data : [Data]?

    enum CodingKeys: String, CodingKey {

        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([Data].self, forKey: .data)
    }

}

struct Data : Codable {
    let id : String?
    let text : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case text = "text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        text = try values.decodeIfPresent(String.self, forKey: .text)
    }

}
