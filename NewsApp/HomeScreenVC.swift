//
//  HomeScreenVC.swift
//  NewsApp
//
//  Created by Nick Sagan on 06.04.2022.
//

import UIKit

class HomeScreenVC: UIViewController {

    private var refreshControl: UIRefreshControl!
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    func setupCollectionView() {
        let view = UIView()
        view.backgroundColor = .white
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: setLayout())
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(NewsCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.backgroundColor = UIColor.white
        
        refreshControl = UIRefreshControl()
        collectionView?.refreshControl = refreshControl
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        view.addSubview(collectionView!)
        self.view = view
    }
    
    func setLayout() -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize.width = self.view.frame.width - 10
        layout.itemSize.height = 220
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
        return 1
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