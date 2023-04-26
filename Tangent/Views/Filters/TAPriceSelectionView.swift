//
//  TAPriceSelectionView.swift
//  Tangent
//
//  Created by Vikram Singh on 4/22/23.
//

import Foundation
import UIKit

//TODO: Docstrings

final class TAPriceSelectionView: UIStackView, Debuggable {
    
    let debug = true
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Price"
        return label
    }()
    
    lazy var priceOptionStack: UIStackView = {
        return self.createPriceSelectionStack()
    }()
    
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
    
    let cancelWasPressedCallback: () -> Void
    let doneWasPressedCallback: ([any TAFilterValue]) -> Void
    
    let filterState: TAFilterState
    
    var buttonMap = [UIButton: any TAFilterValue]()
    
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
    
    private func createPriceSelectionStack() -> UIStackView {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 15
        stack.axis = .horizontal
        stack.alignment = .top
        stack.translatesAutoresizingMaskIntoConstraints = false
        for possibleValue in self.filterState.possibleValues {
            let possibleValueButton = UIButton()
            self.buttonMap[possibleValueButton] = possibleValue
//            possibleValueButton.tag = filterState.valueIsSelected(value: possibleValue) ? 1 : 0
            possibleValueButton.translatesAutoresizingMaskIntoConstraints = false
            possibleValueButton.setTitle(possibleValue.stringRepresentation, for: .normal)
            possibleValueButton.setTitleColor(.systemBackground, for: .normal)
            possibleValueButton.backgroundColor = .label
            possibleValueButton.layer.cornerRadius = 10
            
            
            possibleValueButton.addTarget(self, action: #selector(self.priceButtonClicked), for: .touchUpInside)
            stack.addArrangedSubview(possibleValueButton)
            refreshButton(button: possibleValueButton, value: possibleValue)
        }
        
        return stack
    }
    
    @objc private func priceButtonClicked(sender: UIButton) {
        printDebug("Price button with title label \(String(describing: sender.titleLabel?.text)) was clicked")
        if let value = buttonMap[sender] {
            if self.filterState.valueIsSelected(value: value) {
                self.filterState.removeSelectedValue(value: value)
            } else {
                self.filterState.addSelectedValue(value: value)
            }
            self.refreshButton(button: sender, value: value)
        } else {
            printError("Price button clicked but was not mapped to a value")
        }
        
    }
    
    private func refreshButton(button: UIButton, value: any TAFilterValue) {
        if self.filterState.valueIsSelected(value: value) {
            button.setTitleColor(.tintColor, for: .normal)
        } else {
            button.setTitleColor(.systemBackground, for: .normal)
        }
    }
    
    public func updateAllButtons() {
        for button in self.buttonMap.keys {
            printDebug("Updating button with title \(String(describing: button.titleLabel?.text))")
            if let value = self.buttonMap[button] {
                self.refreshButton(button: button, value: value)
            } else {
                printError("Button was not mapped to a value")
            }
        }
    }
    
    @objc private func cancelWasPressed(sender: UIButton) {
        self.cancelWasPressedCallback()
    }
    
    @objc private func doneWasPressed(sender: UIButton) {
        printDebug("Done Button was pressed")
        var selectedValues = [any TAFilterValue]()
        for button in self.buttonMap.keys {
            if button.tag != 0 {
                if let value = self.buttonMap[button] {
                    selectedValues.append(value)
                } else {
                    printError("tried to retrieve price from button but it was not mapped correctly.")
                }
            }
        }

        self.doneWasPressedCallback(selectedValues)
    }
    
    private func addSubviewsAndEstablishConstraints() {
        self.addArrangedSubview(self.titleLabel)
        self.addArrangedSubview(self.priceOptionStack)
        self.addArrangedSubview(self.buttonsStack)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (TAPriceSelectionView): \(message)")
        }
    }
}
