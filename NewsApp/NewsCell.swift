//
//  NewsCell.swift
//  NewsApp
//
//  Created by Nick Sagan on 07.04.2022.
//

import UIKit
import SnapKit

class NewsCell: UICollectionViewCell {
    
    let background: UIImageView = {
        let imgView = UIImageView()
        //imgView.image = UIImage(named: "newsbg")
        return imgView
    }()
    
    let newsImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.layer.cornerRadius = 10
        imgView.backgroundColor = .systemRed // ONLY FOR TEST
        return imgView
    }()
    
    let newsTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 20)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 2
        label.text = "This is a news title label This is a news title label" // ONLY FOR TEST
        return label
    }()
    
    let newsDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = .darkGray
        label.text = "This is a news description label This is a news description label This is a news description label This is a news description label" // ONLY FOR TEST
        return label
    }()
    
    let newsDate: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "April 07, 2022" // ONLY FOR TEST
        return label
    }()
    
    let newsComments: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "cmnts: 0" // ONLY FOR TEST
        return label
    }()
    
    let newsAgency: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "CNN" // ONLY FOR TEST
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(background)
        background.addSubview(newsImage)
        background.addSubview(newsTitle)
        background.addSubview(newsDescription)
        background.addSubview(newsDate)
        background.addSubview(newsComments)
        background.addSubview(newsAgency)
        
        background.translatesAutoresizingMaskIntoConstraints = false
        newsImage.translatesAutoresizingMaskIntoConstraints = false
        newsTitle.translatesAutoresizingMaskIntoConstraints = false
        newsDescription.translatesAutoresizingMaskIntoConstraints = false
        newsDate.translatesAutoresizingMaskIntoConstraints = false
        newsComments.translatesAutoresizingMaskIntoConstraints = false
        newsAgency.translatesAutoresizingMaskIntoConstraints = false

        background.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        newsImage.snp.makeConstraints { make in
            make.top.equalTo(background.snp.top).offset(8)
            make.left.equalTo(background.snp.left)
            make.height.equalTo(background.snp.height).offset(-16)
            make.width.equalTo(newsImage.snp.height)
            make.bottom.equalTo(background.snp.bottom).offset(-8)
        }
        
        newsTitle.snp.makeConstraints { make in
            make.top.equalTo(background.snp.top).offset(10)
            make.left.equalTo(newsImage.snp.right).offset(10)
            make.right.equalTo(background.snp.right).offset(-10)
        }
        
        newsDescription.snp.makeConstraints { make in
            make.top.equalTo(newsTitle.snp.bottom).offset(6)
            make.left.equalTo(newsImage.snp.right).offset(10)
            make.right.equalTo(background.snp.right).offset(-10)
        }
        
        newsDate.snp.makeConstraints { make in
            make.top.equalTo(newsDescription.snp.bottom).offset(6)
            make.left.equalTo(newsImage.snp.right).offset(10)
            make.bottom.equalTo(background.snp.bottom).offset(-10)
        }
        
        newsComments.snp.makeConstraints { make in
            make.top.equalTo(newsDescription.snp.bottom).offset(6)
            make.left.equalTo(newsDate.snp.right).offset(10)
            make.bottom.equalTo(background.snp.bottom).offset(-10)
        }
        
        newsAgency.snp.makeConstraints { make in
            make.top.equalTo(newsDescription.snp.bottom).offset(6)
            make.left.equalTo(newsComments.snp.right).offset(10)
            make.bottom.equalTo(background.snp.bottom).offset(-10)
            make.right.greaterThanOrEqualTo(background.snp.right).offset(-10).priority(90)
        }
    }
    
    func addShadow() {
        self.clipsToBounds = false
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.2
    }
}