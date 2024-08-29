//
//  TransactionViewController.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 03/04/24.
//

import UIKit

final class TransactionViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let transactionListVM = TransactionListViewModel()
    private var refreshControl = UIRefreshControl()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionListVM.numberOfRows(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        let vm = transactionListVM.modelAt(indexPath.row)
        cell.configure(with: vm.description, subtitle: vm.type, amount: "\(vm.amount)", date: vm.dateString)
        return cell
    }
    
    private let earningsView:EarningsView = {
        let earningsView = EarningsView()
        earningsView.translatesAutoresizingMaskIntoConstraints = false
        return earningsView
    }()
    
    private let spentView:SpentView = {
        let spentView = SpentView()
        spentView.translatesAutoresizingMaskIntoConstraints = false
        return spentView
    }()
    
    private let addButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        addButton.tintColor = UIColor.blue
        return addButton
    }()
    
    private let refreshButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
        addButton.tintColor = UIColor.blue
        return addButton
    }()
    
    private let transactionTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1.0
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTransactions()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindViewModel()
        setupRefreshControl()
        fetchTransactions()
        
    }
    
    private func setUpUI(){
        title = transactionListVM.title
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = refreshButton
        
        view.addSubview(earningsView)
        view.addSubview(spentView)
        
        
        addButton.target = self
        addButton.action = #selector(addButtonTapped)
        
        refreshButton.target = self
        refreshButton.action = #selector(fetchTransactions)
        
        let stackView = UIStackView(arrangedSubviews: [earningsView, spentView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        view.addSubview(transactionTableView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            earningsView.heightAnchor.constraint(equalToConstant: 80), // Set the height of the views
            spentView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            transactionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            transactionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            transactionTableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            transactionTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        transactionTableView.dataSource = self
        transactionTableView.delegate = self
        
        
        
        
    }
    
    @objc private func addButtonTapped() {
        
        let addTransactionViewController = AddTransactionViewController()
        //update here if any transaction is called
        addTransactionViewController.onTransactionAdded = { [weak self] in
                self?.fetchTransactions()
            }
        
        let navigationController = UINavigationController(rootViewController: addTransactionViewController)
        navigationController.modalTransitionStyle = .coverVertical
        present(navigationController, animated: true, completion: nil)
        
        }
        
    
    @objc private func fetchTransactions() {
        
        //populate tableview
           transactionListVM.fetchTransactions { [weak self] in
                   
               DispatchQueue.global().async {
                   //calculate earnings and spent
                   self?.transactionListVM.calculateEarningsAndSpentValues()
                   DispatchQueue.main.async {
                       self?.transactionTableView.reloadData()
                       self?.refreshControl.endRefreshing()
                   }
                   
               }
               
           }
        
       }
    
    private func setupRefreshControl() {
            // Configure Refresh Control
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl.addTarget(self, action: #selector(fetchTransactions), for: .valueChanged)
            transactionTableView.addSubview(refreshControl)
        }
    
    private func bindViewModel() {
        transactionListVM.earnedTotal.bind{ [weak self] earnedTotalValue in
           
                self?.earningsView.setAmount(earnedTotalValue)
           
        }
        
        transactionListVM.spentTotal.bind{ [weak self] spentTotalValue in
            
                self?.spentView.setAmount(spentTotalValue)
            
        }
        
        transactionListVM.isAuthenticated.bind{ [weak self] state in
        
            switch state {
             case false :
                self?.redirectToLogin()
             default:
                    break
                }
          
          }
        
        //setup closure to update the indicator
        transactionListVM.updateLoadingStatus = { [weak self] isLoading in
            guard let self = self else { return }
            
            DispatchQueue.main.async{
                if isLoading {
                    self.activityIndicator.startAnimating()
                    self.view.isUserInteractionEnabled = false
                    self.navigationController?.navigationBar.isUserInteractionEnabled = false
                } else {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                }
            }
        }
        
        

    }
    
    
    private func redirectToLogin() {
 
        print("Redirect to login triggered in TransactionVC")
        DispatchQueue.main.async{
            let navVC = UINavigationController(rootViewController: LoginViewController())
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true, completion: {
                self.navigationController?.popViewController(animated: false)
            })
        }
      
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // All rows can be edited
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the transaction from the view model
            transactionListVM.removeTransaction(at: indexPath.row)
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    
    
}
