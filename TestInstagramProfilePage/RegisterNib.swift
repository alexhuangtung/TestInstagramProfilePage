//
//  RegisterNib.swift
//  Common
//
//  Created by Alex Huang on 2019/2/22.
//  Copyright © 2019 Mithril Ltd. All rights reserved.
//

import UIKit

public extension UITableView {
    func register(cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.className)
    }

    func register(headerFooterViewClass: UITableViewHeaderFooterView.Type) {
        register(headerFooterViewClass, forHeaderFooterViewReuseIdentifier: headerFooterViewClass.className)
    }

    func registerCellNib(cellClass: UITableViewCell.Type) {
        let reuseId = cellClass.className
        let nib = UINib(nibName: reuseId, bundle: Bundle.main)
        register(nib, forCellReuseIdentifier: reuseId)
    }

    func registerHeaderFooterNib(headerFooterViewClass: UITableViewHeaderFooterView.Type) {
        let reuseId = headerFooterViewClass.className
        let nib = UINib(nibName: reuseId, bundle: Bundle.main)
        register(nib, forHeaderFooterViewReuseIdentifier: reuseId)
    }
}

public extension UICollectionView {
    func register(cellClass: UICollectionViewCell.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.className)
    }

    func register(headerClass: UICollectionReusableView.Type) {
        register(headerClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerClass.className)
    }

    func register(footerClass: UICollectionReusableView.Type) {
        register(footerClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerClass.className)
    }

    func registerCellNib(cellClass: UICollectionViewCell.Type) {
        let reuseId = cellClass.className
        registerCellNib(nibName: reuseId)
    }

    func registerCellNib(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        register(nib, forCellWithReuseIdentifier: nibName)
    }

    func registerHeaderNib(reusableViewClass: UICollectionReusableView.Type) {
        let reuseId = reusableViewClass.className
        let nib = UINib(nibName: reuseId, bundle: Bundle.main)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseId)
    }

    func registerFooterNib(reusableViewClass: UICollectionReusableView.Type) {
        let reuseId = reusableViewClass.className
        let nib = UINib(nibName: reuseId, bundle: Bundle.main)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseId)
    }
}
