//
//  MainTableViewController.swift
//  RegList
//
//  Created by Тадевос Курдоглян on 14.08.2025.
//

import UIKit

final class MainTableViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var greetButton: UIButton!
    
    // MARK: - Properties
    private let viewModel = MainViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Главная"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Выйти",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        bindViewModel()
        viewModel.load()
    }
    
    // MARK: - Private
    private func bindViewModel() {
        viewModel.onLoadingChange = { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.startAnimating()
                // корректная высота header
                spinner.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 44)
                self.tableView.tableHeaderView = spinner
            } else {
                self.tableView.tableHeaderView = nil
            }
        }
        viewModel.onDataChange = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.onError = { [weak self] message in
            let ac = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
    
    
    // MARK: - Actions
    @IBAction private func greetTapped(_ sender: UIButton) {
        let name = (UserDefaults.standard.string(forKey: "userName") ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let displayName = name.isEmpty ? "пользователь" : name
        let alert = UIAlertController(title: "Приветствие",
                                      message: "Привет, \(displayName)!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func logoutTapped() {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "isRegistered")
        defaults.removeObject(forKey: "userName")
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let reg = sb.instantiateViewController(withIdentifier: "RegistrationViewController")
        
        if let nav = navigationController {
            nav.setViewControllers([reg], animated: true)
        } else {
            let nav = UINavigationController(rootViewController: reg)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension MainTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.configure(title: viewModel.title(at: indexPath.row),
                       price: viewModel.priceText(at: indexPath.row))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
