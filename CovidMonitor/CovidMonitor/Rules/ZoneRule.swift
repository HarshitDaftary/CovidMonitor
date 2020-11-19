//
//  Rule.swift
//  CovidMonitor
//
//  Created by Harshit on 19/11/20.
//

import Foundation

struct ZoneDetail : Decodable {
    
    let zoneName : String?
    let zoneId : String?
    let colorName: String?
    let min : Int?
    let max : Int?
    let rules : [ZoneRule]?
    
    enum CodingKeys: String, CodingKey {
        
        case zoneName = "zoneName"
        case zoneId = "zoneId"
        case colorName = "colorName"
        case min = "min"
        case max = "max"
        case rules = "rules"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        zoneName = try values.decodeIfPresent(String.self, forKey: .zoneName)
        zoneId = try values.decodeIfPresent(String.self, forKey: .zoneId)
        min = try values.decodeIfPresent(Int.self, forKey: .min)
        max = try values.decodeIfPresent(Int.self, forKey: .max)
        rules = try values.decodeIfPresent([ZoneRule].self, forKey: .rules)
        colorName = try values.decodeIfPresent(String.self, forKey: .colorName)
    }
}

struct ZoneRule : Decodable {
    
    let image : String?
    let description : String?
    
    enum CodingKeys: String, CodingKey {
        
        case image = "image"
        case description = "description"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        description = try values.decodeIfPresent(String.self, forKey: .description)
    }
    
}

