//
//  File.swift
//  Tangent
//
//  Created by Vikram Singh on 4/20/23.
//

import Foundation
import UIKit

//TODO: Docstrings, separate
class TAFilterButtonsView: UIStackView, Debuggable {
    
    let debug = true
    
    //TODO: Docstrings
    let controller: UIViewController
    
    //TODO: Docstrings
    var filterViewDictionary = [TAFilterOption: TAFilterButtonView]()
    
    //TODO: Docstrings
    init(filterStates: [TAFilterState], controller: UIViewController) {
        self.controller = controller
        super.init(frame: .zero)
        self.setUIProperties()
        
        self.createAndAddFilterViews(filterStates: filterStates)
        self.addSubviewsAndEstablishConstraints()
    }
    
    //TODO: Docstrings
    func refreshView(filterState: TAFilterState) {
        printDebug("Refreshing Filters View")
        //        for filterOption in filterData.keys {
        if let view = self.filterViewDictionary[filterState.filterOption] {
            view.refreshView()
        }
    }
    
    //TODO: Docstrings
    private func createAndAddFilterViews(filterStates: [TAFilterState]) {
        for filterState in filterStates {
            let view = TAFilterButtonView(filterState: filterState, controller: self.controller)
            self.filterViewDictionary[filterState.filterOption] = view
            self.addArrangedSubview(view)
        }
    }
    
    //TODO: Docstrings
    private func setUIProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.spacing = 10
    }
    
    //TODO: Docstrings
    private func addSubviewsAndEstablishConstraints() {

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
