//
//  CreatePDFViewController.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CreatePDFViewController: BaseViewController {
    
    @IBOutlet weak var createPDFButton: UIButton!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bottomGradientImageView: UIImageView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nameViewTopConstraint: NSLayoutConstraint!

    var viewModel: CreatePDFViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        bindNameTextField()
        bindAddButton()
        bindCancelButton()
        bindCollectionView()
        bindCreateButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topInset = nameView.frame.height + 10
        collectionView.contentInset = UIEdgeInsets(top: topInset,
                                              left: collectionView.contentInset.left,
                                              bottom: 10,
                                              right: collectionView.contentInset.right)
    }
    
    func setup(_ model: ImageScannerResults) {
        viewModel = CreatePDFViewModel(model: model)
    }
    
    private func configureView() {
        collectionView.delegate = self
        collectionView.dragInteractionEnabled = true
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = #colorLiteral(red: 0.2509803922, green: 0.6235294118, blue: 1, alpha: 1)
        bottomGradientImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    private func bindNameTextField() {
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.nameOfDocument)
            .disposed(by: rx.bag)
    }
    
    
    private func bindCollectionView() {
        let animation = AnimationConfiguration(insertAnimation: .none, reloadAnimation: .fade, deleteAnimation: .none)
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<SimpleAnimatableSection<UIImage>>(animationConfiguration: animation, configureCell: { (ds, cv, ip, model) -> UICollectionViewCell in
            let cell = cv.dequeueReusableCell(PageCollectionViewCell.self, for: ip)
            cell.configureView(model)
            return cell
        })
        
        dataSource.canMoveItemAtIndexPath = { (_,_) in
            return true
        }
        
        viewModel.images
            .map { [SimpleAnimatableSection<UIImage>(items: $0)]}
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.bag)
    }
    
    private func bindAddButton() {
        addBarButtonItem.rx.taps()
            .onNext { [weak self] in
                let scannerViewController = ImageScannerController()
                scannerViewController.imageScannerDelegate = self
                self?.present(scannerViewController, animated: true)
            }.disposed(by: rx.bag)
    }
    
    private func bindCreateButton() {
        createPDFButton.rx.taps()
            .bind(to: viewModel.actionCreate.inputs)
            .disposed(by: rx.bag)
        
        viewModel.actionCreate.elements
            .onNext { [weak self] filePath in
                let nc = PDFReviewViewController.instantiateNavigation()
                guard let vc = nc.topViewController as? PDFReviewViewController else { return }
                vc.setup(filePath, kind: .create)
                self?.present(nc, animated: true, completion: nil)
            }
            .disposed(by: rx.bag)
    }
    
    private func bindCancelButton() {
        cancelButton.rx.taps()
            .onNext { [weak self] in
                self?.presentCancelAlert()
            }.disposed(by: rx.bag)
    }
    
    private func presentCancelAlert() {
        AlertBuilder(self)
            .title("Ви впевнені?")
            .message("Зроблені скани будуть втрачені")
            .action(title: "Так", style: .destructive) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .actionCancel()
            .present()
    }
}

extension CreatePDFViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let collectionViewSize = collectionView.frame.size.width - spacing
        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
    }
}

extension CreatePDFViewController: ImageScannerControllerDelegate {
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
        presentErrorAlert()
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        let image = results.doesUserPreferEnhancedImage ? (results.enhancedImage ?? results.scannedImage) : results.scannedImage
        var images = viewModel.images.value
        images.append(image)
        viewModel.images.accept(images)
        scanner.dismiss(animated: true)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true)
    }
    
}

extension CreatePDFViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let nameViewHeight = nameView.frame.height
        let topInset = abs(min(0, scrollView.contentOffset.y + scrollView.adjustedContentInset.top))
        nameViewTopConstraint.constant = topInset
        let scrollInsetTop = topInset + nameViewHeight
        collectionView.scrollIndicatorInsets = UIEdgeInsets.init(top: scrollInsetTop,
                                                             left: scrollView.scrollIndicatorInsets.left,
                                                             bottom: scrollView.scrollIndicatorInsets.bottom,
                                                             right: scrollView.scrollIndicatorInsets.right) }
}

