//
//  TAFilterState.swift
//  Tangent
//
//  Created by Vikram Singh on 4/25/23.
//

import Foundation

//TODO: Docstring

class TAFilterState: NSObject {
    
    let filterOption: TAFilterOption
    
    lazy var valueSelectionMap: RequiredObservable<[TAFilterValueWrapper: Bool]> = {
        var map = [TAFilterValueWrapper: Bool]()
        for value in self.filterOption.allPossibleValues {
            let valueWrapper = TAFilterValueWrapper(value: value)
            map[valueWrapper] = false
        }

        return RequiredObservable(map, label: "Value selection map for TAFilterState with option \(self.filterOption)")
    }()
    
    
    var selectedValues: [any TAFilterValue] {
        var selectedValues = [any TAFilterValue]()
        for valueWrapper in self.valueSelectionMap.value.keys {
            if let isSelected = self.valueSelectionMap.value[valueWrapper],
               isSelected {
                selectedValues.append(valueWrapper.value)
//                selectedValues.append(value)
            }
        }
        
        return selectedValues.sorted(by: { $0.stringRepresentation.count < $1.stringRepresentation.count })
    }
    
    var possibleValues: [any TAFilterValue] {
//        return [any TAFilterValue](self.valueSelectionMap.keys)
        return self.valueSelectionMap.value.keys.compactMap({ $0.value }).sorted(by: { $0.stringRepresentation.count < $1.stringRepresentation.count })
    }
    
    var displayString: String {
        let selectedValues = self.selectedValues
        if selectedValues.isEmpty {
            return filterOption.rawValue
        }
        
        return selectedValues.compactMap({$0.stringRepresentation}).sorted().joined(separator: ", ")
    }
    
    init(filterOption: TAFilterOption) {
        self.filterOption = filterOption
    }
    
    func valueIsPossible(value: any TAFilterValue) -> Bool {
        return self.possibleValues.contains(where: { possibleValue in
            return possibleValue.stringRepresentation == value.stringRepresentation
        })
    }
    
    func addSelectedValue(value: any TAFilterValue) {
        if self.valueIsPossible(value: value)
//           !self.valueIsSelected(value: value)
        {
            let valueWrapper = TAFilterValueWrapper(value: value)
            self.valueSelectionMap.value[valueWrapper] = true
//            self.selectedValues.value.append(value)
//            self.valueSelectionMap[value] = true
        } else {
            
            printError("Tried to add selected value \(value) to Filter State of type \(self.filterOption), however that value is not possible. The possible values are: \(self.possibleValues)")
        }
    }
    
    func valueIsSelected(value: any TAFilterValue) -> Bool {
//        return self.selectedValues.value.first(where: { $0.stringRepresentation == value.stringRepresentation }) == nil
        
//        if let value = self.valueSelectionMap[value] {
//            return value
//        }
        return self.selectedValues.contains(where: { $0.stringRepresentation == value.stringRepresentation })
        
//        return false
    }
    
    func addSelectedValues(values: [any TAFilterValue]) {
        for value in values {
//            self.addSelectedValue(value: value)
//            let valueWrapper = TAFilterValueWrapper(value: value)
            self.addSelectedValue(value: value)
//            if let valueState = self.getValueStateForValue(value: value) {
//                valueState.isSelected.value = true
//            }

        }
//        let valueState = self.getValueStateForValue(value: value)
    }
    
    func removeSelectedValue(value: any TAFilterValue) {
//        self.possibleValues.removeAll(where: { $0.stringRepresentation == value.stringRepresentation})
//        self.valueSelectionMap[value] = false
        let valueWrapper = TAFilterValueWrapper(value: value)
        self.valueSelectionMap.value[valueWrapper] = false
//        if let isSelected = self.valueSelectionMap[valueWrapper] {
//            valueState.isSelected.value = false
//        }
    }
    
    func removeAllSelectedValues() {
        for value in self.selectedValues {
            self.removeSelectedValue(value: value)
        }
    }
    
//    func getValueStateForValue(value: any TAFilterValue) -> TAFilterValueState? {
//        return self.valueStates.first(where: { $0.value.stringRepresentation == value.stringRepresentation }) ?? nil
//    }
    
}

class TAFilterValueWrapper: Hashable {

    let value: any TAFilterValue
    
//    var isSelected = RequiredObservable(false, label: "isSelected property for TAFilterValueState")
    
    init(value: any TAFilterValue) {
        self.value = value
    }
    
    static func == (lhs: TAFilterValueWrapper, rhs: TAFilterValueWrapper) -> Bool {
        return lhs.value.stringRepresentation == rhs.value.stringRepresentation
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.value)
    }
}
