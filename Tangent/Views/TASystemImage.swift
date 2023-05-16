//
//  TAImage.swift
//  Tangent
//
//  Created by Vikram Singh on 4/18/23.
//

import Foundation
import UIKit

/// Represents a System Image
enum TASystemImage: String {
    
    case airport = "airplane"
    case amusementPark = "flag.2.crossed.fill"
    case aquarium = "fish.fill"
    case atm = "dollarsign"
    case bakery = "birthday.cake.fill"
    case bank = "b.circle.fill"
    case beach = "beach.umbrella.fill"
    case brewery = "takeoutbag.and.cup.and.straw.fill"
    case cafe = "mug.fill"
    case campground = "tent.fill"
    case carRental = "car.side.fill"
    case evCharger = "bolt.car.fill"
    case fireStation = "flame.fill"
    case fitnessCenter = "dumbbell.fill"
    case foodMarket = "carrot.fill"
    case gasStation = "fuelpump.fill"
    case hospital = "cross.case.fill"
    case hotel = "house.lodge.fill"
    case laundry = "tshirt.fill"
    case library = "books.vertical.fill"
    case marina = "sailboat.fill"
    case movieTheater = "popcorn.fill"
    case museum = "photo.artframe"
    case nationalPark = "tree.fill"
    case nightlife = "figure.socialdance"
    case park = "camera.macro"
    case parking = "parkingsign"
    case pharmacy = "pills.fill"
    case police = "person.bust"
    case postOffice = "envelope.fill"
    case publicTransport = "bus"
    case restaurant = "fork.knife"
    case restroom = "toilet.fill"
    case school = "book.closed.fill"
    case stadium = "sportscourt.fill"
    case store = "cart.fill"
    case theater = "theatermasks.fill"
    case university = "graduationcap.fill"
    case winery = "wineglass.fill"
    case zoo = "tortoise.fill"
    case location = "pin.fill"
    case questionMark = "questionMark.square.fill"
    case starFill = "star.fill"
    
    /// Constructs the associated UIImage
    var uiImage: UIImage {
        if let image = UIImage(systemName: self.rawValue) {
            return image
        }
        
        return UIImage.actions
    }
}
