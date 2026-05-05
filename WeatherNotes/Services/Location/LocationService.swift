//
//  LocationManager.swift
//  WeatherNotes
//
//  Created by Максим Грищенков on 04.05.2026.
//

import CoreLocation
import Foundation

enum LocationError: Error {
    case unauthorized
    case unableToFindLocation
}

final class LocationService: NSObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()
    private var locationContinuation:
        CheckedContinuation<CLLocationCoordinate2D, Error>?

    override init() {
        super.init()
        manager.delegate = self
    }

    func getCurrentLocation() async throws -> CLLocationCoordinate2D {
        if manager.authorizationStatus == .denied
            || manager.authorizationStatus == .restricted
        {
            throw LocationError.unauthorized
        }
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation

            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                manager.requestLocation()
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .denied, .restricted:
                locationContinuation?.resume(
                    throwing: LocationError.unauthorized
                )
                locationContinuation = nil
            @unknown default:
                locationContinuation?.resume(
                    throwing: LocationError.unableToFindLocation
                )
                locationContinuation = nil
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            locationContinuation?.resume(throwing: LocationError.unauthorized)
            locationContinuation = nil
        default:
            break
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }
        locationContinuation?.resume(returning: location.coordinate)
        locationContinuation = nil
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}
