//
//  PDFReviewViewController.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import UIKit
import PDFKit

class PDFReviewViewController: BaseViewController {

    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    
    var viewModel: PDFReviewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindCloseButton()
        bindShareButton()
        
        loadPDF(filePath: viewModel.filePath)
    }
    
    func setup(_ model: String, kind: PDFReviewViewModel.Kind) {
        viewModel = PDFReviewViewModel(model, kind: kind)
    }
    
    private func loadPDF(filePath: String) {
        let url = URL(fileURLWithPath: viewModel.filePath)
        if let pdfDocument = PDFDocument(url: url) {
            pdfView.displayMode = .singlePageContinuous
            pdfView.autoScales = true
            pdfView.document = pdfDocument
        }
    }
    
    private func bindCloseButton() {
        doneBarButtonItem.rx.taps()
            .onNext { [weak self] in
                guard let self = self else { return }
                switch self.viewModel.kind {
                case .open:
                    self.dismiss(animated: true)
                case .create:
                    guard let window = AppDelegate.shared.window else { return }
                    let nc = WelcomeViewController.instantiateNavigation()
                    UIView.transition(with: window,
                                      duration: 0.2,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        window.rootViewController = nc
                    },
                                      completion: nil)
                }
            }.disposed(by: rx.bag)
    }
    
    private func bindShareButton() {
        shareBarButtonItem.rx.taps()
            .onNext { [weak self] in
                guard let self = self else { return }
                let url = URL(fileURLWithPath: self.viewModel.filePath)
                let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
            .disposed(by: rx.bag)
    }
    
}
