//
//  TAPointAnnotation.swift
//  Tangent
//
//  Created by Vikram Singh on 4/16/23.
//

import Foundation
import UIKit
import MapKit

//TODO: Docstring
enum TAAnnotationType {
    case finalDestination
    case tangent
    
    var color: UIColor {
        switch self {
        case .finalDestination:
            return .blue
        case .tangent:
            return .red
        }
    }
}

//TODO: Docstring
class TAPointAnnotation: MKPointAnnotation {
    let annotationType: TAAnnotationType
    
    init(annotationType: TAAnnotationType) {
        self.annotationType = annotationType
    }
}
