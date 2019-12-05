//
//  LoginViewController.swift
//  Steamo
//
//  Created by Max Kraev on 24.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Alamofire
import SVProgressHUD
import UIKit
import WebKit

class LoginViewController: UIViewController {
    /// Колбэк по завершению работы экрана
    var completion: ((SteamUser) -> Void)!

    /// Вебвью
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        webView.load(AuthRequestBuilder.authRequest())
    }

    private func setup() {
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor(named: "Background")
        } else {
            view.backgroundColor = .background
        }
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController: WKNavigationDelegate {
    public func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if ((url?.absoluteString as NSString?)?.range(of: "steamcommunity.com/profiles/"))?.location != NSNotFound {
            let urlComponents = url?.absoluteString.components(separatedBy: "/")
            let potentialID: String = urlComponents?[4] ?? ""
            let user = SteamUser(steamID64: potentialID)
            completion(user)
            dismiss(animated: true, completion: nil)
            postLoginNotification()
            decisionHandler(.cancel)
        } else if ((url?.absoluteString as NSString?)?.range(of: "steamcommunity.com/id/"))?.location != NSNotFound {
            let urlComponents = url?.absoluteString.components(separatedBy: "/")
            let potentialVanityID: String = urlComponents?[4] ?? ""
            let user = SteamUser(steamVanityID: potentialVanityID)
            completion(user)
            dismiss(animated: true, completion: nil)
            postLoginNotification()
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_: WKWebView, didFail _: WKNavigation!, withError _: Error) {
        SVProgressHUD.showError(withStatus: "Failed to load URL")
    }
    
    func postLoginNotification() {
        NotificationCenter.default.post(name: .DidLogin, object: nil)
    }
}
