//
//  NewsCell.swift
//  NewsApp
//
//  Created by Nick Sagan on 07.04.2022.
//

import UIKit
import SnapKit

class NewsCell: UICollectionViewCell {
    
    let newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let newsTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 20)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    let newsDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = .darkGray
        return label
    }()
    
    let newsDate: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    let newsComments: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "✉️ \(Int.random(in: 0...99))"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addCornerRadiusWithShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(contentView)
        contentView.addSubview(newsImage)
        contentView.addSubview(newsTitle)
        contentView.addSubview(newsDescription)
        contentView.addSubview(newsDate)
        contentView.addSubview(newsComments)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        newsImage.translatesAutoresizingMaskIntoConstraints = false
        newsTitle.translatesAutoresizingMaskIntoConstraints = false
        newsDescription.translatesAutoresizingMaskIntoConstraints = false
        newsDate.translatesAutoresizingMaskIntoConstraints = false
        newsComments.translatesAutoresizingMaskIntoConstraints = false

        contentView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        newsImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.height.equalTo(contentView.snp.height)
            make.width.equalTo(newsImage.snp.height)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        newsTitle.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.left.equalTo(newsImage.snp.right).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        newsDescription.snp.makeConstraints { make in
            make.top.equalTo(newsTitle.snp.bottom).offset(6)
            make.left.equalTo(newsImage.snp.right).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        newsDate.snp.makeConstraints { make in
            make.top.equalTo(newsDescription.snp.bottom).offset(6)
            make.left.equalTo(newsImage.snp.right).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
        
        newsComments.snp.makeConstraints { make in
            make.top.equalTo(newsDescription.snp.bottom).offset(6)
            make.left.equalTo(newsDate.snp.right).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    }
    
    func addCornerRadiusWithShadow() {
        self.clipsToBounds = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
    }
}
