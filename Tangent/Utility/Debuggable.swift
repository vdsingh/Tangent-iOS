//
//  Debuggable.swift
//  Tangent
//
//  Created by Vikram Singh on 3/25/23.
//

import Foundation

/// Protocol for types that should be debuggable.
protocol Debuggable {

    /// Whether we are currently debugging the current class
    var debug: Bool { get }

    /// Prints a debug message if debug or relevant flags are true
    /// - Parameter message: The message to print
    func printDebug(_ message: String)
}
