//
//  TableViewController.swift
//  TestInstagramProfilePage
//
//  Created by Huang Tung on 2019/8/24.
//  Copyright © 2019 Master Plan Worldwide Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

class TableViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(cellClass: UITableViewCell.self)
        tv.rowHeight = 130
        return tv
    }()
    
    private let bag = DisposeBag()
    
    typealias FooSectionModel = SectionModel<String, Int>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataSource = RxTableViewSectionedReloadDataSource<FooSectionModel>(configureCell: { ds, tv, ip, i -> UITableViewCell in
            let cell: UITableViewCell = tv.dequeueReusableCell(for: ip)
            cell.separatorInset = .zero
            cell.contentView.backgroundColor = .randomLight
            cell.textLabel?.text = i.description
            return cell
        })
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        Driver<[FooSectionModel]>
            .just(
                [FooSectionModel(model: "a", items: Array(1...10))]
            )
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
}
