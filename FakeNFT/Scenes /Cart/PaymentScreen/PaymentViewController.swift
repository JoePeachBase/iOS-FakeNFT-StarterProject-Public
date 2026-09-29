//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 26.09.2026.
//

import UIKit

enum PaymentViewControllerConstants {
    static let userAgreementURL = "https://yandex.ru/legal/practicum_termsofuse"
}

final class PaymentViewController: UIViewController, LoadingView {
    lazy var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Private properties
    private let collectionViewParams = GeometricParams(
        columnCount: 2,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 8
    )
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collection.isHidden = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    private let successPaymentView: UIView = {
        let view = SuccessPaymentView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var paymentBottomView: PaymentBottomView = {
        let view = PaymentBottomView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var viewModel: PaymentViewModelProtocol
    
    init(_ viewModel: PaymentViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.fetchCurrencies()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        setupView()
        setupCollectionView()
        setupViewModel()
        setupPaymentBottomView()
    }
    
    private func setupViewModel() {
        viewModel.state.bindListener { [weak self] state in
            self?.listenState(state)
        }
    }
    
    private func setupView() {
        title = NSLocalizedString("Payment.title", comment: "")
        view.backgroundColor = .systemBackground
        
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
        view.addSubview(successPaymentView)
        view.addSubview(paymentBottomView)
        
        activityIndicator.constraintCenters(to: view)
        NSLayoutConstraint.activate(
            [
                collectionView.topAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor
                    .constraint(equalTo: paymentBottomView.topAnchor),
                
                successPaymentView.topAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                successPaymentView.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor),
                successPaymentView.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor),
                successPaymentView.bottomAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                
                paymentBottomView.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: 16),
                paymentBottomView.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor, constant: -16),
                paymentBottomView.bottomAnchor
                    .constraint(
                        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                        constant: -8
                    ),
            ]
        )
    }
    
    private func setupPaymentBottomView() {
        guard let url = URL(string: PaymentViewControllerConstants.userAgreementURL) else {
            return
        }
        let baseText = NSLocalizedString("Payment.agreement.label", comment: "")
        let linkText = NSLocalizedString("Payment.agreement.link", comment: "")
        
        paymentBottomView.configure(
            baseText: baseText,
            linkText: linkText,
            url: url
        )
        paymentBottomView.onUserAgreementTap = { [weak self] url in
            let webViewVC = WebViewController(url: url)
            self?.navigationController?
                .pushViewController(webViewVC, animated: true)
        }
        paymentBottomView.onPaymentButtonTap = { [weak self] in
            self?.viewModel.makePayment()
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = collectionViewParams.cellSpacing
        layout.minimumLineSpacing = collectionViewParams.cellSpacing
        layout.sectionInset = UIEdgeInsets(
            top: 20,
            left: collectionViewParams.leftInset,
            bottom: 0,
            right: collectionViewParams.rightInset,
        )
        
        collectionView.collectionViewLayout = layout
        collectionView.register(CurrencyCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func listenState(_ state: ViewState<[CurrencyModel]>) {
        let shouldShowContent = state.isSuccess && !state.isEmpty
        
        collectionView.isHidden = !shouldShowContent
        paymentBottomView.isHidden = !shouldShowContent
        
        if state.isLoading {
            showLoading()
        } else {
            hideLoading()
        }
        
        if case .success = state {
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CurrencyCell = collectionView.dequeueReusableCell(
            indexPath: indexPath
        )
        let currency = viewModel.currencies[indexPath.row]
        
        cell
            .configure(
                imageURL: currency.imageURL,
                title: currency.title,
                subtitle: currency.subtitle,
                isSelected: currency.id == viewModel.selectedCurrencyId
            )
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - collectionViewParams.paddingWidth
        let cellWidth =  availableWidth / CGFloat(
            collectionViewParams.columnCount
        )
        return CGSize(width: cellWidth, height: 48)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let previousSelectedIndex = viewModel.currencies.firstIndex { previousCurrency in
            previousCurrency.id == viewModel.selectedCurrencyId
        }
        
        let currency = viewModel.currencies[indexPath.row]
        viewModel.onCurrencyTap(with: currency.id)
        
        if let previousIndex = previousSelectedIndex {
            let previousIndexPath = IndexPath(row: previousIndex, section: 0)

            if let previousCell = getCurrencyCell(at: previousIndexPath) {
                previousCell.configureCellBorder(isVisible: false)
            }
        }
        
        if let currentCell = getCurrencyCell(at: indexPath) {
            let isSelected = currency.id == viewModel.selectedCurrencyId
            currentCell.configureCellBorder(isVisible: isSelected)
        }
    }
    
    private func getCurrencyCell(at indexPath: IndexPath) -> CurrencyCell? {
        collectionView.cellForItem(at: indexPath) as? CurrencyCell
    }
}
