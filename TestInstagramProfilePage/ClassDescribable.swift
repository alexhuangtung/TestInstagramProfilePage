//
//  ClassDescribable.swift
//  Common
//
//  Created by Alex Huang on 2019/2/22.
//  Copyright © 2019 Mithril Ltd. All rights reserved.
//

import UIKit

public protocol ClassDescribable {
    var className: String { get }
    static var className: String { get }
}

public extension ClassDescribable {
    var className: String {
        return String(describing: type(of: self))
    }

    static var className: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ClassDescribable {}
extension UITableViewHeaderFooterView: ClassDescribable {}
extension UICollectionReusableView: ClassDescribable {}
