//
//  ListData.swift
//  FetchTest
//
//  Created by Rita Carlson on 9/29/23.
//

import Foundation

struct ListData: Decodable {
    let id: Int
    let listId: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case listId
        case name
    }

    // custom JSON decoder to turn nulls into empty strings that will be removed later
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        id = try data.decode(Int.self, forKey: .id)
        listId = try data.decode(Int.self, forKey: .listId)
        
        // if name is null, turn it into empty string
        name = try data.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
    
}
