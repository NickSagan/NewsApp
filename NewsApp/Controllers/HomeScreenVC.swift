//
//  HomeScreenVC.swift
//  NewsApp
//
//  Created by Nick Sagan on 06.04.2022.
//

import UIKit

class HomeScreenVC: UIViewController {
    
    private var headerView: HeaderView!
    private var featuredNewsView: FeaturedNewsView!
    private var newsFeedView: UIView!
    private var collectionView: UICollectionView!
    private var refreshControl: UIRefreshControl!
    
    var newsFeedManager = NewsFeedManager()
    var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        addHeaderView()
        addFeaturedNewsView()
        addNewsFeedView()
        setConstraints()
        addCollectionView()
        
        newsFeedManager.delegate = self
        newsFeedManager.fetchFeaturedNews()
    }
    
    func addHeaderView() {
        headerView = HeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(headerView)
    }
    
    func addFeaturedNewsView() {
        featuredNewsView = FeaturedNewsView()
        featuredNewsView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(featuredNewsView)
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
        
        featuredNewsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
        
        newsFeedView.snp.makeConstraints { make in
            make.top.equalTo(featuredNewsView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func addCollectionView() {
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: setLayout())
        newsFeedView.addSubview(collectionView)

        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(NewsCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
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
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsCell
        cell.newsTitle.text = news[indexPath.row].title
        cell.newsDescription.text = news[indexPath.row].description
        cell.newsDate.text = news[indexPath.row].publishedAt
        cell.newsAgency.text = news[indexPath.row].source
        
        guard let imageUrl = URL(string: news[indexPath.row].urlToImage) else { return cell }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else {return}
                cell.newsImage.image = image
            }
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension HomeScreenVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeScreenVC: NewsFeedManagerDelegate {
    func didRecieveNews(_ newsFeedManager: NewsFeedManager, news: [News]) {
        DispatchQueue.main.async {
            self.news = news
            self.collectionView.reloadData()
        }
    }
}
