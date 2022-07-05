//
//  Bindings.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 16.06.2022.
//

import Foundation

final class Observable<T> {
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listener: ((T?) -> Void)?
    
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}
