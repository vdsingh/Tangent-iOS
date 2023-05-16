//
//  TAFiltersService.swift
//  Tangent
//
//  Created by Vikram Singh on 4/24/23.
//

import Foundation


/// Interface with Filters
final class TAFiltersService: NSObject {
    
    let debug = false
    
    static let shared = TAFiltersService()
    
    /// Maps the relation between a FilterOption and a FilterState
    private lazy var selectedFiltersMap: [TAFilterOption: TAFilterState] = {
        var map = [TAFilterOption: TAFilterState]()
        for option in TAFilterOption.allCases {
            let state = TAFilterState(filterOption: option)
            map[option] = state
        }
        return map
    }()
    
    
    private override init() { }
    
    /// Gets the filter state for a given Filter Option
    /// - Parameter option: The FilterOption which corresponds to the desired FilterState
    /// - Returns: The desired FilterState
    public func getFilterState(for option: TAFilterOption) -> TAFilterState {
        if let state = self.selectedFiltersMap[option] {
            return state
        }
        
        fatalError("tried to get filter state for option \(option) but it wasn't in the map.")
    }
    
    /// Gets all of the FilterStates
    /// - Returns: all of the FilterStates
    public func getAllFilterStates() -> [TAFilterState] {
        return [TAFilterState](self.selectedFiltersMap.values)
    }
}

extension TAFiltersService: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (TAFiltersService): \(message)")
        }
    }
}
