//
//  WebViewViewController.swift
//  NewsApp
//
//  Created by Nick Sagan on 07.04.2022.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    var webView: WKWebView!
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.sizeToFit()
        return progress
    }()
    
    private var url: URL
    
    //MARK: - Initialization
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    //MARK: - Private
    
    private func setup() {
        navigationController?.isToolbarHidden = false
        navigationController?.isNavigationBarHidden = false
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbarItems = [
            UIBarButtonItem(image: UIImage(systemName: "house.fill"), style: .done, target: self, action: #selector(backHome)),
            spacer,
            UIBarButtonItem(customView: progressView),
            spacer,
            UIBarButtonItem(image: UIImage(systemName: "backward"), style: .plain, target: webView, action: #selector(webView.goBack)),
            spacer,
            UIBarButtonItem(image: UIImage(systemName: "forward"), style: .plain, target: webView, action: #selector(webView.goForward)),
            spacer,
            UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        ]
    }
    
    @objc
    private func backHome() {
        navigationController?.popViewController(animated: true)
    }
}

extension WebViewViewController: WKNavigationDelegate {

    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard keyPath == "estimatedProgress" else { return }

        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = webView.estimatedProgress >= 0.95
    }
}
