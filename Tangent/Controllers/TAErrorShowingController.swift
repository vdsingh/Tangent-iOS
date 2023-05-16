//
//  TAErrorShowingController.swift
//  Tangent
//
//  Created by Vikram Singh on 5/15/23.
//

import Foundation
import UIKit

/// Protocol for ViewControllers that show errors
protocol TAErrorShowingController: UIViewController {
    func showErrorPopup(title: String, message: String)
}
