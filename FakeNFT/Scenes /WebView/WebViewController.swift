//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 14.09.2026.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {

    private let url: URL
    
    private var progressObservation: NSKeyValueObservation?

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private lazy var navBarBackCustomButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor(resource: .ypBlack)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupLayoutAndConstraints()
        observeProgress()
        
        webView.load(URLRequest(url: url))
    }
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupLayoutAndConstraints() {
        view.addSubview(webView)
        view.addSubview(progressView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func observeProgress() {
        progressObservation = webView.observe(\.estimatedProgress,options: [.new]) { [weak self] webView, _ in
            guard let self else { return }
            
            progressView.setProgress(Float(webView.estimatedProgress),animated: true)
            
            if webView.estimatedProgress >= 1 { UIView.animate(
                    withDuration: 0.25,
                    animations: {
                        self.progressView.alpha = 0
                    },
                    completion: { _ in
                        self.progressView.isHidden = true
                        self.progressView.progress = 0
                        self.progressView.alpha = 1
                    }
                )
            } else {
                progressView.isHidden = false
                progressView.alpha = 1
            }
        }
    }
    
    private func setupNavigationItem() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        
        backButton.tintColor = UIColor(resource: .ypBlack)
        navigationItem.leftBarButtonItem = backButton
    }
}
