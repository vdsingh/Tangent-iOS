//
//  TAFilterViewController.swift
//  Tangent
//
//  Created by Vikram Singh on 4/22/23.
//

import Foundation
import UIKit

//TODO: Docstring
final class TAFilterViewController: UIViewController {
    
    //TODO: Docstring
    let filterState: TAFilterState
    
    //TODO: Docstring
    lazy var filterView: TAFilterSelectionView = {
        return TAFilterSelectionView(
            cancelWasPressed: { [weak self] in
                self?.dismiss(animated: true)
            },
            doneWasPressed: { [weak self] selectedPrices in
                guard let self = self else { return }
                TAFiltersService.shared.getFilterState(for: self.filterState.filterOption).addSelectedValues(values: selectedPrices)
                self.dismiss(animated: true)
            },
            filterState: self.filterState
        )
    }()
    
    //TODO: Docstring
    init(filterState: TAFilterState) {
        self.filterState = filterState
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        self.view.addSubview(self.filterView)
        NSLayoutConstraint.activate([
            self.filterView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            self.filterView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.filterView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),

        ])
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.filterView.updateAllButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
