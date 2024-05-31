//
//  WebViewController.swift
//  Zstore
//
//  Created by kaushik on 29/05/24.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
