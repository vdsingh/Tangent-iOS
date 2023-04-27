//
//  TAPriceSelectionView.swift
//  Tangent
//
//  Created by Vikram Singh on 4/22/23.
//

import Foundation
import UIKit

//TODO: Docstrings
final class TAFilterSelectionView: UIStackView {
    
    let debug = true
    
    //TODO: Docstrings
    let titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Price"
        return label
    }()
    
    //TODO: Docstrings
    lazy var priceOptionStack: UIStackView = {
        return self.createPriceSelectionStack()
    }()
    
    //TODO: Docstrings
    lazy var buttonsStack: UIStackView = {
        let doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = .link
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.layer.cornerRadius = 30
        doneButton.addTarget(self, action: #selector(self.doneWasPressed), for: .touchUpInside)
        
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .systemBackground
        cancelButton.setTitleColor(.link, for: .normal)
        cancelButton.layer.cornerRadius = 30
        cancelButton.layer.borderColor = UIColor.gray.cgColor
        cancelButton.layer.borderWidth = 2
        cancelButton.addTarget(self, action: #selector(cancelWasPressed), for: .touchUpInside)
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        stack.addArrangedSubview(cancelButton)
        stack.addArrangedSubview(doneButton)
        
        NSLayoutConstraint.activate([
            stack.heightAnchor.constraint(equalToConstant: 60)
        ])

        return stack
    }()
    
    //TODO: Docstrings
    let cancelWasPressedCallback: () -> Void
    
    //TODO: Docstrings
    let doneWasPressedCallback: ([any TAFilterValue]) -> Void
    
    //TODO: Docstrings
    let filterState: TAFilterState
    
    //TODO: Docstrings
    var buttonToValueMap = [UIButton: any TAFilterValue]()
    
    //TODO: Docstrings
    var buttonSelectedMap = [UIButton: Bool]()
    
    //TODO: Docstrings
    init(
        cancelWasPressed: @escaping () -> Void,
        doneWasPressed: @escaping ([any TAFilterValue]) -> Void,
        filterState: TAFilterState
    )
    {
        self.cancelWasPressedCallback = cancelWasPressed
        self.doneWasPressedCallback = doneWasPressed
        self.filterState = filterState
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = 20
        self.addSubviewsAndEstablishConstraints()
    }
    
    //TODO: Docstrings
    private func createPriceSelectionStack() -> UIStackView {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 15
        stack.axis = .horizontal
        stack.alignment = .top
        stack.translatesAutoresizingMaskIntoConstraints = false
        for possibleValue in self.filterState.possibleValues {
            let possibleValueButton = UIButton()
            self.buttonToValueMap[possibleValueButton] = possibleValue
            self.buttonSelectedMap[possibleValueButton] = filterState.valueIsSelected(value: possibleValue)
            possibleValueButton.translatesAutoresizingMaskIntoConstraints = false
            possibleValueButton.setTitle(possibleValue.stringRepresentation, for: .normal)
            possibleValueButton.setTitleColor(.systemBackground, for: .normal)
            possibleValueButton.backgroundColor = .label
            possibleValueButton.layer.cornerRadius = 10
            
            
            possibleValueButton.addTarget(self, action: #selector(self.priceButtonClicked), for: .touchUpInside)
            stack.addArrangedSubview(possibleValueButton)
            refreshButton(button: possibleValueButton)
        }
        
        return stack
    }
    
    //TODO: Docstrings
    @objc private func priceButtonClicked(sender: UIButton) {
        printDebug("Price button with title label \(String(describing: sender.titleLabel?.text)) was clicked")
        if let isSelected = self.buttonSelectedMap[sender] {
            self.buttonSelectedMap[sender] = !isSelected
            printDebug("Set button \(String(describing: sender.titleLabel?.text)) selected status to \(!isSelected)")
            self.refreshButton(button: sender)
        } else {
            printError("Tried to set button selection status but it was not mapped")
        }
    }
    
    //TODO: Docstrings
    private func refreshButton(button: UIButton) {
        if let isSelected = self.buttonSelectedMap[button] {
            if isSelected {
                button.setTitleColor(.tintColor, for: .normal)
            } else {
                button.setTitleColor(.systemBackground, for: .normal)
            }
        }
    }
    
    //TODO: Docstrings
    public func updateAllButtons() {
        for button in self.buttonToValueMap.keys {
            printDebug("Updating button with title \(String(describing: button.titleLabel?.text))")
            self.refreshButton(button: button)
        }
    }
    
    //TODO: Docstrings
    @objc private func cancelWasPressed(sender: UIButton) {
        self.cancelWasPressedCallback()
    }
    
    //TODO: Docstrings
    @objc private func doneWasPressed(sender: UIButton) {
        printDebug("Done Button was pressed")
        var selectedValues = [any TAFilterValue]()
        for button in self.buttonToValueMap.keys {
            if let value = self.buttonToValueMap[button] {
                if let isSelected = self.buttonSelectedMap[button] {
                    if isSelected {
                        selectedValues.append(value)
                    }
                } else {
                    printError("tried to retrieve selected status for button but it was not mapped correctly.")
                }
            } else {
                printError("tried to retrieve price from button but it was not mapped correctly.")
            }
        }
        
        self.filterState.removeAllSelectedValues()
        self.filterState.addSelectedValues(values: selectedValues)
        self.doneWasPressedCallback(selectedValues)
    }
    
    //TODO: Docstrings
    private func addSubviewsAndEstablishConstraints() {
        self.addArrangedSubview(self.titleLabel)
        self.addArrangedSubview(self.priceOptionStack)
        self.addArrangedSubview(self.buttonsStack)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TAFilterSelectionView: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (TAPriceSelectionView): \(message)")
        }
    }
}
