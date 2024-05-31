//
//  ViewController.swift
//  Zstore
//
//  Created by kaushik on 25/05/24.
//

import UIKit
import CoreData
import WebKit

class HomeViewController: UIViewController, WKNavigationDelegate {
    
    let offerIcon =  {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_offer"), for: .normal)
        button.tintColor = UIColor.orange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let offerLabel: UILabel = {
        let label = UILabel()
        label.text = "Offers"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 230/255, green: 86/255, blue: 15/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    let offerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.borderStyle = .roundedRect
            textField.layer.cornerRadius = 8
            textField.layer.masksToBounds = true
            textField.clearButtonMode = .whileEditing
            if let leftView = textField.leftView as? UIImageView {
                leftView.image = UIImage(systemName: "ic_cancel")
                leftView.alpha = 1.0
            }
        }
        return searchBar
    }()
    let zStoreLabel = UILabel()
    let searchButton = UIButton(type: .system)
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    var categoryCollectionView: UICollectionView!
    var cardOfferCollectionView: UICollectionView!
    var productTableView: UITableView!
    var floatingButton: UIButton!
    var sortView: SortView!
    var homeViewModel = HomeViewModel()
    var appliedOfferButton: AppliedOfferView!
    var storeData: Store?
    var productTableViewConstraints: [NSLayoutConstraint] = []
    var showSortView = true
    var categorySelected = ""
    var offerApplied = false
    var loadingIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupLoadingIndicator()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCategoryCollectionView()
        self.configureCardOfferCollectionView()
        self.configureProductTableView()
        self.setupStoreNameSearchButtonAndOfferView()
        self.configureFAB()
        self.configureSortView()
        self.configureAppliedOfferView()
        self.loadHomeData()
        
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.isHidden = true
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.setupConstraints()
    }
    
    func loadHomeData() {
        homeViewModel.fetchStoreData() { data in
            self.storeData = data
            DispatchQueue.main.async {
                self.categoryCollectionView.reloadData()
                self.categoryCollectionView.layoutIfNeeded()
                self.cardOfferCollectionView.reloadData()
                self.cardOfferCollectionView.layoutIfNeeded()
                self.loadingIndicator.stopAnimating()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let firstIndexPath = IndexPath(item: 0, section: 0)
                self.categoryCollectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: .centeredHorizontally)
                self.collectionView(self.categoryCollectionView, didSelectItemAt: firstIndexPath)
            }
        }
        homeViewModel.fetchRequest(NSPredicate(value: false), "rating") {
            self.productTableView.reloadData()
        }
    }
    
    func setupStoreNameSearchButtonAndOfferView() {
        zStoreLabel.text = "Zstore"
        zStoreLabel.translatesAutoresizingMaskIntoConstraints = false
        zStoreLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        searchButton.setImage(UIImage(named: "ic_search"), for: .normal)
        searchButton.tintColor = self.traitCollection.userInterfaceStyle == .light ? UIColor.black : UIColor.white
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        offerStackView.addArrangedSubview(offerIcon)
        offerStackView.addArrangedSubview(offerLabel)
        view.addSubview(offerStackView)
        view.addSubview(zStoreLabel)
        view.addSubview(searchButton)
    }
    
    func configureFAB() {
        floatingButton = UIButton(type: .custom)
        floatingButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        floatingButton.backgroundColor = .orange
        floatingButton.tintColor = .white
        floatingButton.layer.cornerRadius = 28
        floatingButton.layer.shadowColor = UIColor.black.cgColor
        floatingButton.layer.shadowOpacity = 0.3
        floatingButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        floatingButton.layer.shadowRadius = 3
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        view.addSubview(floatingButton)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .gray
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30)
        ])
    }
    
    func configureAppliedOfferView() {
        appliedOfferButton = AppliedOfferView(title: "")
        view.addSubview(appliedOfferButton)
        appliedOfferButton.delegate = self
        appliedOfferButton.isHidden = true
        NSLayoutConstraint.activate([
            appliedOfferButton.topAnchor.constraint(equalTo: offerStackView.bottomAnchor, constant: 170),
            appliedOfferButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            appliedOfferButton.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    func configureSortView() {
        sortView = SortView(frame: CGRect(x: 20, y: view.frame.height - 250, width: view.frame.width - 40, height: 150))
        sortView.backgroundColor = .white
        sortView.layer.borderColor = UIColor.gray.cgColor
        sortView.layer.borderWidth = 1.0
        view.addSubview(sortView)
        sortView.isHidden = true
        sortView.delegate = self
        sortView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sortView.bottomAnchor.constraint(equalTo: floatingButton.topAnchor, constant: -20),
            sortView.heightAnchor.constraint(equalToConstant: 150),
            sortView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func configureCategoryCollectionView() {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return self.createCompositionalLayout()
        }
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoryCollectionView.isScrollEnabled = false
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        view.addSubview(categoryCollectionView)
    }
    
    func configureCardOfferCollectionView() {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return self.createCompositionalLayoutForCard()
        }
        layout.configuration.scrollDirection = .vertical
        cardOfferCollectionView = UICollectionView(frame: CGRect(x: 50, y: 50, width: 400, height: 400), collectionViewLayout: layout)
        cardOfferCollectionView.bounces = false
        cardOfferCollectionView.translatesAutoresizingMaskIntoConstraints = false
        cardOfferCollectionView.delegate = self
        cardOfferCollectionView.dataSource = self
        cardOfferCollectionView.register(CardOfferCollectionViewCell.self, forCellWithReuseIdentifier: CardOfferCollectionViewCell.reuseIdentifier)
        view.addSubview(cardOfferCollectionView)
    }
    
    func configureProductTableView() {
        productTableView = UITableView(frame: .zero)
        productTableView.dataSource = self
        productTableView.delegate = self
        productTableView.showsVerticalScrollIndicator = false
        productTableView.translatesAutoresizingMaskIntoConstraints = false
        productTableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier)
        view.addSubview(productTableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            zStoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            zStoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            
            offerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            offerStackView.topAnchor.constraint(equalTo: zStoreLabel.bottomAnchor, constant: 140),
            offerStackView.heightAnchor.constraint(equalToConstant: 50.0),
            
            categoryCollectionView.topAnchor.constraint(equalTo: zStoreLabel.bottomAnchor, constant: 0),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryCollectionView.bottomAnchor.constraint(equalTo: cardOfferCollectionView.topAnchor, constant: 0),
            
            cardOfferCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            cardOfferCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardOfferCollectionView.bottomAnchor.constraint(equalTo: productTableView.topAnchor, constant: 16),
            cardOfferCollectionView.topAnchor.constraint(equalTo: offerStackView.bottomAnchor, constant: 0),
            
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            floatingButton.widthAnchor.constraint(equalToConstant: 56),
            floatingButton.heightAnchor.constraint(equalToConstant: 56),
            
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        ])
        
        // Setting auto layout constraints for all devices based on condition
        if UIScreen.main.bounds.size.height < 670 {
            productTableViewConstraints = [
                productTableView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2.8),
                productTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                productTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                productTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ]
        } else {
            productTableViewConstraints = [
                productTableView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2.2),
                productTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                productTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                productTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ]
        }
        NSLayoutConstraint.activate(productTableViewConstraints)
    }
    
    // Compositional layout for category collection view
    func createCompositionalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.2), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
        return section
    }
    
    // Compositional layout for card offer collection view
    func createCompositionalLayoutForCard() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 16)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    // Adjust TableView height based on certain UI actions like apply and remove offer, search button clicked
    func adjustProductTableViewConstraints(_ factor: Double) {
        NSLayoutConstraint.deactivate(productTableViewConstraints)
        productTableViewConstraints = [
            productTableView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / factor),
            productTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            productTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            productTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ]
        NSLayoutConstraint.activate(productTableViewConstraints)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    // This method is used to find the url from product description text
    func textInsideParentheses(from string: String) -> String? {
        let pattern = "\\(([^)]+)\\)"
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let range = NSRange(location: 0, length: string.utf16.count)
            if let match = regex.firstMatch(in: string, options: [], range: range) {
                if let range = Range(match.range(at: 1), in: string) {
                    return String(string[range])
                }
            }
        }
        return nil
    }
    
    // This is a generic method to form a predicate to be used while fetching results from NSFetchResultsController
    func formPredicate() -> NSPredicate {
        let filterTerm = storeData?.category.filter { " \($0.name)  " == categorySelected }
        var predicate = NSPredicate(format: "category_id = %@", "")
        if let filterTerm = filterTerm {
            predicate = NSPredicate(format: "category_id = %@", filterTerm[0].id)
        }
        return predicate
    }
    
    @objc func floatingButtonTapped () {
        if showSortView {
            sortView.isHidden = false
        } else {
            sortView.isHidden = true
        }
        showSortView = !showSortView
    }
    
    @objc func searchTapped() {
        DispatchQueue.main.async {
            self.cardOfferCollectionView.isHidden = true
            self.offerStackView.isHidden = true
            self.searchButton.isHidden = true
            self.zStoreLabel.isHidden = true
            self.searchBar.isHidden = false
            if self.offerApplied {
                self.appliedOfferButton.isHidden = true
            }
            self.adjustProductTableViewConstraints(1.5)
        }
    }
}

