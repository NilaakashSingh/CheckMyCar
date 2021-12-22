//
//  BrandCategoryListView.swift
//  CheckMyCar
//
//  Created by Nilaakash Singh on 22/12/21.
//

import SwiftUI

struct BrandCategoryListView: View {
    
    // MARK: - Variables
    @ObservedObject var viewModel: BrandCategoryListViewModel
    @State private var showAlert = false
    @State private var selectedBrandCategoryName: String = .empty
    
    // MARK: - Initialisers
    init(manufacturer: ManufacturerInformation) {
        viewModel = BrandCategoryListViewModel(manufacturer: manufacturer)
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            if viewModel.showLoadingIndicator && viewModel.brandCategories.count <= 0 {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                carBrandCategoryListView
            }
        }
        .navigationTitle(Text(viewModel.manufacturer.name))
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Manufacturer: \(viewModel.manufacturer.name)"),
                  message: Text("Model Name: \(selectedBrandCategoryName)"),
                  dismissButton: .default(Text("Got it!")))
        }
        .onAppear {
            Task {
                try? await viewModel.fetchCarBrandList(url: viewModel.networkLinkURL(manufacturerID: viewModel.manufacturer.id, page: .zero, pageSize: AppConstant.pageSize))
            }
        }
    }
}

// MARK: - Supporting methods and variables
extension BrandCategoryListView {
    private var carBrandCategoryListView: some View {
        List {
            ForEach(Array(viewModel.brandCategories.enumerated()), id: \.element) { (index, manufacturer) in
                HStack {
                    Text(manufacturer.name)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .frame(height: 60)
                .listRowBackground(backgroundColor(for: index))
                .onTapGesture {
                    showAlert.toggle()
                    selectedBrandCategoryName = manufacturer.name
                }
                .onAppear {
                    if manufacturer == viewModel.brandCategories.last, viewModel.shouldLoadMoreData() {
                        Task {
                            try? await viewModel.fetchCarBrandList(url: viewModel.networkLinkURL( manufacturerID: viewModel.manufacturer.id, page: viewModel.brandCategoryList?.page ?? .zero, pageSize: AppConstant.pageSize), paginationEnabled: true)
                        }
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func backgroundColor(for index: Int) -> Color {
        return index % 2 != .zero ? Color(.darkGray) : Color(.clear)
    }
}

// MARK: - Preview
struct BrandCategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        BrandCategoryListView(manufacturer: ManufacturerInformation(name: "130", id: "Mercedes"))
    }
}
