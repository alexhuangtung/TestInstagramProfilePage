//
//  ViewController.swift
//  TestInstagramProfilePage
//
//  Created by Huang Tung on 2019/8/24.
//  Copyright © 2019 Master Plan Worldwide Ltd. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import UIKit

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(cellClass: BannerContainerCell.self)
        tv.register(cellClass: LiveContainerCell.self)
        tv.register(headerFooterViewClass: CagegoryContainerHeaderView.self)
        tv.rowHeight = UITableView.automaticDimension
        tv.delegate = self
        return tv
    }()
    
    private let bag = DisposeBag()
    
    typealias FooSectionModel = SectionModel<String, Int>
    
    let contentVCs = Array(1...5).map { _ in TableViewController() }
    
    private lazy var contentScrollView: UIScrollView = {
        let sv = UIScrollView(frame: .zero)
        sv.bounces = true
        sv.isPagingEnabled = true
        for (i, vc) in contentVCs.enumerated() {
            addChild(vc)
            vc.didMove(toParent: self)
            sv.addSubview(vc.view)
            vc.view.snp.makeConstraints {
                $0.size.equalTo(sv.snp.size)
                $0.top.bottom.equalToSuperview()
                if i == 0 {
                    $0.left.equalToSuperview()
                } else {
                    $0.left.equalTo(contentVCs[i - 1].view.snp.right)
                }
                if i == contentVCs.count - 1 {
                    $0.right.equalToSuperview()
                }
            }
        }
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "alexhuangtung"
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let dataSource = RxTableViewSectionedReloadDataSource<FooSectionModel>(configureCell: { [unowned self] ds, tv, ip, data -> UITableViewCell in
            switch ds[ip.section].identity {
            case "Banner":
                let cell: BannerContainerCell = tv.dequeueReusableCell(for: ip)
                return cell
            case "Live":
                let cell: LiveContainerCell = tv.dequeueReusableCell(for: ip)
                cell.contentView.addSubview(self.contentScrollView)
                self.contentScrollView.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
                return cell
            default:
                fatalError()
            }
        })
        
        Driver<[FooSectionModel]>
            .just([
                FooSectionModel(model: "Banner", items: [1]),
                FooSectionModel(model: "Live", items: [1])
                ]
            )
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        case 1:
            return view.bounds.height - 60
        default:
            fatalError()
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1 else { return nil }
        
        let headerView: CagegoryContainerHeaderView = tableView.dequeueReusableHeaderFooterView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 1 else { return 0 }
        
        return 60
    }
}

class BannerContainerCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .randomLight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class LiveContainerCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .randomLight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CagegoryContainerHeaderView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .randomLight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
