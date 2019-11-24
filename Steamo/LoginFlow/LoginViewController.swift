//
//  LoginViewController.swift
//  Steamo
//
//  Created by Max Kraev on 24.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
import AppAuth
import Alamofire

class LoginViewController: UIViewController {
    
    /// Колбэк по завершению работы экрана
    var completion: ((String) -> Void)!
    
    /// Вебвью
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        webView.load(AuthRequestBuilder.authRequest())
    }
    
    /// Фэйковый запрос на валидацию авторизации. На самом деле тут мы уже имеем нужный нам steamid
    /// - Parameter response: ответ от сервера
    fileprivate func validateSteamAPICall(with response: URLResponse) {
        let request = AuthRequestBuilder.validationRequest(for: response)
        if let steamId = String(data: request.httpBody ?? Data(), encoding: .utf8)?
                            .components(separatedBy: "&").first(where: {$0.contains("identity")})?
                            .components(separatedBy: "=").last?
                            .components(separatedBy: "%2F").last {
            completion(steamId)
            dismiss(animated: true, completion: nil)
        }
        
    }
    
}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if navigationResponse.response.url?.absoluteString.contains(API.redirectURL.absoluteString) ?? false {
            validateSteamAPICall(with: navigationResponse.response)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.showError(withStatus: "Failed to load URL")
    }
}
