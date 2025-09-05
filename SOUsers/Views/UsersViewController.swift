//
//  UsersViewController.swift
//  SOUsers
//
//  Created by Will Renton on 04/09/2025.
//

import UIKit
import Combine

class UsersViewController: UIViewController, UITableViewDataSource {
    private let viewModel: UsersViewModel = UsersViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Stack Overflow Top Users"
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
        setupTableView()
        setupUI()
        bindViewModel()
        Task {
            await viewModel.fetchUsers()
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        let nib = UINib(nibName: UserTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: UserTableViewCell.identifier)
    }
    
    private func setupUI() {
        view.addSubview(titleTextView)
        view.addSubview(tableView)
        view.addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$users
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                self?.tableView.reloadData()
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
                    self?.activityIndicatorView.startAnimating()
                } else {
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserTableViewCell.identifier,
            for: indexPath
        ) as? UserTableViewCell else {
            return UITableViewCell()
        }
        
        let user = viewModel.users[indexPath.row]
        let isFollowing = viewModel.isFollowing(for: user.id)
        
        cell.configure(with: user, isFollowing: isFollowing)
        cell.followButtonAction = { [weak self] in
            self?.viewModel.toggleFollowingStatus(for: user.id)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        return cell
    }
}
