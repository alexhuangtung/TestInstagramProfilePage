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
import RxSwiftExt
import Then
import UIKit

class ViewController: UIViewController {
    
    private let bag = DisposeBag()
    
    private let contentVCs = Array(1...5).map { _ in TableViewController() }
    
    private lazy var headerView: UIView = {
        let v = UIView()
        v.backgroundColor = .yellow
        v.addSubview(categoryView)
        categoryView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        return v
    }()
    
    private let categoryView: UIView = {
        let v = UIView()
        v.backgroundColor = .cyan
        return v
    }()
    
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
        view.addSubview(contentScrollView)
        view.addSubview(headerView)
        contentScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        headerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        Observable
            .merge(contentVCs.map { $0.tableView.rx.didScroll.asObservable() })
            .subscribe(onNext: view.setNeedsUpdateConstraints)
            .disposed(by: bag)
        
        Array(0 ..< contentVCs.count)
            .forEach { index in
                Observable<CGPoint>
                    .merge(
                        contentVCs.enumerated()
                            .filter { $0.0 != index }
                            .map { $0.1.tableView.rx.contentOffset.asObservable() }
                    )
                    .startWith(.zero)
                    .pairwise()
                    .filter { prev, _ -> Bool in
                        prev.y < -50.0
                    }
                    .map { _, curr -> CGPoint in
                        if curr.y <= -50.0 {
                            return curr
                        } else {
                            return curr.with { $0.y = -50.0 }
                        }
                    }
                    .bind(to: contentVCs[index].tableView.rx.contentOffset)
                    .disposed(by: bag)
        }
    }
    
    var currentContentIndex: Int {
        return Int(contentScrollView.contentOffset.x) / Int(contentScrollView.bounds.width)
    }
    
    override func updateViewConstraints() {
        guard contentScrollView.bounds.width != 0 else {
            super.updateViewConstraints()
            return
        }
        
        let y = contentVCs[currentContentIndex].tableView.contentOffset.y
        let offset = max(-200, -y - 250)
        headerView.snp.updateConstraints {
            $0.top.equalToSuperview().inset(offset)
        }
        super.updateViewConstraints()
    }
    
}
