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
        //label.numberOfLines = 2
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
        label.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
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
        let detailsWrapper = UIStackView(arrangedSubviews: [
            newsDate, newsComments
        ])
        detailsWrapper.axis = .horizontal
        detailsWrapper.alignment = .leading
        detailsWrapper.spacing = 6

        let contentWrapper = UIStackView(arrangedSubviews: [
            newsTitle, newsDescription, detailsWrapper
        ])
        contentWrapper.axis = .vertical
        contentWrapper.spacing = 6

        let wrapper = UIStackView(arrangedSubviews: [
            newsImage, contentWrapper
        ])
        wrapper.alignment = .center
        wrapper.axis = .horizontal
        wrapper.spacing = 10

        contentView.addSubview(wrapper)

        newsImage.snp.makeConstraints { make in
            make.height.width.equalTo(wrapper.snp.height)
        }

        wrapper.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().inset(10)
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
