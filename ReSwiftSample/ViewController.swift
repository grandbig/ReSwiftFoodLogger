//
//  ViewController.swift
//  ReSwiftSample
//
//  Created by Takahiro Kato on 2018/06/24.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import UIKit
import GoogleMaps
import ReSwift

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - Properties
    private var locationManager: CLLocationManager?
    private let zoomLevel: Float = 16.0
    private var currentLocation: CLLocationCoordinate2D?
    private var initView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // GoogleMapの初期化
        mapView.isMyLocationEnabled = true
        mapView.mapType = GMSMapViewType.normal
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.delegate = self
        
        // 位置情報関連の初期化
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        
        // subscribe to state changes
        mainStore.subscribe(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    @IBAction func tappedSearchButton(_ sender: Any) {
        mainStore.dispatch(MapState.fetchRestaurantsAction(lat: mapView.myLocation?.coordinate.latitude ?? 0,
                                                           lng: mapView.myLocation?.coordinate.longitude ?? 0))
    }
}

// MARK: - Other
extension ViewController {
    
    /// GoogleMapにマーカをプロットする
    ///
    /// - Parameter place: プロットする場所情報
    private func putMarker(place: Place) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.geometry.location.lat, longitude: place.geometry.location.lng)
        marker.icon = UIImage(named: "RestaurantIcon")
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
    }
}

// MARK: - StoreSubscriber
extension ViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
    func newState(state: AppState) {
        // when the state changes, the UI is updated to reflect the current state
        guard let error = state.mapState.error else {
            let places = state.mapState.places
            if places.count == 0 {
                mapView.clear()
                return
            }
            
            places.forEach { (place) in
                putMarker(place: place)
            }
            return
        }
        print("error: \(error.localizedDescription)")
    }
}

// MARK: - GMSMapViewDelegate
extension ViewController: GMSMapViewDelegate {
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .restricted, .denied:
            break
        case .authorizedWhenInUse:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 現在地の更新
        currentLocation = locations.last?.coordinate
        
        if !initView {
            // 初期描画時のマップ中心位置の移動
            let camera = GMSCameraPosition.camera(withTarget: currentLocation!, zoom: zoomLevel)
            mapView.camera = camera
            initView = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if !CLLocationManager.locationServicesEnabled() {
            // 端末の位置情報がOFFになっている場合
            // アラートはデフォルトで表示されるので内部で用意はしない
            self.currentLocation = nil
            return
        }
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse {
            // アプリの位置情報許可をOFFにしている場合
            return
        }
    }
}
