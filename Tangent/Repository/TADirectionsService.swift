//
//  TADirectionsService.swift
//  Tangent
//
//  Created by Vikram Singh on 4/15/23.
//

import Foundation
import MapKit


/// Interface with Directions
final class TADirectionsService {
    static let shared = TADirectionsService()
    
    private init() { }
    
    
    /// Errors associated with TADirectionsService
    enum TADirectionsServiceError: Error {
        case responseWasNil
    }
    
    
    /// Gets the directions from a source coordinate to a destination coordinate
    /// - Parameters:
    ///   - source: The start point for the directions
    ///   - destination: The end point for the directions
    ///   - completion: Handle what happens after a response has been received
    func getDirections(
        source: CLLocationCoordinate2D,
        destination: CLLocationCoordinate2D,
        completion: @escaping (Result<MKRoute, Error>) -> Void
    ) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate {response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let unwrappedResponse = response else {
                completion(.failure(TADirectionsServiceError.responseWasNil))
                return
            }
            
            // just get one route
            if let route = unwrappedResponse.routes.first {
                completion(.success(route))
            }
        }
    }
}
