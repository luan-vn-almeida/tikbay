//
//  BodyComponentView.swift
//  TikBay
//
//  Created by Luan Almeida on 27/03/23.
//

import UIKit

protocol BodyComponentViewDelegate: AnyObject {
    
    func didSelectRow(_ indexPath: IndexPath)
    func nextPage()
}

class BodyComponentView: UIView {

    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.register(BodyCollectionViewCell.self, forCellWithReuseIdentifier: BodyCollectionViewCell.identifier)
        return view
    }()
    
    weak var delegate: BodyComponentViewDelegate?
    
    private var viewModel: BodyComponentViewModelProtocol
    private var firstLoading = true
    
    init(viewModel: BodyComponentViewModelProtocol = BodyComponentViewModel()) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(looks: [Look]) {
        viewModel.looks = looks
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension BodyComponentView: ViewConfiguration {
    
    func buildViewHierarchy() {
        addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}

extension BodyComponentView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = self.collectionView.indexPathsForVisibleItems.sorted { top, bottom -> Bool in
                return top.section < bottom.section || top.row < bottom.row
            }.compactMap { indexPath -> UICollectionViewCell? in
                return self.collectionView.cellForItem(at: indexPath)
            }
        let indexPaths = self.collectionView.indexPathsForVisibleItems.sorted()
        let cellCount = visibleCells.count
        guard let firstCell = visibleCells.first as? BodyCollectionViewCell, let firstIndex = indexPaths.first else {
            return
        }
        checkVisibilityOfCell(cell: firstCell, indexPath: firstIndex)
        if cellCount == 1 {
            return
        }
        guard let lastCell = visibleCells.last as? BodyCollectionViewCell, let lastIndex = indexPaths.last else {
            return
        }
        checkVisibilityOfCell(cell: lastCell, indexPath: lastIndex)
    }
    
    func checkVisibilityOfCell(cell: BodyCollectionViewCell, indexPath: IndexPath) {
        delegate?.didSelectRow(indexPath)
        if let cellRect = (collectionView.layoutAttributesForItem(at: indexPath)?.frame) {
            let completelyVisible = collectionView.bounds.contains(cellRect)
            if completelyVisible {
                cell.loadVideo()
            } else {
                cell.stopVideo()
            }
        }
    }
}

extension BodyComponentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BodyCollectionViewCell.identifier, for: indexPath) as? BodyCollectionViewCell else {
            return UICollectionViewCell()
        }
        let look = viewModel.looks[indexPath.item]
        cell.set(look: look)
        if firstLoading && indexPath.row == 0 {
            cell.loadVideo()
            firstLoading = false
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == viewModel.looks.count - 1) {
            delegate?.nextPage()
        }
    }
}

extension BodyComponentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.looks.count
    }
}

extension BodyComponentView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return frame.size
    }
}
