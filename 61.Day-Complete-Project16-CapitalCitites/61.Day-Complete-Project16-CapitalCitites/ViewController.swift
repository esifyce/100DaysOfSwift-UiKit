//
//  ViewController.swift
//  60.Day-Project16-CapitalCitites
//
//  Created by Sabir Myrzaev on 02.12.2021.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London",
                             coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
                             info: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo",
                           coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75),
                           info: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capital(title: "Paris",
                            coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508),
                            info: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome",
                           coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5),
                           info: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington, D.C.",
                                 coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667),
                                 info: "https://en.wikipedia.org/wiki/Washington,_D.C.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(mapType))
        
    }
    
    @objc func mapType() {
        let ac = UIAlertController(title: "Choose style map", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) { [weak self] _ in
            self?.mapView.mapType = .hybrid
        })
        ac.addAction(UIAlertAction(title: "MutedStandart", style: .default) { [weak self] _ in
            self?.mapView.mapType = .mutedStandard
        })
        ac.addAction(UIAlertAction(title: "Satellite", style: .default) { [weak self] _ in
            self?.mapView.mapType = .satellite
        })
        ac.addAction(UIAlertAction(title: "HybridFlyover", style: .default) { [weak self] _ in
            self?.mapView.mapType = .hybridFlyover
        })
        ac.addAction(UIAlertAction(title: "SatelliteFlyover", style: .default) { [weak self] _ in
            self?.mapView.mapType = .satelliteFlyover
        })
        ac.addAction(UIAlertAction(title: "Standard", style: .default) { [weak self] _ in
            self?.mapView.mapType = .standard
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.pinTintColor = .purple
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        if let vc = storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController {
            vc.detailItem = capital.info
            vc.title = capital.title
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

