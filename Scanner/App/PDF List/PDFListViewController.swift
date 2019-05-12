//
//  PDFListViewController.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PDFListTableViewCell: UITableViewCell {}

class PDFListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    private let viewModel = PDFListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        
        bindTableView()
        bindErrors()
        bindState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
    }
    
    private func bindErrors() {
        viewModel.actionDelete.errors
            .onNext { [weak self] _ in
                self?.presentErrorAlert()
            }.disposed(by: rx.bag)
    }
    
    private func bindState() {
        viewModel.items
            .map { $0.isEmpty ? CGFloat(0) : 1 }
            .bind(to: tableView.rx.alpha)
            .disposed(by: rx.bag)
        
        viewModel.items
            .map { $0.isEmpty ? CGFloat(1) : 0 }
            .bind(to: emptyLabel.rx.alpha)
            .disposed(by: rx.bag)
    }
    
    private func bindTableView() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SimpleAnimatableSection<URL>>(configureCell: { (ds, tv, ip, model) -> UITableViewCell in
            let cell = tv.dequeueReusableCell(PDFListTableViewCell.self, for: ip)
            let title: String
            if let lastSepatator = model.path.lastIndex(of: "/") {
                let count = model.path.distance(from: model.path.startIndex, to: model.path.index(after: lastSepatator))
                title = String(model.path.dropFirst(count))
            } else {
                title = model.path
            }
            cell.textLabel?.text = title
            return cell
        }, canEditRowAtIndexPath: { _,_  in
            return true
        })
        
        viewModel.items
            .map { [SimpleAnimatableSection(items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.bag)
                
        tableView.rx.modelSelected(URL.self)
            .onNext { [weak self] url in
                let nc = PDFReviewViewController.instantiateNavigation()
                guard let vc = nc.topViewController as? PDFReviewViewController else { return }
                vc.setup(url.path, kind: .open)
                self?.present(nc, animated: true, completion: nil)
            }.disposed(by: rx.bag)
        
        tableView.rx.itemDeleted
            .map { $0.row }
            .bind(to: viewModel.actionDelete.inputs)
            .disposed(by: rx.bag)
    }

}

extension PDFListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
