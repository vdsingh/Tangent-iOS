//
//  File.swift
//  Tangent
//
//  Created by Vikram Singh on 4/20/23.
//

import Foundation
import UIKit

class TAFiltersView: UIStackView {
    
    
    init() {
        self.setUIProperties()
    }
    
    private func setUIProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
    }
}
