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
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.filterState.filterOption.rawValue
        return label
    }()
    
    //TODO: Docstrings
    lazy var valueOptionStack: UIStackView = {
        return self.createValueSelectionStack(numButtonsPerRow: self.numberButtonsPerRow)
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
    
    let numberButtonsPerRow: Int
    
    //TODO: Docstrings
    init(
        cancelWasPressed: @escaping () -> Void,
        doneWasPressed: @escaping ([any TAFilterValue]) -> Void,
        filterState: TAFilterState,
        numButtonsPerRow: Int
    )
    {
        self.cancelWasPressedCallback = cancelWasPressed
        self.doneWasPressedCallback = doneWasPressed
        self.filterState = filterState
        self.numberButtonsPerRow = numButtonsPerRow
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = 20
        self.addSubviewsAndEstablishConstraints()
    }
    
    //TODO: Docstrings
    private func createValueSelectionStack(numButtonsPerRow: Int) -> UIStackView {
        
        // The vertical stack contains all of the horizontal stacks
        let vertStack = UIStackView()
        vertStack.translatesAutoresizingMaskIntoConstraints = false
        vertStack.distribution = .fill
//        vertStack.backgroundColor = .cyan
        vertStack.spacing = 15
        vertStack.axis = .vertical
        vertStack.alignment = .fill
        
        var currentHorizontalStack = UIStackView()
        currentHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
        currentHorizontalStack.distribution = .fillEqually
        currentHorizontalStack.alignment = .center
//        currentHorizontalStack.backgroundColor = .red
        currentHorizontalStack.spacing = 15
        currentHorizontalStack.axis = .horizontal
        
        for possibleValue in self.filterState.possibleValues {
            let possibleValueButton = UIButton()
            print("ADDING BUTTON WITH VALUE \(possibleValue.stringRepresentation)")
            self.buttonToValueMap[possibleValueButton] = possibleValue
            self.buttonSelectedMap[possibleValueButton] = filterState.valueIsSelected(value: possibleValue)
            possibleValueButton.translatesAutoresizingMaskIntoConstraints = false
            possibleValueButton.setTitle(possibleValue.stringRepresentation, for: .normal)
            possibleValueButton.setTitleColor(.systemBackground, for: .normal)
            possibleValueButton.backgroundColor = .label
            possibleValueButton.layer.cornerRadius = 10
            
            possibleValueButton.addTarget(self, action: #selector(self.valueButtonClicked), for: .touchUpInside)
            currentHorizontalStack.addArrangedSubview(possibleValueButton)
            refreshButton(button: possibleValueButton)
            
            if currentHorizontalStack.arrangedSubviews.count >= numButtonsPerRow {
                vertStack.addArrangedSubview(currentHorizontalStack)
                currentHorizontalStack = UIStackView()
//                currentHorizontalStack.backgroundColor = .red

                currentHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
                currentHorizontalStack.distribution = .fillEqually
                currentHorizontalStack.spacing = 15
                currentHorizontalStack.axis = .horizontal
                print("ADDING NEW HORIZ STACK")
            }
        }
        
        vertStack.addArrangedSubview(currentHorizontalStack)

        
        return vertStack
    }
    
    //TODO: Docstrings
    @objc private func valueButtonClicked(sender: UIButton) {
        printDebug("Value button with title label \(String(describing: sender.titleLabel?.text)) was clicked")
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
                printError("tried to retrieve value from button but it was not mapped correctly.")
            }
        }
        
        self.filterState.removeAllSelectedValues()
        self.filterState.addSelectedValues(values: selectedValues)
        self.doneWasPressedCallback(selectedValues)
    }
    
    //TODO: Docstrings
    private func addSubviewsAndEstablishConstraints() {
        self.addArrangedSubview(self.titleLabel)
        self.addArrangedSubview(self.valueOptionStack)
        self.addArrangedSubview(self.buttonsStack)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TAFilterSelectionView: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (TAFilterSelectionView): \(message)")
        }
    }
}
