//
//  TACategory.swift
//  Tangent
//
//  Created by Vikram Singh on 4/24/23.
//

import Foundation
struct TACategory: Decodable {
    let title: String
    enum CodingKeys: String, CodingKey {
        case title = "Title"
    }
}
