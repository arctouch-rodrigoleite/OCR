//
//  MenuViewController.swift
//  OCR
//
//  Created by Rodrigo Leite on 8/8/18.
//  Copyright © 2018 Rodrigo Leite. All rights reserved.
//

import UIKit
import Stevia

class MenuViewController: UIViewController {

    // MARK: - Variables
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    var options = ["Google Vision", "Google Vision Photo"]
    var selectedOption: String?
    
    // MARK: - Vc Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    // MARK: - Setup View
    func setupView() {
        view.sv(tableView)
        tableView.top(60).left(0).right(0).bottom(0)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? GoogleVisionViewController {
            destinationViewController.title = selectedOption
        }
        if let destinationViewController = segue.destination as? GoogleVisionPhotoViewController {
            destinationViewController.title = selectedOption
        }
    }

}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = options[indexPath.row]
        selectedOption = option
        switch indexPath.row {
        case 0: performSegue(withIdentifier: "goToGoogleVision", sender: nil)
        case 1: performSegue(withIdentifier: "goToGoogleVisionPhoto", sender: nil)
        default: break
        }
        
    }
    
}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath)
        let option = options[indexPath.row]
        cell.textLabel?.text = option
        return cell
    }
    
}

class MenuTableViewCell: UITableViewCell {

    static let identifier = "MenuTableViewCell"
    override var reuseIdentifier: String? {
        return MenuTableViewCell.identifier
    }
    
}

