//
//  HomeScreenVC.swift
//  NewsApp
//
//  Created by Nick Sagan on 06.04.2022.
//

import UIKit

class HomeScreenVC: UIViewController {
    
    private var featuredNewsView: FeaturedNewsView!
    private var collectionView: UICollectionView!
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "IPhone News App"
        setFeaturedNewsView()
        setCollectionView()
    }
    
    func setFeaturedNewsView() {
        featuredNewsView = FeaturedNewsView()
        featuredNewsView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(featuredNewsView)
        
        featuredNewsView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.4)
        }
    }
    
    func setCollectionView() {
        let newsFeedView = UIView()
        view.backgroundColor = .white
        newsFeedView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(newsFeedView)
        newsFeedView.snp.makeConstraints { make in
            make.top.equalTo(featuredNewsView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: setLayout())
        newsFeedView.addSubview(collectionView)

        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(NewsCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.backgroundColor = UIColor.white
        
        refreshControl = UIRefreshControl()
        collectionView?.refreshControl = refreshControl
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }
    
    func setLayout() -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize.width = self.view.frame.width - 20
        layout.itemSize.height = self.view.frame.width / 3.5
        return layout
    }
    
    @objc func refresh(_ sender: AnyObject) {
        usleep(UInt32(0.5))
        refreshControl.endRefreshing()
    }
}

//MARK: - UICollectionViewDataSource

extension HomeScreenVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsCell
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension HomeScreenVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
