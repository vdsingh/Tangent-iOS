//
//  TAFilterButtonsView.swift
//  Tangent
//
//  Created by Vikram Singh on 4/20/23.
//

import Foundation
import UIKit

/// View that displays multiple FilterButtons
class TAFilterButtonsView: UIStackView {
    
    let debug = true
    
    /// The ViewController that is displaying this View
    let controller: UIViewController
    
    /// Maps the relationship between a filter option and a filter button view
    var filterViewMap = [TAFilterOption: TAFilterButtonView]()
    
    /// Initializer
    /// - Parameters:
    ///   - filterStates: The FilterStates that we want to show
    ///   - controller: The controller that is displaying this View
    init(filterStates: [TAFilterState], controller: UIViewController) {
        self.controller = controller
        super.init(frame: .zero)
        self.setUIProperties()
        
        self.createAndAddFilterViews(filterStates: filterStates)
    }
    
    /// Refreshes the View that is associated with a FilterState
    /// - Parameter filterState: The FilterState that we want to refresh the View for
    func refreshView(filterState: TAFilterState) {
        printDebug("Refreshing Filters View")
        if let view = self.filterViewMap[filterState.filterOption] {
            view.refreshView()
        }
    }
    
    /// Creates FilterButton Views and adds them
    /// - Parameter filterStates: The FilterStates that we want to create FilterButtons for
    private func createAndAddFilterViews(filterStates: [TAFilterState]) {
        for filterState in filterStates {
            let view = TAFilterButtonView(filterState: filterState, controller: self.controller)
            self.filterViewMap[filterState.filterOption] = view
            self.addArrangedSubview(view)
        }
    }
    
    /// Sets the UI Properties for the View
    private func setUIProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.spacing = 10
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}

extension TAFilterButtonsView: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (TAFiltersView): \(message)")
        }
    }
}
