//
//  DetailViewController.swift
//  MerchCollections
//
//  Created by Omar Abbasi on 2019-01-18.
//  Copyright © 2019 Omar Abbasi. All rights reserved.
//

import UIKit

class TableViewHelper {
    
    class func EmptyMessage(message: String, viewController: UITableViewController) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.medium)
        messageLabel.sizeToFit()
        
        viewController.tableView.backgroundView = messageLabel
        viewController.tableView.separatorStyle = .none
    }
}

class ProductDetailCell: UITableViewCell {
    
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var vendorLabel: UILabel!
    @IBOutlet var otherInformation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImage?.contentMode = .scaleAspectFill
        productImage.layer.cornerRadius = productImage.bounds.size.height / 2
        productImage.clipsToBounds = true
    }
    
    func setDataFrom(_ product: Product) {
        
        nameLabel?.text = product.title
        productImage?.image = product.image
        descriptionLabel?.text = product.description
        vendorLabel?.text = product.vendor
        otherInformation?.text =  product.productType + " · " + "\(product.totalInventory) In Stock"
        
    }
    
}

class CollectDetailController: UITableViewController, RefreshDelegate {
    
    let viewModel: CollectionDetailsViewModel
    let collection: CustomCollection
    
    init(viewModel: CollectionDetailsViewModel, collection: CustomCollection) {
        self.viewModel = viewModel
        self.collection = collection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewModel.delegate = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProductDetailCell", bundle: nil), forCellReuseIdentifier: "collectionDetailCell")
        
        let headerView = CollectionDetailHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 151), collection: collection)
        let extraHeight = headerView.getExtraHeight()
        
//        headerView.bounds.size.height += extraHeight
        tableView.tableHeaderView = headerView
        
    }
    
    // MARK: - delegate functions
    
    func shouldRefresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view functions
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 15, y: 10, width: UIScreen.main.bounds.size.width, height: 30))
        label.text = "Products"
        label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.bold)
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.count > 0 {
            tableView.separatorStyle = .singleLine
            return viewModel.count
        } else {
            TableViewHelper.EmptyMessage(message: "Loading...", viewController: self)
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: ProductDetailCell = tableView.dequeueReusableCell(withIdentifier: "collectionDetailCell", for: indexPath) as? ProductDetailCell {
            
            let product = viewModel.products[indexPath.row]
            print("name: \(product.title)")
            cell.setDataFrom(product)
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }


}

