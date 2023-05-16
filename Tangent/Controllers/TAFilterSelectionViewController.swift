//
//  TAFilterViewController.swift
//  Tangent
//
//  Created by Vikram Singh on 4/22/23.
//

import Foundation
import UIKit

/// ViewController for the View that allows users to select filter options
final class TAFilterSelectionViewController: UIViewController {
    
    /// The FilterState associated with the Filter info that we're displaying
    let filterState: TAFilterState
    
    /// View that allows users to select filter options
    lazy var filterSelectionView: TAFilterSelectionView = {
        return TAFilterSelectionView(
            cancelWasPressed: { [weak self] in
                self?.dismiss(animated: true)
            },
            doneWasPressed: { [weak self] selectedPrices in
                guard let self = self else { return }
                TAFiltersService.shared.getFilterState(for: self.filterState.filterOption).addSelectedValues(values: selectedPrices)
                self.dismiss(animated: true)
            },
            filterState: self.filterState,
            numButtonsPerRow: self.numberButtonsPerRow
        )
    }()
    
    /// The number of buttons in each row in the selection view
    var numberButtonsPerRow: Int {
        switch self.filterState.filterOption {
        case .price:
            return 4
        case .businessType:
            return 3
        }
    }
    
    /// Initializer
    /// - Parameter filterState: The State associated with the FilterView
    init(filterState: TAFilterState) {
        self.filterState = filterState
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        self.view.addSubview(self.filterSelectionView)
        NSLayoutConstraint.activate([
            self.filterSelectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            self.filterSelectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.filterSelectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),

        ])
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.filterSelectionView.updateAllButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