// MARK: COLLECTION VIEW METHODS
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoryCollectionView {
            return storeData?.category.count ?? 0
        } else {
            return storeData?.card_offers.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
            cell.configure(indexPath, storeData)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardOfferCollectionViewCell.reuseIdentifier, for: indexPath) as! CardOfferCollectionViewCell
            cell.configure(indexPath, storeData)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
            cell?.selectedState()
            categorySelected = cell?.label.text ?? ""
            homeViewModel.fetchRequest(formPredicate(), "rating") {
                self.productTableView.reloadData()
            }
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? CardOfferCollectionViewCell
            NotificationCenter.default.post(name: NSNotification.Name("ApplyOffer"),
                                            object: nil, userInfo: ["selectedOffer": cell?.titleLabel.text ?? ""])
            NotificationCenter.default.post(name: NSNotification.Name("DiscountCalculation"),
                                            object: nil, userInfo: ["discount": storeData?.card_offers[indexPath.row].percentage ?? 0])
            let offerPredicate = NSPredicate(format: "card_offer_ids CONTAINS %@", storeData?.card_offers[indexPath.row].id ?? "")
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [formPredicate(), offerPredicate])
            homeViewModel.fetchRequest(compoundPredicate, "rating") {
                self.productTableView.reloadData()
            }
            offerApplied = true
            self.adjustProductTableViewConstraints(UIScreen.main.bounds.size.height < 670 ? 3.3 : 2.6)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
            cell?.unselectedState()
        }
    }
}

