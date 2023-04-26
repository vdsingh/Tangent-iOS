//
//  Observable.swift
//  Tangent
//
//  Created by Vikram Singh on 4/25/23.
//

import Foundation

// TODO: Docstrings
class Observable<T>: Debuggable {

    let debug = false

    //TODO: Docstring
    let label: String

    //TODO: Docstring
    var value: T? {
        didSet {
            self.didSetValue()
        }
    }

    //TODO: Docstring
    init(_ value: T?, label: String) {
        self.value = value
        self.label = label
        printDebug("initialized Observable with label: [\(label)]. value: [\(String(describing: value))]")
        self.didSetValue()
    }

    //TODO: Docstring
    private var listener: ((T?) -> Void)?

    //TODO: Docstring
    private func didSetValue() {
        printDebug("value of observable [\(label)] was changed to [\(String(describing: value))]")
        self.listener?(self.value)
    }

    //TODO: Docstring
    func bind(_ listener: @escaping (T?) -> Void) {
        printDebug("binded Observable with label [\(label)]")
        listener(self.value)
        self.listener = listener
    }

    func printDebug(_ message: String) {
        if self.debug {
            print("$Log (Observable): \(message)")
        }
    }
}


// TODO: Docstrings
class RequiredObservable<T>: Debuggable {
    let debug = true

    let label: String

    var value: T {
        didSet {
            self.didSetValue()
        }
    }

    init(_ value: T, label: String) {
        self.value = value
        self.label = label
        printDebug("initialized Observable with label: [\(label)]. value: [\(value)]")
        self.didSetValue()
    }

    private var listener: ((T) -> Void)?

    private func didSetValue() {
        printDebug("value of observable [\(label)] was changed to [\(String(describing: value))]")
        self.listener?(self.value)
    }

    func bind(_ listener: @escaping (T) -> Void) {
        printDebug("binded Observable with label [\(label)]")
        listener(self.value)
        self.listener = listener
    }

    func printDebug(_ message: String) {
        if self.debug {
            print("$Log (Observable): \(message)")
        }
    }
}
