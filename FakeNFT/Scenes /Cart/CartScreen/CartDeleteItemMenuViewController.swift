//
//  CartDeleteItemMenuViewController.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 15.09.2026.
//

import UIKit

final class CartDeleteItemMenuViewController: UIViewController {
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .segmentActive
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var deleteButton: UIButton = {
        let action = UIAction { [weak self] _ in self?.dismiss(animated: true) }
        let button = UIButton(type: .system, primaryAction: action)
        button.setTitle("Удалить", for: .normal)
        button.backgroundColor = .segmentActive
        button.setTitleColor(.yaRedUniversal, for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 17)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let action = UIAction { [weak self] _ in self?.dismiss(animated: true) }
        let button = UIButton(type: .system, primaryAction: action)
        button.setTitle("Отмена", for: .normal)
        button.backgroundColor = .segmentActive
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 17)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    private func setupLayout() {
        view.backgroundColor = .clear
        
        view.addSubview(blurEffectView)
        view.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(imageView)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(deleteButton)
        buttonStackView.addArrangedSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            imageView.widthAnchor.constraint(equalToConstant: 108),
            imageView.heightAnchor.constraint(equalToConstant: 108),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            
            buttonStackView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func configure(imageResource: ImageResource, text: String) {
        imageView.image = UIImage(resource: imageResource)
        descriptionLabel.text = text
    }
}
