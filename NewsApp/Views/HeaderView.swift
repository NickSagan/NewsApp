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
        label.font = UIFont(name: "Verdana", size: 22)
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.text = "IPhone News App"
        return label
    }()
    
    let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchBarStyle = .minimal
        search.barTintColor = .systemBlue
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

        background.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        appTitle.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(background.snp.width).multipliedBy(0.55)
            make.leading.equalTo(background.snp.leading).offset(10)
            make.top.equalTo(background.snp.top)
            make.bottom.equalTo(background.snp.bottom).offset(-5)
        }
        
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(background.snp.width).multipliedBy(0.40)
            make.trailing.equalTo(background.snp.trailing).offset(-5)
            make.top.equalTo(background.snp.top)
            make.bottom.equalTo(background.snp.bottom).offset(-5)
        }
    }
}
