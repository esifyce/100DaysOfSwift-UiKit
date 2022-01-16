//
//  ViewController.swift
//  75.Day-Project22-CoreLocation
//
//  Created by Sabir Myrzaev on 14.01.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var circle: UIImageView!
    
    var locationManager: CLLocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        circle.layer.zPosition = -1
        
        view.backgroundColor = .gray
        
        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 12, options: [], animations: {
            self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        
        switch distance {
        case .far:
            UIView.animate(withDuration: 1) {
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 12, options: [], animations: {
                self.circle.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
            })
        case .near:
            UIView.animate(withDuration: 1) {
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 12, options: [], animations: {
                self.circle.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        case .immediate:
            UIView.animate(withDuration: 1) {
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 12, options: [], animations: {
                self.circle.transform = CGAffineTransform(scaleX: 0.03, y: 0.03)
            })
        case .unknown:
            UIView.animate(withDuration: 1) {
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            }
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            })
            startScanning()
        @unknown default:
            UIView.animate(withDuration: 1) {
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if beacons.first?.uuid.uuidString == "B0702880-A295-A8AB-F734-031A98A512DF" {
            let ac = UIAlertController(title: "iBeacon found", message: "Tracking beacon: FIND", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
}

