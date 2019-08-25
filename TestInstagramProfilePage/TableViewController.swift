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
    
    private let refreshControl = UIRefreshControl()

    private(set) lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(cellClass: OfficialLiveCell.self)
        tv.register(cellClass: GeneralLiveCell.self)
        let inset = UIEdgeInsets(top: 250, left: 0, bottom: 0, right: 0)
        tv.scrollIndicatorInsets = inset
        tv.contentInset = inset
        tv.rowHeight = UITableView.automaticDimension
        tv.refreshControl = refreshControl
        return tv
    }()

    private let bag = DisposeBag()
    
    typealias FooSectionModel = SectionModel<String, Int>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let offset: CGFloat = -250
        refreshControl.bounds = CGRect(
            x: refreshControl.bounds.origin.x,
            y: offset,
            width: refreshControl.bounds.size.width,
            height: refreshControl.bounds.size.height
        )
        let dataSource = RxTableViewSectionedReloadDataSource<FooSectionModel>(configureCell: { ds, tv, ip, data -> UITableViewCell in
            if ip.row < 1 {
                let cell: OfficialLiveCell = tv.dequeueReusableCell(for: ip)
                cell.backgroundColor = .randomDark
                cell.textLabel?.text = data.description
                return cell
            } else {
                let cell: GeneralLiveCell = tv.dequeueReusableCell(for: ip)
                cell.backgroundColor = .randomLight
                cell.textLabel?.text = data.description
                return cell
            }
        })
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        refreshControl.rx.controlEvent(.valueChanged)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: refreshControl.endRefreshing)
            .disposed(by: bag)
        
        Driver<[FooSectionModel]>
            .just(
                [FooSectionModel(model: "Live", items: Array(1...Int.random(in: 20...50)))]
            )
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
}

class OfficialLiveCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        separatorInset = .zero
        textLabel?.textColor = .white
        contentView.snp.makeConstraints {
            $0.height.equalTo(130)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GeneralLiveCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        separatorInset = .zero
        contentView.snp.makeConstraints {
            $0.height.equalTo(100)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
