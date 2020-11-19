//
//  CovidZone.swift
//  CovidMonitor
//
//  Created by Harshit on 16/11/20.
//

import Foundation
import MapKit

fileprivate struct RawServerResponse: Decodable {
    
    struct Attribute: Decodable {
        var GEN: String
        var OBJECTID:Int
        var cases7_per_100k:Double
        var last_update:String
    }
    
    struct Geometry: Decodable {
        var ring: MKPolygon!
        
        enum CodingKeys: String, CodingKey {
            case rings
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let ringList = try container.decode([[[Double]]].self, forKey: .rings)[0]
            var coordinates:[CLLocationCoordinate2D] = Array()
            for coordinate in ringList {
                let location = CLLocationCoordinate2DMake(coordinate[1], coordinate[0])
                coordinates.append(location)
            }
            ring = MKPolygon(coordinates: coordinates, count: coordinates.count)
        }
    }
    
    struct Features: Decodable {
        var attributes:Attribute
        var geometry:Geometry
    }
    
    var features: [Features]
}

struct MapRegion {

    var ring:MKPolygon!
    var objId:Int = 0
    var locationName:String = ""
    var cases:Int = 0
    
    init() {}
    
    func containsLocation(location:MKMapPoint) -> Bool {
        let renderer = MKPolygonRenderer(polygon: ring!)
        let renderedPoint = renderer.point(for: location)
        return renderer.path.contains(renderedPoint)
    }
}

struct ZoneResponse: Decodable {
    
    var locations:[MapRegion] = Array()

    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerResponse(from: decoder)
        
        for feature in rawResponse.features {
            var location = MapRegion()
            location.objId = feature.attributes.OBJECTID
            location.ring = feature.geometry.ring
            location.ring.title = "\(feature.attributes.OBJECTID)"
            location.locationName = feature.attributes.GEN
            location.cases = Int(feature.attributes.cases7_per_100k)
            locations.append(location)
        }
    }
    
    func findConvidZone(for location:CLLocationCoordinate2D) -> MapRegion? {
        let mapPoint = MKMapPoint(location)
        for location in locations {
            if location.containsLocation(location: mapPoint) == true {
                return location
            }
        }
        return nil
    }
}
