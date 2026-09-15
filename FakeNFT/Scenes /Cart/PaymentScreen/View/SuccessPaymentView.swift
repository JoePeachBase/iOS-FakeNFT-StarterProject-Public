//
//  SuccessPaymentView.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 27.09.2026.
//

import UIKit

final class SuccessPaymentView: UIView {
    
    var onBackButtonTap: (() -> Void)?
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: .successPayment)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Payment.success.title", comment: "")
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .segmentActive
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let action = UIAction { [weak self] _ in
            self?.onBackButtonTap?()
        }
        
        let title = NSLocalizedString("Payment.success.button", comment: "")
        var configuration = UIButton.Configuration.filled()
        configuration.background.cornerRadius = 16
        configuration.baseBackgroundColor = .segmentActive
        configuration.baseForegroundColor = .white
        
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 17, weight: .bold)
        configuration.attributedTitle = AttributedString(title, attributes: container)
        
        let button = UIButton(
            configuration: configuration,
            primaryAction: action
        )
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        addSubview(stackView)
        addSubview(backButton)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),

            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            backButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            backButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
}
