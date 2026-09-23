//
//  Observable.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 15.09.2026.
//

final class Observable<T> {
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bindListener(_ listener: @escaping (T) -> Void) {
        self.listener = listener
    }
}
