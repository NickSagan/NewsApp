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
    var featuredNews: [News] = []
    var otherNews: [News] = []
    
    var cache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsFeedManager.delegate = self
        newsFeedManager.fetchFeaturedNews()
        newsFeedManager.fetchOtherNews()
        addHeaderView()
        addNewsFeedView()
        setConstraints()
        addCollectionView()
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        tapGestureReconizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureReconizer)
    }
    
    @objc private func tap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
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
        newsFeedManager.fetchFeaturedNews()
        newsFeedManager.fetchOtherNews()
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
        let stringUrl = otherNews[indexPath.row].urlToImage
        
        guard let imageUrl = URL(string: stringUrl) else { return cell }
        
        if let cachedImage = cache.object(forKey: stringUrl as NSString) {
            cell.newsImage.image = cachedImage
        } else {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: imageUrl) else { return }
                DispatchQueue.main.async {
                    guard let fetchedImage = UIImage(data: data) else { return }
                    cell.newsImage.image = fetchedImage
                    self.cache.setObject(fetchedImage, forKey: stringUrl as NSString)
                }
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
        let stringUrl = featuredNews[0].urlToImage
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tapHeader))
        tapGestureReconizer.cancelsTouchesInView = false
        header.addGestureRecognizer(tapGestureReconizer)
        
        guard let imageUrl = URL(string: stringUrl) else { return header }
        
        if let cachedImage = cache.object(forKey: stringUrl as NSString) {
            header.newsImage.image = cachedImage
        } else {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: imageUrl) else { return }
                DispatchQueue.main.async {
                    guard let fetchedImage = UIImage(data: data) else { return }
                    header.newsImage.image = fetchedImage
                    self.cache.setObject(fetchedImage, forKey: stringUrl as NSString)
                }
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
        guard let url = URL(string: otherNews[indexPath.row].url) else { return }
        let vc = WebViewVC()
        vc.selectedSite = url
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func tapHeader(sender: UITapGestureRecognizer) {
        guard let url = URL(string: featuredNews[0].url) else { return }
        let vc = WebViewVC()
        vc.selectedSite = url
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - NewsFeedManagerDelegate

extension HomeScreenVC: NewsFeedManagerDelegate {
    func didRecieveFeaturedNews(_ newsFeedManager: NewsFeedManager, news: [News]) {
        DispatchQueue.main.async {
            self.featuredNews += news
            self.collectionView.reloadData()
            print("Featured news: count = \(self.featuredNews.count)")
        }
    }
    
    func didRecieveOtherNews(_ newsFeedManager: NewsFeedManager, news: [News]) {
        DispatchQueue.main.async {
            self.otherNews += news
            self.collectionView.reloadData()
            print("Other news: count = \(self.otherNews.count)")
        }
    }
}
