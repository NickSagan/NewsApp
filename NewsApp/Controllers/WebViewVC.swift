//
//  WebViewVC.swift
//  NewsApp
//
//  Created by Nick Sagan on 07.04.2022.
//

import UIKit
import WebKit

class WebViewVC: UIViewController {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var selectedSite: URL!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolBar()
        navigationController?.isNavigationBarHidden = false
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.load(URLRequest(url: selectedSite))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func setupToolBar() {
        let home = UIBarButtonItem(image: UIImage(systemName: "house.fill"), style: .done, target: self, action: #selector(backHome))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let backButton = UIBarButtonItem(image: UIImage(systemName: "backward"), style: .plain, target: webView, action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(image: UIImage(systemName: "forward"), style: .plain, target: webView, action: #selector(webView.goForward))
        toolbarItems = [home, spacer, progressButton, spacer, backButton, spacer, forwardButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func backHome() {
        navigationController?.popViewController(animated: true)
    }
}

extension WebViewVC: WKNavigationDelegate {
    // Key Value Observer for progressBar
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            if webView.estimatedProgress >= 0.95 {
                progressView.isHidden = true
            } else {
                progressView.isHidden = false
            }
        }
    }
}
