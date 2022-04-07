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
        imgView.image = UIImage(named: "newsbg")
        return imgView
    }()
    
    let newsImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let newsTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 18)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.frame.size.height = 100
        label.frame.size.width = 150
        label.textColor = .black
        return label
    }()
    
    let newsDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 18)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.frame.size.height = 100
        label.frame.size.width = 150
        label.textColor = .black
        return label
    }()
    
    let newsDate: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 18)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.frame.size.height = 100
        label.frame.size.width = 150
        label.textColor = .black
        return label
    }()
    
    let newsComments: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 18)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.frame.size.height = 100
        label.frame.size.width = 150
        label.textColor = .black
        return label
    }()
    
    let newsAgency: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 18)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.frame.size.height = 100
        label.frame.size.width = 150
        label.textColor = .black
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
            make.top.equalTo(background.snp.top)
            make.left.equalTo(background.snp.left)
            make.height.equalTo(background.snp.height)
            make.width.equalTo(newsImage.snp.height)
            make.bottom.equalTo(background.snp.bottom)
        }
        
    }
}
