//
//  Mocking.swift
//  Tangent
//
//  Created by Vikram Singh on 4/12/23.
//

import Foundation
import MapKit

//TODO: Docstrings
class Mocking {
    
    let debug = true
    
    static let shared = Mocking()
    
    private init() { }
    
    // MARK: - Public Functions
    
    
    func generateMockBusinesses(count: Int) -> [TABusiness] {
        printDebug("Generating Mock Businesses")
        var businesses = [TABusiness]()
        for _ in 0..<count {
            let coordinate = generateRandomCoordinates()
            let business = TABusiness(
                id: UUID().uuidString,
                name: self.generateRandomBusinessName(),
                rating: Float.random(in: 0...5),
                reviewCount: Int.random(in: 0...1000),
                latitude: Float(coordinate.latitude),
                longitude: Float(coordinate.longitude),
                price: TAPrice.allCases.randomElement() ?? .one
            )
            businesses.append(business)
        }
        
        return businesses
    }
    
    // MARK: - Private Functions
    
    private func generateRandomBusinessName() -> String {
        let businessNames = ["Bright Horizon Solutions"," Coastal Vista Realty"," Silver Lining Accounting"," Phoenix Rising Fitness"," Green Leaf Wellness"," Swiftly Tech"," Sapphire Marketing Group"," Blue Ocean Consultancy"," Pure Bliss Bakery"," Titan Ventures"," Mystic Mountain Resorts"," Amber Alert Security"," Sunrise Cafe"," Emerald Island Properties"," Liberty Legal Services"," Bluebird Books"," Sea Spray Studios"," Sunny Side Up Cleaning"," Paradise Pet Resort"," Sparkle Shine Auto Detailing"," Crimson Communications"," Arctic Air HVAC"," Golden Gate Investments"," Moonstone Music"," Happy Tails Animal Hospital"," Oasis Health Foods"," Skyline Architecture"," Crystal Clear Window Cleaning"," Forest Grove Landscaping"," Summit Solutions Consulting"," Starlight Entertainment"," Atlantic Coast Plumbing"," Rustic Retreat Cabin Rentals"," Peak Performance Physical Therapy"," Ocean Breeze Car Wash"," Sunrise Accounting Services"," Mountain View Dentistry"," Emerald City Jewelry"," Crimson Tide Productions"," Desert Oasis Spa"," Blue Ridge Technologies"," Sky High Adventure Tours"," Royal Flush Plumbing"," Diamond Peak Investments"," Coastal Dreams Realty"," Golden Key Insurance Agency"," Paradise Found Travel Agency"," Elite Edge Fitness"]
        return businessNames.randomElement() ?? "McDonald's"
    }
    
    private func generateRandomCoordinates() -> CLLocationCoordinate2D {
        if let lastUserLocation = TAUserLocationService.shared.getLastUserLocation() {
            let randomLat = Float.random(in: Float(lastUserLocation.latitude-1)...Float(lastUserLocation.latitude+1))
            let randomLon = Float.random(in: Float(lastUserLocation.longitude-1)...Float(lastUserLocation.longitude+1))

            let coordinate = CLLocationCoordinate2D(latitude: Double(randomLat), longitude: Double(randomLon))
            return coordinate
        }
        
        printError("Couldn't access user location to generate mock business location")
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    
}

extension Mocking: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (Mocking): \(message)")
        }
    }
}
