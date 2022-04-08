//
//  HomeScreenViewController.swift
//  NewsApp
//
//  Created by Nick Sagan on 06.04.2022.
//

import UIKit

private extension UIEdgeInsets {
    static let layoutSectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
}

private extension Double {
    static let collectionCellRatio = 3.5
    static let collectionHeaderRatio = 0.65
}

private extension String {
    static let cell = "cell"
    static let header = "header"
}

class HomeScreenViewController: UIViewController {
    
    private lazy var headerView: HeaderView = {
        return .init()
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collection.delegate = self
        collection.dataSource = self

        collection.register(NewsCell.self, forCellWithReuseIdentifier: .cell)
        collection.register(
            FeaturedNewsView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: .header
        )
        collection.backgroundColor = .white

        collection.refreshControl = .init()
        collection.refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)

        return collection
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()

        layout.sectionInset = .layoutSectionInset
        layout.itemSize.width = view.frame.width - 20
        layout.itemSize.height = view.frame.width / .collectionCellRatio

        return layout
    }()

    var newsFeedManager = NewsFeedManager()
    var cache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        newsFeedManager.delegate = self
        newsFeedManager.fetchFeaturedNews()
        newsFeedManager.fetchOtherNews(page: 1)
 
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        tapGestureReconizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureReconizer)
        
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    @objc
    private func tap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc func refresh(_ sender: AnyObject) {
        Shared.instance.page = 1
        newsFeedManager.fetchFeaturedNews(refresh: true)
        newsFeedManager.fetchOtherNews(page: 1, refresh: true)
        usleep(UInt32(0.5))
        collectionView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Private

    private func setup() {
        view.addSubview(headerView)
        view.addSubview(collectionView)

        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(45)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

//MARK: - UICollectionViewDataSource

extension HomeScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return Shared.instance.otherNews.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let index = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .cell, for: indexPath)

        guard let cell = cell as? NewsCell else { fatalError("Downcasting error. Must be NewsCell") }

        cell.newsTitle.text = Shared.instance.otherNews[index].title
        cell.newsDescription.text = Shared.instance.otherNews[index].description
        cell.newsDate.text = Shared.instance.otherNews[index].publishedAt

        let stringUrl = Shared.instance.otherNews[index].urlToImage
        guard let imageUrl = URL(string: stringUrl) else { return cell }

        if let cachedImage = cache.object(forKey: stringUrl as NSString) {
            cell.newsImage.image = cachedImage
        } else {
            DispatchQueue.global().async {
                guard
                    let data = try? Data(contentsOf: imageUrl),
                    let image = UIImage(data: data)
                else { return }

                self.cache.setObject(image, forKey: stringUrl as NSString)

                DispatchQueue.main.async {
                    cell.newsImage.image = image
                }
            }
        }

        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard
            !Shared.instance.otherNews.isEmpty,
            indexPath.row > Shared.instance.otherNews.count - 10
        else { return }

        Shared.instance.page += 1
        newsFeedManager.fetchOtherNews(page: Shared.instance.page)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        let featuredNews = Shared.instance.featuredNews
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: .header,
            for: indexPath
        )

        guard let header = header as? FeaturedNewsView else { fatalError("Downcasting error. Must be FeaturedNewsView") }

        if featuredNews.isEmpty {
            return header
        }

        header.newsTitle.text = featuredNews[0].title
        header.newsDate.text = featuredNews[0].publishedAt
        header.newsAgency.text = featuredNews[0].source

        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tapHeader))
        tapGestureReconizer.cancelsTouchesInView = false
        header.addGestureRecognizer(tapGestureReconizer)

        let stringUrl = featuredNews[0].urlToImage
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return .init(width: collectionView.frame.width, height: collectionView.frame.width * .collectionHeaderRatio)
    }
}

//MARK: - UICollectionViewDelegate

extension HomeScreenViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = URL(string: Shared.instance.otherNews[indexPath.row].url) else { return }
        
        let viewController = WebViewViewController(url: url)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func tapHeader(sender: UITapGestureRecognizer) {
        guard let url = URL(string: Shared.instance.featuredNews[0].url) else { return }
        
        let viewController = WebViewViewController(url: url)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - NewsFeedManagerDelegate

extension HomeScreenViewController: NewsFeedManagerDelegate {
    
    func didRecieveFeaturedNews(_ newsFeedManager: NewsFeedManager, news: [News]) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func didRecieveOtherNews(_ newsFeedManager: NewsFeedManager, news: [News]) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
