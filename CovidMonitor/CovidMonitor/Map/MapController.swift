//
//  HomeController.swift
//  CovidMonitor
//
//  Created by Harshit on 12/11/20.
//

import UIKit
import MapKit
import CoreLocation

extension MapController: MKMapViewDelegate {
    
    func getColorForRegion(regionTitle:String) -> UIColor {
        var regionColor:UIColor = .red
        for location in locations {
            if location.ring.title == regionTitle {
                let colorName = ruleRepository.getRuleColor(caseCount: location.cases)
                regionColor = UIColor(named: colorName!)!
            }
        }
        regionColor = regionColor.withAlphaComponent(0.4)
        return regionColor
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        }
        
        if let polyline = overlay as? MKPolygon {
            let polygonView = MKPolygonRenderer(polygon: polyline)
            polygonView.fillColor = getColorForRegion(regionTitle: polyline.title!)
            return polygonView
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
}

extension MapController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let detectedZone = findConvidZone(for: manager.location!) else {
            let alert = UIAlertController(title: noDataTitle.localized, message: noDataMsg.localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: btnOk.localized, style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        let newStatus = ruleRepository.getZoneName(caseCount: detectedZone.cases)
        
        if newStatus != currentZoneStatus && currentZoneStatus != "" {
            currentZoneStatus =  newStatus!
            
            let alert = UIAlertController(title: statusUpdateTitle.localized, message: statusUpdateMsg.localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: btnYes.localized, style: .default) { (action) in
                self.currentZone = detectedZone
                self.onBtnRulesTapped(action)
            })
            alert.addAction(UIAlertAction(title: btnNo.localized, style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        if currentZone == nil || currentZone.objId == detectedZone.objId {
            currentZone = detectedZone
            lblLocation.text = detectedZone.locationName
            self.lblZone.text = newStatus?.localized
        }
        
        locationManager.stopUpdatingLocation()
    }
}


class MapController: UIViewController {

    private var originalPullUpControllerViewSize: CGSize = .zero
    private let locationManager:CLLocationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lblZone: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    let ruleRepository = RuleRepository()
    var currentZone:MapRegion!
    var currentZoneStatus:String = ""
    var refreshTimer = Timer()
    var searchController:SearchController!
    var locations:[MapRegion]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        ruleRepository.loadFile()
        showLoading()
        setDetaultLocation()
        addPullUpController(animated: true)
        getLocations()
        configureTimer()
    }
    
    func configureTimer(){
        refreshTimer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: { (timer) in
            self.getLocations()
        })
    }
    
    @IBAction func onBtnRulesTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showRules", sender: currentZone)
    }
    
    @IBAction func onBtnUserLocationTapped(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
    func findConvidZone(for userLocation:CLLocation) -> MapRegion? {
        let mapPoint = MKMapPoint(userLocation.coordinate)
        for location in locations {
            if location.containsLocation(location: mapPoint) == true {
                return location
            }
        }
        return nil
    }
    
    func setDetaultLocation(){
        
        let initialLocation = CLLocationCoordinate2DMake(48.90748327947185, 11.786361464479626)
        mapView.setRegion(MKCoordinateRegion(center: initialLocation, latitudinalMeters: 375000, longitudinalMeters: 375000), animated: true)
    }
    
    func showOverlays() {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        for location in locations {
            mapView.addOverlay(location.ring)
        }
    }
    
    func getLocations() {
        let networkAdapter = RegionRepository()
        networkAdapter.getAllLocations { (response, success) in
            if success == true {
                self.locations = response as? [MapRegion]
                self.showOverlays()
                self.searchController.updateLocations(updatedLocations: self.locations)
                self.getUserLocation()
            }
            self.hideLoading()
        }
    }
    
    private func makeSearchViewControllerIfNeeded() -> SearchController {
        let currentPullUpController = children
            .filter({ $0 is SearchController })
            .first as? SearchController
        let pullUpController: SearchController = currentPullUpController ?? UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchController
        pullUpController.initialState = .contracted

        if originalPullUpControllerViewSize == .zero {
            originalPullUpControllerViewSize = pullUpController.view.bounds.size
        }

        return pullUpController
    }

    private func addPullUpController(animated: Bool) {
        searchController = makeSearchViewControllerIfNeeded()
        _ = searchController.view // call pullUpController.viewDidLoad()
        addPullUpController(searchController,
                            initialStickyPointOffset: searchController.initialPointOffset,
                            animated: animated)
    }
    
    func focusOnLocation(location:MapRegion) {
        mapView.setVisibleMapRect(location.ring.boundingMapRect, edgePadding: UIEdgeInsets(top: 100.0, left: 100.0, bottom: 100.0, right: 100.0), animated: true)
        lblLocation.text = location.locationName
        lblZone.text = ruleRepository.getZoneName(caseCount: location.cases).localized
        currentZone = location
    }
    
    func getUserLocation(){
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRules" {
            let destination = segue.destination as! RulesController
            destination.caseCount = currentZone.cases
        }
    }
}
