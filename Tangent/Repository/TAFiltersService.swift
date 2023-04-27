//
//  TAFiltersService.swift
//  Tangent
//
//  Created by Vikram Singh on 4/24/23.
//

import Foundation


final class TAFiltersService: NSObject {
    let debug = false
    
    //TODO: Docstring
    static let shared = TAFiltersService()
    
    //TODO: Docstring
    private lazy var selectedFiltersMap: [TAFilterOption: TAFilterState] = {
        var map = [TAFilterOption: TAFilterState]()
        for option in TAFilterOption.allCases {
            let state = TAFilterState(filterOption: option)
            map[option] = state
        }
        return map
    }()
    
    
    private override init() { }
    
    //TODO: Docstring
    public func getFilterState(for option: TAFilterOption) -> TAFilterState {
        if let state = self.selectedFiltersMap[option] {
            return state
        }
        
        fatalError("tried to get filter state for option \(option) but it wasn't in the map.")
    }
    
    //TODO: Docstring
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
