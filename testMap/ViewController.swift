//
//  ViewController.swift
//  testMap
//
//  Created by Эмир Кармышев on 23/3/22.
//

import UIKit
import GoogleMaps
import SnapKit

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: 49.32334, longitude: 8.55194, zoom: 10)
        return GMSMapView(frame: .zero, camera: camera)
    }()
    private lazy var zoomButtonPlus: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "plus"), for: .normal)
        view.addTarget(self, action: #selector(zoomPlus(view:)), for: .touchUpInside)
        return view
    }()
    private lazy var zoomButtonMinus: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "minus"), for: .normal)
        view.addTarget(self, action: #selector(zoomMinus(view:)), for: .touchUpInside)
        return view
    }()
    private lazy var locationManager: CLLocationManager = {
        let view = CLLocationManager()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let position = CLLocationCoordinate2D(latitude: 49.32334, longitude: 8.55194)
        let marker = GMSMarker(position: position)
        marker.title = "Hockenheim"
        marker.snippet = "Germany"
        marker.map = mapView
        
        mapView.addSubview(zoomButtonPlus)
        zoomButtonPlus.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(50)
        }
        mapView.addSubview(zoomButtonMinus)
        zoomButtonMinus.snp.makeConstraints { make in
            make.right.equalTo(zoomButtonPlus.snp.left).offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(50)
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    @objc func zoomPlus(view: UIButton) {
        mapView.animate(toZoom: mapView.camera.zoom + 0.5)
       
    }
    @objc func zoomMinus(view: UIButton) {
        mapView.animate(toZoom: mapView.camera.zoom - 0.5)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0), zoom: 10, bearing: 0, viewingAngle: 0.0)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
        marker.title = "test"
        marker.snippet = "tetetetet"
        marker.map = mapView
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            return
        case .authorizedWhenInUse:
            return
        case .denied:
            return
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
}



