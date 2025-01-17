//
//  HomeViewController.swift
//  Owler
//
//  Created by Álvaro Perera on 17/1/25.
//
import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
}
