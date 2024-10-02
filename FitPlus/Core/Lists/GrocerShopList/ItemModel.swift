//
//  ItemModel.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 21/07/24.
//

import Foundation

struct ItemModel: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    var isCompleted: Bool
    let listId: String
    let dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case isCompleted = "is_completed"
        case listId = "list_id"
        case dateCreated = "date_created"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        self.listId = try container.decode(String.self, forKey: .listId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.isCompleted, forKey: .isCompleted)
        try container.encode(self.listId, forKey: .listId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
}
