//
//  CheckoutBottomView.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 15.09.2026.
//

import UIKit

final class CheckoutBottomView: UIView {
    var onCheckoutButtonTapped: (() -> Void)?
    
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .yaGreenUniversal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var checkoutButton: UIButton = {
        let action = UIAction { [weak self] _ in
            self?.onCheckoutButtonTapped?()
        }
        
        let button = UIButton(type: .system, primaryAction: action)
        button.backgroundColor = .segmentActive
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .segmentInactive
        layer.cornerRadius = 12
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        textStackView.addArrangedSubview(countLabel)
        textStackView.addArrangedSubview(totalPriceLabel)
        
        addSubview(textStackView)
        addSubview(checkoutButton)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 76),
            
            textStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            textStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            checkoutButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkoutButton.leadingAnchor.constraint(equalTo: textStackView.trailingAnchor, constant: 24),
            checkoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            checkoutButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            checkoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configure(countText: String, priceText: String, buttonTitle: String) {
        countLabel.text = countText
        totalPriceLabel.text = priceText
        checkoutButton.setTitle(buttonTitle, for: .normal)
    }
}
