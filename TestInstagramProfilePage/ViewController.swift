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
    
    private let contentVCs = Array(0...30).map { _ in TableViewController() }
    
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
    
    private lazy var prevs: [CGPoint] = contentVCs.map { _ in CGPoint(x: 0, y: -50.0) }
    
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
        contentVCs.forEach { $0.tableView.delegate = self }
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

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.setNeedsUpdateConstraints()
        let index = currentContentIndex
        let prev = prevs[index]
        let curr = scrollView.contentOffset
        prevs[index] = curr
        guard prev.y < -50.0 else { return }
        
        let new: CGPoint = {
            if curr.y < -50.0 {
                return curr
            } else {
                return curr.with { $0.y = -50.0 }
            }
        }()
        contentVCs
            .enumerated()
            .filter { $0.0 != index }
            .forEach {
                $0.1.tableView.contentOffset = new
        }
    }
}
