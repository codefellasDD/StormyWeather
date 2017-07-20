//
//  ViewController.swift
//  StormyWeather
//
//  Created by Maik Rengsberger on 19.07.17.
//  Copyright © 2017 Maik Rengsberger. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    var location = CLLocationCoordinate2D()
    var lat:Double = 0.0
    var long:Double = 0.0
    
    var dailyForecastWeather = [DailyForecast]()
    let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    
    let swipeRec = UISwipeGestureRecognizer()
    
    //Current Weather outlets
    @IBOutlet weak var windBag: UIImageView!
    @IBOutlet weak var umbrella: UIImageView!
    @IBOutlet weak var rainDrop: UIImageView!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    //@IBOutlet weak var currentTimeLabel: UILabel!

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    //@IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var degreeButton: UIButton!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var heatIndex: UIImageView!
    @IBOutlet weak var dayZeroTemperatureLowLabel: UILabel!
    @IBOutlet weak var dayZeroTemperatureHighLabel: UILabel!
    
    @IBOutlet weak var windUILabel: UILabel!
    @IBOutlet weak var rainUILabel: UILabel!
    @IBOutlet weak var humidityUILabel: UILabel!
    
    
    //Daily Weather outlets
    @IBOutlet weak var dayZeroTemperatureLow: UILabel!
    @IBOutlet weak var dayZeroTemperatureHigh: UILabel!
    
    
    //Alerts
    
    @IBOutlet weak var wAlerts: UILabel!
    
    
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    var locationManager: CLLocationManager!
    var userLocation : String!
    var userLatitude : Double!
    var userLongitude : Double!
    var userTemperatureCelsius : Bool!
    
    var currently = [Currently]()
    
    var audioPlayer = AVAudioPlayer()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults: UserDefaults = UserDefaults.standard
        let tempCelsius = defaults.bool(forKey: "celsius")

        userTemperatureCelsius = tempCelsius
        print("defaults: celsius  = \(userTemperatureCelsius!)");
        
        swipeRec.addTarget(self, action: #selector(ViewController.swipedView))
        swipeRec.direction = UISwipeGestureRecognizerDirection.down
        swipeView.addGestureRecognizer(swipeRec)
        refresh()
       // updateWeatherForLocation(loc: "Dresden")
    }

    func updateWeatherForLocation(loc:String) {
        CLGeocoder().geocodeAddressString(loc) { (placemarks: [CLPlacemark]?,error: Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    self.lat = location.coordinate.latitude
                    self.long = location.coordinate.longitude

                    
                }
            }
        }
        
    }
    
    func swipedView(){
        
        self.swooshsound()
        refresh()
        
    }
    
    func refresh() {
        initLocationManager()
    }
    
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            let pm = placemarks?.first// ![0]
            self.displayLocationInfo(placemark: pm)
        })
        
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            self.userLatitude = coord.latitude
            self.userLongitude = coord.longitude
            
            
            
        }
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            guard let loco = locality, let admArea = administrativeArea else {return}
            self.userLocationLabel.text = "\(loco), \(admArea)"
            let latti = self.userLatitude!
            let longi = self.userLongitude!
            print("Location \(self.currently.count) für \(latti),\(longi)")
            self.dataManager.weatherDataForLocation(latitude: latti, longitude: longi) { (response, error) in
                //print("Anzahl \(self.currently.count) für \(self.userLatitude),\(self.userLongitude)")
                for dataPoint in self.currently {
                    print("huhu: \(dataPoint.temperature) für \(latti),\(longi)")
                    self.temperatureLabel.text = "Temp: \(dataPoint.temperature)"
                }
                
            }
        }
    }
    
    private func locationManager(manager: CLLocationManager,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LabelHasbeenUpdated"), object: nil)
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }
    
    
    @IBAction func degreeButtonPressed(sender: AnyObject) {
        
        print("TemperatureMode \(userTemperatureCelsius!)");
        
        
        
    }
    
    //SOUNDS
    
    func swooshsound() {
        
        let alertSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "swoosh", ofType: "wav")!)
        print(alertSound)
        
        var error:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: alertSound as URL)
        } catch var error1 as NSError {
            error = error1
            
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

