//
//  Reusable.swift
//  CheckMyCar
//
//  Created by Nilaakash Singh on 22/12/21.
//

import UIKit

// MARK: - Reusable protocol to get identifier
protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// UITableView Cell Extension
extension UITableViewCell: Reusable {}

// UITableView Extension
extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
