//
//  RulesRepository.swift
//  CovidMonitor
//
//  Created by Harshit on 15/11/20.
//

import Foundation
import UIKit

class RuleRepository {
    
    var rules:[ZoneDetail]!
    
    func loadFile()  {
        
        if let settingsURL = Bundle.main.path(forResource: "Rules", ofType: "plist") {
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: settingsURL))
                let decoder = PropertyListDecoder()
                let responseModel = try decoder.decode([ZoneDetail].self, from: data)
                self.rules = responseModel
                
            } catch {
                print(error)
            }
        }
    }
        
    func getZone(caseCount:Int) -> ZoneDetail? {
        for zoneDetail in self.rules {
            if caseCount > zoneDetail.min! && caseCount < zoneDetail.max! {
                return zoneDetail
            }

            if zoneDetail.max! == 0 && caseCount > zoneDetail.min! {
                return zoneDetail
            }
            
            if zoneDetail.min! == 0 && caseCount < zoneDetail.max! {
                return zoneDetail
            }
        }
        return nil
    }
    
    func getZoneName(caseCount:Int) -> String! {
        if let zone = self.getZone(caseCount: caseCount) {
            return zone.zoneName
        }
        return "Red Zone"
    }
    
    func getRules(caseCount:Int) -> [ZoneRule] {
        if let zone = self.getZone(caseCount: caseCount) {
            return zone.rules!
        }
        return []
    }
    
    func getRuleColor(caseCount:Int) -> String! {

        if let zone = self.getZone(caseCount: caseCount) {
            return zone.colorName
        }
        return "zone_red"
    }
}

