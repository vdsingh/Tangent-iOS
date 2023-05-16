//
//  TAPointAnnotation.swift
//  Tangent
//
//  Created by Vikram Singh on 4/16/23.
//

import Foundation
import UIKit
import MapKit


/// Represents an Annotation (AKA: Map Pin) type
enum TAAnnotationType {
    case finalDestination
    case tangent
    
    /// The color associated with the type
    var color: UIColor {
        switch self {
        case .finalDestination:
            return .blue
        case .tangent:
            return .red
        }
    }
}

/// Custom type of MKPointAnnotation
class TAPointAnnotation: MKPointAnnotation {
    
    /// The Annotation Type
    let annotationType: TAAnnotationType
    
    
    /// Initializer
    /// - Parameter annotationType: The Annotation type associated with the Annotation
    init(annotationType: TAAnnotationType) {
        self.annotationType = annotationType
    }
}
