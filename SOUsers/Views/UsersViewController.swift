//
//  UsersViewController.swift
//  SOUsers
//
//  Created by Will Renton on 04/09/2025.
//

import UIKit
import Combine

class UsersViewController: UIViewController {
    private let viewModel: UsersViewModel = UsersViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // To test API request
    private let userCountTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
        Task {
            await viewModel.fetchUsers()
        }
    }
    
    private func setupUI() {
        view.addSubview(userCountTextView)
        view.addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            userCountTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userCountTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            userCountTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userCountTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$users
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                self?.userCountTextView.text = "Users loaded: \(users.count)"
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.presentError(message)
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.userCountTextView.isHidden = true
                    self?.activityIndicatorView.startAnimating()
                } else {
                    self?.userCountTextView.isHidden = false
                    self?.activityIndicatorView.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
    
    private func presentError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            Task {
                await self?.viewModel.fetchUsers()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
