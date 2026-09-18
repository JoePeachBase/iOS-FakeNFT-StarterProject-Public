//
//  CollectionDetailViewController.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 10.09.2026.
//

import UIKit

private enum Layout {
    static let cardAspectRatio: CGFloat = 192 / 108
}

final class CollectionDetailViewController: UIViewController {
    
    private let viewModel: CollectionDetailViewModel
    private let authorURL = URL(string: "https://practicum.yandex.ru/ios-developer/")
    private let nftDetailAssembly: NftDetailAssembly
    
    private var isLoading = false
    private var cellModels: [CollectionNFTCellModel] = []
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private lazy var navBarBackCustomButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor(resource: .ypBlack)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: CollectionDetailViewModel, nftDetailAssembly: NftDetailAssembly) {
        self.viewModel = viewModel
        self.nftDetailAssembly = nftDetailAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(resource: .ypWhite)
        setupCollectionView()
        setupLayoutAndConstraints()
        bindViewModel()
        viewModel.loadNfts()
    }
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CollectionDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionDetailHeaderView.reuseIdentifier)
        collectionView.register(CollectionNFTCell.self)
        
        collectionView.alwaysBounceVertical = true
    }
    
    private func setupLayoutAndConstraints() {
        view.addSubview(collectionView)
        view.addSubview(navBarBackCustomButton)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            navBarBackCustomButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            navBarBackCustomButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
        ])
    }
    
    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .initial:
                break
            case .loading:
                isLoading = true
                collectionView.reloadData()
            case .loaded(let cellModels):
                isLoading = false
                self.cellModels = cellModels
                collectionView.reloadData()
            case .failed(let error):
                isLoading = false
                collectionView.reloadData()
                
                let errorModel = viewModel.makeErrorModel(error)
                showError(errorModel)
            }
            
        }
    }
}

extension CollectionDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {

        let width = collectionView.bounds.width

        let header = CollectionDetailHeaderView(
            frame: CGRect(x: 0, y: 0, width: width, height: 0)
        )

        header.configure(with: viewModel.headerModel)

        let targetSize = CGSize(
            width: width,
            height: UIView.layoutFittingCompressedSize.height
        )

        let size = header.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        return CGSize(
            width: width,
            height: ceil(size.height)
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let horizontalInset: CGFloat = 16
        let spacing: CGFloat = 9
        let columns: CGFloat = 3

        let availableWidth = collectionView.bounds.width
            - horizontalInset * 2
            - spacing * (columns - 1)

        let width = floor(availableWidth / columns)
        
        let height = width * Layout.cardAspectRatio
        
        return CGSize(
            width: width,
            height: height
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        9
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        16
    }
}

extension CollectionDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading {
            return viewModel.nftCount
        }
        
        return cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionNFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        
        if isLoading {
            cell.configureAsPlaceholder()
        } else {
            let model = cellModels[indexPath.item]
            cell.configure(with: model)
            cell.onFavoriteTap = { [weak self] in
                self?.viewModel.toggleFavorite(nftID: model.id)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CollectionDetailHeaderView.reuseIdentifier,
            for: indexPath
        ) as? CollectionDetailHeaderView else {
            return UICollectionReusableView()
        }
        
        header.configure(with: viewModel.headerModel)
        
        header.onAuthorTap = { [weak self] in
            guard let self else { return }
            guard let url = authorURL else { return }
            
            let webViewController = WebViewController(url: url)
            webViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(webViewController, animated: true)
        }
        
        return header
    }
}

extension CollectionDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
        guard !isLoading else { return }

        let cellModel = cellModels[indexPath.item]
        
        guard !viewModel.isFavoriteUpdating(nftID: cellModel.id) else {
            return
        }

        let input = NftDetailInput(id: cellModel.id)
        let detailViewController = nftDetailAssembly.build(with: input)
        
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
}

extension CollectionDetailViewController: ErrorView {
}
