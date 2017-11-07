//
//  MomanceTests.swift
//  MomanceTests
//
//  Created by Minki on 2017. 11. 6..
//  Copyright © 2017년 Shifter. All rights reserved.
//

import XCTest
import CoreLocation

class MomanceTests: XCTestCase, CLLocationManagerDelegate {
    
    var startLocation: CLLocation?
    var locationManager: CLLocationManager = CLLocationManager()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        locationManager.delegate = self
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        var locationManager: CLLocationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest   // 배터리로 동작할때 권장되는 가장 높은 수준의 정확도 - 배터리 많이 먹음 ㅠ
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        
        
        // Region start
        func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let latestLocation: AnyObject = locations[locations.count - 1]
            print("latitude:\(String(format: "%.4f", latestLocation.coordinate.latitude))")
            print("longitude:\(String(format: "%.4f", latestLocation.coordinate.longitude))")
            print("horizontalAccuracy:\(String(format: "%.4f", latestLocation.horizontalAccuracy))")
            print("altitude:\(String(format: "%.4f", latestLocation.altitude))")
            print("verticalAccuracy:\(String(format: "%.4f", latestLocation.verticalAccuracy))")
            
            if startLocation == nil {
                startLocation = latestLocation as! CLLocation
            }
            let distanceBetween: CLLocationDistance = latestLocation.distance(from: startLocation!)
            print("distance:\(String(format: "%.2f", distanceBetween))")
            
        }
        
        func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
            print("GPS Error => \(error.localizedDescription)")
        }
        
        func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            // 애플리케이션의 위치 추적 허가 상태가 변경될 경우 호출
        }
        // Region end
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
