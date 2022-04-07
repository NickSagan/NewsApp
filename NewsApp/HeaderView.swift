//
//  HeaderView.swift
//  NewsApp
//
//  Created by Nick Sagan on 07.04.2022.
//

import UIKit
import SnapKit

class HeaderView: UIView {
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    let appTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 24)
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.text = "IPhone News App"
        return label
    }()
    
    let searchBar: UISearchBar = {
        let search = UISearchBar()
        return search
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(background)
        background.addSubview(appTitle)
        background.addSubview(searchBar)
        
        background.translatesAutoresizingMaskIntoConstraints = false
        appTitle.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        

    }
}
