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

class CreatePDFViewController: BaseViewController {
    
    @IBOutlet weak var createPDFButton: UIButton!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bottomGradientImageView: UIImageView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nameViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!

    var viewModel: CreatePDFViewModel!
    let editingCV = BehaviorRelay(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        bindNameTextField()
        bindAddButton()
        bindCancelButton()
        bindCreateButton()
        bindEditing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let rightLeftInset: CGFloat = 15
        let topInset = nameView.frame.height + 20
        let bottomInset: CGFloat = 10
        collectionView.contentInset = UIEdgeInsets(top: topInset,
                                              left: rightLeftInset,
                                              bottom: bottomInset,
                                              right: rightLeftInset)
    }
    
    func setup(_ model: ImageScannerResults) {
        viewModel = CreatePDFViewModel(model: model)
    }
    
    private func configureView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
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
    
    private func bindEditing() {
        editBarButtonItem.rx.taps()
            .withLatestFrom(editingCV)
            .map { !$0 }
            .bind(to: editingCV)
            .disposed(by: rx.bag)
        
        editingCV
            .map { $0 ? "Готово" : "Редагувати" }
            .bind(to: editBarButtonItem.rx.title)
            .disposed(by: rx.bag)
    }
    
    private func bindAddButton() {
        addBarButtonItem.rx.taps()
            .onNext { [weak self] in
                self?.editingCV.accept(false)
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
                self?.editingCV.accept(false)
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
        let rightLeftInset: CGFloat = 15
        let spacing: CGFloat = 10
        let collectionViewSize = collectionView.frame.size.width - spacing - rightLeftInset * 2
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
        viewModel.images.append(image)
        collectionView.reloadData()
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

extension CreatePDFViewController: PageCollectionViewCellDelegate {
    func didRemove(_ model: UIImage) {
        guard let index = viewModel.images.firstIndex(of: model) else { return }
        collectionView.performBatchUpdates({ [weak self] in
            guard let self = self else { return }
            self.viewModel.images.remove(at: index)
            self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        }, completion: nil)
    }
}

extension CreatePDFViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.images[indexPath.row]
        let cell = collectionView.dequeueReusableCell(PageCollectionViewCell.self, for: indexPath)
        cell.configureView(model, editing: editingCV)
        cell.delegate = self
        return cell
    }
}

extension CreatePDFViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = viewModel.images[indexPath.row]
        let itemProvider = NSItemProvider(object: item.description as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            destinationIndexPath = IndexPath(row: collectionView.numberOfItems(inSection: 0) - 1, section: 0)
        }
        if coordinator.proposal.operation == .move {
            if let item = coordinator.items.first,
                let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates({ [weak self] in
                    guard let self = self, let image = item.dragItem.localObject as? UIImage else { return }
                    self.viewModel.images.remove(at: sourceIndexPath.item)
                    self.viewModel.images.insert(image, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                }, completion: nil)
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
    
}
