//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 27.09.2026.
//

import UIKit
import WebKit

final class WebViewController: UIViewController, LoadingView {
    private let url: URL
    
    internal lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    static func create(with url: URL) -> WebViewController? {
        guard url.absoluteString == PaymentViewControllerConstants.userAgreementURL else {
            return nil
        }
        return WebViewController(url: url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        loadWebView()
    }
    
    private func setupNavigationBar() {
        let backAction = UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let backButtonImage = UIImage(resource: .back)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: backButtonImage,
            primaryAction: backAction
        )
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        activityIndicator.constraintCenters(to: view)
    }
    
    private func loadWebView() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoading()
    }
}
