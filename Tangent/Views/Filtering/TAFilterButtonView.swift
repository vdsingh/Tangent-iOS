//
//  TAFilterView.swift
//  Tangent
//
//  Created by Vikram Singh on 4/25/23.
//

import Foundation
import UIKit

/// View to enable users to interact with Filter Options
class TAFilterButtonView: UIView {
    
    let debug = true
    
    /// The ViewController that shows this View
    let controller: UIViewController
    
    /// The state associated with the filter
    let filterState: TAFilterState
    
    /// The button to expand the filter options
    let filterButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .systemBackground
        return button
    }()
    
    
    /// Initializer
    /// - Parameters:
    ///   - filterState: The TAFilterState associated with the filter
    ///   - controller: The UIVIewController displaying the FilterButton
    init(filterState: TAFilterState, controller: UIViewController) {
        self.controller = controller
        self.filterState = filterState
        super.init(frame: .zero)
        self.setUIProperties()
        self.addSubviewsAndEstablishConstraints()
    }
    
    /// Sets the UI Properties for the View
    private func setUIProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.filterButton.setTitle("   \(self.filterState.displayString)   ", for: .normal)
        self.filterButton.addTarget(self, action: #selector(showFilterOptionPopUp), for: .touchUpInside)
    }
    
    /// Shows a popup that allows users to select filter options
    @objc private func showFilterOptionPopUp() {
        let selectionVC = TAFilterSelectionViewController(filterState: self.filterState)
        selectionVC.view.backgroundColor = .systemBackground
        let nav = UINavigationController(rootViewController: selectionVC)

        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
        }

        self.controller.present(nav, animated: true)
    }
    
    /// Adds the necessary subviews and establishes constraints
    private func addSubviewsAndEstablishConstraints() {
        self.addSubview(self.filterButton)
        
        NSLayoutConstraint.activate([
            self.filterButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.filterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.filterButton.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.filterButton.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
    
    /// Refreshes the View
    func refreshView() {
        self.printDebug("Refreshing Filter View for option \(self.filterState.filterOption)")
        self.setUIProperties()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}

extension TAFilterButtonView: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (TAFilterView): \(message)")
        }
    }
}
