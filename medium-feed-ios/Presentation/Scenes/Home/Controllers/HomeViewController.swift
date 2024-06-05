//
//  HomeViewController.swift
//  medium-feed-ios
//
//  Created by User on 4/6/2567 BE.
//

import UIKit
import Combine
import SnapKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let viewModel: HomeViewModel
    private let tableView = UITableView()
    private var cancellables = Set<AnyCancellable>()
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    private var refreshControl = UIRefreshControl()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadArticles()
    }

    private func setupUI() {
        
        self.title = "Medium"
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseIdentifier)
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = 120
        tableView.refreshControl = refreshControl

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

    }
    
    @objc private func refreshData() {
        viewModel.loadArticles()
    }
    private func bindViewModel() {
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)

        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    print("Error: \(error)")
                }
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfArticles
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseIdentifier, for: indexPath) as! ArticleCell
        let articleViewModel = viewModel.items[indexPath.row]
        cell.configure(with: articleViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = viewModel.article(at: indexPath.row)
        let detailViewController = DetailViewController(article: article)
        self.navigationController?.pushViewController(detailViewController, animated: true)

    }
}
