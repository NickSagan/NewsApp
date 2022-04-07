//
//  NewsFeedManager.swift
//  NewsApp
//
//  Created by Nick Sagan on 07.04.2022.
//

import Foundation

enum NewsType {
    case featuredNews
    case otherNews
}

protocol NewsFeedManagerDelegate {
    func didRecieveFeaturedNews(_ newsFeedManager: NewsFeedManager, news: [News])
    func didRecieveOtherNews(_ newsFeedManager: NewsFeedManager, news: [News])
}

struct NewsFeedManager {
    
    var delegate: NewsFeedManagerDelegate?
    
    private let apiKey = "3694dad9cbc345c3b86afe90fe329cca"
    private let featuredNewsUrl = "https://newsapi.org/v2/top-headlines?country=us&apiKey="
    private let otherNewsUrl = "https://newsapi.org/v2/everything?domains=techcrunch.com&sortBy=popularity&apiKey="
    
    func fetchFeaturedNews() {
        let urlString = featuredNewsUrl + apiKey
        performRequest(with: urlString, newsType: .featuredNews)
    }
    
    func fetchOtherNews() {
        let urlString = otherNewsUrl + apiKey
        performRequest(with: urlString, newsType: .otherNews)
    }
    
    private func performRequest(with urlString: String, newsType: NewsType) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil { print("Request fail: \(String(describing: error))"); return }
            guard let safeData = data else { return }
            guard let news = self.parseJSON(safeData) else { return }
            switch newsType {
            case .featuredNews: self.delegate?.didRecieveFeaturedNews(self, news: news)
            case .otherNews: self.delegate?.didRecieveOtherNews(self, news: news)
            }
        }
        task.resume()
    }
    
    private func parseJSON(_ safeData: Data) -> [News]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Articles.self, from: safeData)
            var news = [News]()
            for item in decodedData.articles {
                
                let source = item.source.name ?? "No source"
                let title = item.title ?? "No title"
                let description = item.description ?? "No decription"
                let url = item.url ?? ""
                let urlToImage = item.urlToImage ?? ""
                let publishedAt = item.publishedAt ?? "No date"
                
                let article = News(source: source, title: title, description: description, url: url, urlToImage: urlToImage, publishedAt: publishedAt)
                news.append(article)
            }
            
            return news
        } catch {
            print(error)
            return nil
        }
    }
}
