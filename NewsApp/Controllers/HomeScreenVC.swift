//
//  HomeScreenVC.swift
//  NewsApp
//
//  Created by Nick Sagan on 06.04.2022.
//

import UIKit

class HomeScreenVC: UIViewController {
    
    private var headerView: HeaderView!
    private var newsFeedView: UIView!
    private var collectionView: UICollectionView!
    private var refreshControl: UIRefreshControl!
    
    var newsFeedManager = NewsFeedManager()
    var featuredNews = [News]()
    var otherNews = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsFeedManager.delegate = self
        navigationController?.isNavigationBarHidden = true
        newsFeedManager.fetchFeaturedNews()
        newsFeedManager.fetchOtherNews()
        addHeaderView()
        addNewsFeedView()
        setConstraints()
        addCollectionView()
    }
    
    func addHeaderView() {
        headerView = HeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(headerView)
    }
    
    func addNewsFeedView() {
        newsFeedView = UIView()
        newsFeedView.backgroundColor = .white
        newsFeedView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(newsFeedView)
    }
    
    func setConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.topMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(45)
        }
        
        newsFeedView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func addCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: setLayout())
        newsFeedView.addSubview(collectionView)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(NewsCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(FeaturedNewsView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
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

extension HomeScreenVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherNews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsCell
        cell.newsTitle.text = otherNews[indexPath.row].title
        cell.newsDescription.text = otherNews[indexPath.row].description
        cell.newsDate.text = otherNews[indexPath.row].publishedAt
        cell.newsAgency.text = otherNews[indexPath.row].source
        
        guard let imageUrl = URL(string: otherNews[indexPath.row].urlToImage) else { return cell }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else {return}
                cell.newsImage.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! FeaturedNewsView
        guard !featuredNews.isEmpty else { return header }
        header.newsTitle.text = featuredNews[0].title
        header.newsDate.text = featuredNews[0].publishedAt
        header.newsAgency.text = featuredNews[0].source
        
        guard let imageUrl = URL(string: featuredNews[0].urlToImage) else { return header }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else {return}
                header.newsImage.image = image
            }
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width * 0.65)
    }
}

//MARK: - UICollectionViewDelegate

extension HomeScreenVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//MARK: - NewsFeedManagerDelegate

extension HomeScreenVC: NewsFeedManagerDelegate {
    func didRecieveFeaturedNews(_ newsFeedManager: NewsFeedManager, news: [News]) {
        DispatchQueue.main.async {
            self.featuredNews = news
            self.collectionView.reloadData()
        }
    }
    
    func didRecieveOtherNews(_ newsFeedManager: NewsFeedManager, news: [News]) {
        DispatchQueue.main.async {
            self.otherNews = news
            self.collectionView.reloadData()
        }
    }
}
