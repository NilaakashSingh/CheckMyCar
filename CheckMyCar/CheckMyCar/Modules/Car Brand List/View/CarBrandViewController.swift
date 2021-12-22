//
//  CarBrandViewController.swift
//  CheckMyCar
//
//  Created by Nilaakash Singh on 21/12/21.
//

import UIKit
import SwiftUI

class CarBrandViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var carBrandTableView: UITableView!
    
    // MARK: - Variables
    private var viewModel = CarBrandViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchCarBrandList()
        setupActivityIndicator()
    }
    
    // MARK: - User Defined Methods
    /// Method to set up activity indicator
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
}

// MARK: - UITableView DataSource and Delegate
extension CarBrandViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.manufacturers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CarBrandViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(manufacturerName: viewModel.manufacturers[indexPath.row].name,
                       oddCell: indexPath.row % 2 != .zero)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let brandCategoryListView = BrandCategoryListView(manufacturer: viewModel.manufacturers[indexPath.row])
        navigationController?.pushViewController(UIHostingController(rootView: brandCategoryListView), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) && viewModel.shouldLoadNextPage())  {
            viewModel.fetchCarBrandList(url: NetworkLink.carBrandListURL(page: viewModel.carBrandList?.page ?? .zero, pageSize: AppConstant.pageSize).url, paginationApplied: true)
        }
    }
}

// MARK: - Car Brand View Model Delegate
extension CarBrandViewController: CarBrandViewModelDelegate {
    func didFetchListSuccess() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            self.carBrandTableView.reloadData()
        }
    }
    
    func didFetchListFailure(error: Error) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            let alert = UIAlertController(title: "Error!",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
