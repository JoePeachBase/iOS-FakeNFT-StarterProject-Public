//
//  PaymentBottomView.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 27.09.2026.
//

import UIKit

final class PaymentBottomView: UIView {
    var onUserAgreementTap: ((URL) -> Void)?
    private let agreementTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let paymentButton: UIButton = {
        let title = NSLocalizedString("Payment.button.title", comment: "")
        var configuration = UIButton.Configuration.filled()
        configuration.background.cornerRadius = 16
        configuration.baseBackgroundColor = .segmentActive
        configuration.baseForegroundColor = .white
        
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 17, weight: .bold)
        configuration.attributedTitle = AttributedString(title, attributes: container)
        
        let button = UIButton(configuration: configuration)
        
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
    
    func configure(baseText: String, linkText: String, url: URL) {
        let fullString = "\(baseText)\n\(linkText)"
        let attributedString = NSMutableAttributedString(string: fullString)
        let fullRange = NSRange(location: 0, length: fullString.count)
        
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 13), range: fullRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.segmentActive, range: fullRange)
        
        let linkRange = (fullString as NSString).range(of: linkText)
        if linkRange.location != NSNotFound {
            attributedString.addAttribute(.link, value: url, range: linkRange)
        }
        
        agreementTextView.attributedText = attributedString
    }
    
    private func setupView() {
        backgroundColor = .segmentInactive
        layer.cornerRadius = 12
        
        agreementTextView.delegate = self
        
        addSubview(agreementTextView)
        addSubview(paymentButton)
        
        NSLayoutConstraint.activate(
            [
                agreementTextView.topAnchor
                    .constraint(equalTo: topAnchor, constant: 16),
                agreementTextView.leadingAnchor
                    .constraint(equalTo: leadingAnchor, constant: 16),
                agreementTextView.trailingAnchor
                    .constraint(equalTo: trailingAnchor, constant: -16),
                
                paymentButton.topAnchor
                    .constraint(
                        equalTo: agreementTextView.bottomAnchor,
                        constant: 16
                    ),
                paymentButton.leadingAnchor
                    .constraint(equalTo: agreementTextView.leadingAnchor),
                paymentButton.trailingAnchor
                    .constraint(equalTo: agreementTextView.trailingAnchor),
                paymentButton.bottomAnchor
                    .constraint(equalTo: bottomAnchor, constant: -16),
                paymentButton.heightAnchor.constraint(equalToConstant: 60)
            ]
        )
    }
}

// MARK: - UITextViewDelegate
extension PaymentBottomView: UITextViewDelegate {
    func textView(_ textView: UITextView, primaryActionFor textItem: UITextItem, defaultAction: UIAction) -> UIAction? {
        if case .link(let url) = textItem.content {
            return UIAction { [weak self] _ in
                self?.onUserAgreementTap?(url)
            }
        }
        return defaultAction
    }
}