// MARK: TABLE VIEW METHODS
extension HomeViewController: UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.reuseIdentifier, for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let product = homeViewModel.fetchedResultsController.object(at: indexPath)
        cell.configure(product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ProductTableViewCell
        let webViewController = WebViewController()
        let linkTobeChecked = self.textInsideParentheses(from: cell.descriptionLabel.text ?? "")
        if linkTobeChecked != nil {
            webViewController.url = URL(string: linkTobeChecked ?? "")
            present(webViewController, animated: true, completion: nil)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        productTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        productTableView.endUpdates()
    }
}

// MARK: SORT VIEW DELEGATE METHODS
extension HomeViewController: SortViewDelegate {
    func sortApplied(_ sortBy: String) {
        homeViewModel.fetchRequest(formPredicate(), sortBy) {
            self.productTableView.reloadData()
        }
    }
}

// MARK: APPLIED OFFER VIEW DELEGATE METHODS
extension HomeViewController: AppliedOfferViewDelegate {
    func adjustProductTableViewHeight() {
        self.adjustProductTableViewConstraints(UIScreen.main.bounds.size.height < 670 ? 2.8 : 2.2)
        homeViewModel.fetchRequest(formPredicate(), "rating") {
            self.productTableView.reloadData()
        }
        offerApplied = false
    }
}

// MARK: UI SEARCH BAR DELEGATE METHODS
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            let offerPredicate = NSPredicate(format: "name CONTAINS %@", searchText)
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [formPredicate(), offerPredicate])
            homeViewModel.fetchRequest(compoundPredicate, "rating") {
                self.productTableView.reloadData()
            }
        } else {
            homeViewModel.fetchRequest(formPredicate(), "rating") {
                self.productTableView.reloadData()
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.text = ""
            self.homeViewModel.fetchRequest(self.formPredicate(), "rating") {
                self.productTableView.reloadData()
            }
            self.searchBar.isHidden = true
            self.searchButton.isHidden = false
            self.zStoreLabel.isHidden = false
            self.offerStackView.isHidden = false
            self.cardOfferCollectionView.isHidden = false
            if self.offerApplied {
                self.appliedOfferButton.isHidden = false
                self.adjustProductTableViewConstraints(UIScreen.main.bounds.size.height < 670 ? 3.3 : 2.6)
            } else {
                self.adjustProductTableViewConstraints(UIScreen.main.bounds.size.height < 670 ? 2.8 : 2.2)
            }
            searchBar.searchTextField.resignFirstResponder()
        }
    }
}
