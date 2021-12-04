// 
//  LoginViewController.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/2.
//

import UIKit
import Combine
import WebKit
import SnapKit

class LoginViewController: UIViewController {

    // MARK: - Property

    var viewModel: LoginViewModelPrototype?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        guard let viewModel = viewModel else { return }

        bind(viewModel)
    }

    // MARK: - Private property

    private let webView = WKWebView()

    private var cancelableSet = Set<AnyCancellable>()
}

// MARK: - UI configure

private extension LoginViewController {

    func setupUI() {
        view.backgroundColor = .white
        configureWebView()
    }

    func configureWebView() {

        webView.navigationDelegate = self

        view.addSubview(webView)

        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Binding

private extension LoginViewController {

    func bind(_ viewModel: LoginViewModelPrototype) {

        viewModel
            .output
            .url
            .sink { [weak webView] in
                webView?.load(.init(url: $0))
            }
            .store(in: &cancelableSet)
    }
}

// MARK: - WKNavigationDelegate

extension LoginViewController: WKNavigationDelegate {

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {

        decisionHandler(.allow)

        guard
            let urlString = webView.url?.absoluteString,
            let queryItems = URLComponents(string: urlString)?.queryItems,
            let code = queryItems.first(where: { $0.name == "code" })?.value
        else {
            return
        }

        webView.navigationDelegate = nil
        webView.removeFromSuperview()
        viewModel?.input.loginSuccess(code: code)
    }
}
