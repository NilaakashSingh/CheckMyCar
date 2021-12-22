//
//  Array+Extensions.swift
//  CheckMyCar
//
//  Created by Nilaakash Singh on 23/12/21.
//

import Foundation

extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T))) -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() // Keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
}
