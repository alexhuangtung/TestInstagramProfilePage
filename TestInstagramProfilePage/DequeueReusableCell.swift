//
//  DequeueReusableCell.swift
//  Common
//
//  Created by Alex Huang on 2019/2/22.
//  Copyright © 2019 Mithril Ltd. All rights reserved.
//

import UIKit

public extension UITableView {
    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UITableViewCell {
        return dequeueReusableCell(withIdentifier: T.className, for: indexPath) as! T
    }
    
    func dequeueReusableCell<T>(for row: Int) -> T where T: UITableViewCell {
        return dequeueReusableCell(withIdentifier: T.className, for: IndexPath(row: row, section: 0)) as! T
    }
    
    func dequeueReusableHeaderFooterView<T>() -> T where T: UITableViewHeaderFooterView {
        return dequeueReusableHeaderFooterView(withIdentifier: T.className) as! T
    }
}

public extension UICollectionView {
    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as! T
    }
    
    func dequeueReusableCell<T>(for item: Int) -> T where T: UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: T.className, for: IndexPath(item: item, section: 0)) as! T
    }

    func dequeueReusableSupplementaryView<T>(ofKind kind: String, for indexPath: IndexPath) -> T where T: UICollectionReusableView {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.className, for: indexPath) as! T
    }
}
