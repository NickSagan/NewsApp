//
//  FeaturedNewsView.swift
//  NewsApp
//
//  Created by Nick Sagan on 07.04.2022.
//

import UIKit
import SnapKit

class FeaturedNewsView: UICollectionReusableView {
    
    let newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let newsTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 24)
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.numberOfLines = 2
        label.text = ""
        return label
    }()
    
    let newsDate: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.text = ""
        return label
    }()
    
    let newsComments: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.text = "✉️ \(Int.random(in: 0...99))"
        return label
    }()
    
    let newsAgency: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.text = ""
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(newsImage)
        newsImage.addSubview(newsTitle)
        newsImage.addSubview(newsDate)
        newsImage.addSubview(newsComments)
        newsImage.addSubview(newsAgency)
        

        newsImage.translatesAutoresizingMaskIntoConstraints = false
        newsTitle.translatesAutoresizingMaskIntoConstraints = false
        newsDate.translatesAutoresizingMaskIntoConstraints = false
        newsComments.translatesAutoresizingMaskIntoConstraints = false
        newsAgency.translatesAutoresizingMaskIntoConstraints = false

        newsImage.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        newsTitle.snp.makeConstraints { make in
            make.left.equalTo(newsImage.snp.left).offset(10)
            make.right.equalTo(newsImage.snp.right).offset(-10)
            make.bottom.equalTo(newsDate.snp.top).offset(-10)
        }
        
        newsDate.snp.makeConstraints { make in
            make.left.equalTo(newsImage.snp.left).offset(10)
            make.bottom.equalTo(newsImage.snp.bottom).offset(-10)
        }
        
        newsComments.snp.makeConstraints { make in
            make.left.equalTo(newsDate.snp.right).offset(10)
            make.bottom.equalTo(newsImage.snp.bottom).offset(-10)
        }
        
        newsAgency.snp.makeConstraints { make in
            make.left.equalTo(newsComments.snp.right).offset(10)
            make.bottom.equalTo(newsImage.snp.bottom).offset(-10)
            make.right.greaterThanOrEqualTo(newsImage.snp.right).offset(-10).priority(90)
        }
    }
}
