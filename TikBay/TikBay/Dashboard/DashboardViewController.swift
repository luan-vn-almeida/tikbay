//
//  DashboardViewController.swift
//  TikBay
//
//  Created by Luan Almeida on 27/03/23.
//

import UIKit

class DashboardViewController: UIViewController {

    lazy var headerComponentView: HeaderComponentView = {
        let view = HeaderComponentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bodyComponentView: BodyComponentView = {
        let view = BodyComponentView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var viewModel: DashboardViewModelProtocol = DashboardViewModel()
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        buildLayout()
        Task {
            await viewModel.loadData()
        }
    }
}

extension DashboardViewController: ViewConfiguration {
    
    func buildViewHierarchy() {
        view.addSubview(bodyComponentView)
        view.addSubview(headerComponentView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerComponentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerComponentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerComponentView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        NSLayoutConstraint.activate([
            bodyComponentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bodyComponentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bodyComponentView.topAnchor.constraint(equalTo: view.topAnchor),
            bodyComponentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func configureViews() {
        view.backgroundColor = .red
        viewModel.delegate = self
    }
}

extension DashboardViewController: DashboardViewModelOutput {
    
    func reloadProfile() {
        Task {
            await headerComponentView.update(look: viewModel.currentLook)
        }
    }
 
    func reloadCollection() {
        bodyComponentView.reloadData(looks: viewModel.looks)
    }
}

extension DashboardViewController: BodyComponentViewDelegate {
    func didSelectRow(_ indexPath: IndexPath) {
        viewModel.showLook(row: indexPath.row)
    }
    
    func nextPage() {
        viewModel.nextPage()
    }
}
