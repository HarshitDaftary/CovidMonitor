//
//  RegionRepository.swift
//  CovidMonitor
//
//  Created by Harshit on 16/11/20.
//

import Foundation
import Alamofire

let baseUrl = "https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/0/"

class RegionRepository {
    
    func getAllLocations(completion: @escaping(Any,Bool) -> Void) {
        
        let reqUrl = baseUrl + "query?where=BL_ID%20%3D%20%279%27&outFields=OBJECTID,county,cases7_per_100k,GEN,last_update,BL_ID,BL,BEZ&outSR=4326&f=json"
        
        let request = AF.request(reqUrl)
        
        request.responseJSON { response in
            
            switch (response.result) {
            
            case .success( _):
                
                do {
                    let jsonResponse = try JSONDecoder().decode(ZoneResponse.self,from: response.data!)
                    completion(jsonResponse.locations,true)
                    
                } catch let error as NSError {
                    completion(error.localizedDescription,false)
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                completion(error.localizedDescription,false)
                print("Request error: \(error.localizedDescription)")
            }
        }
    }
}
