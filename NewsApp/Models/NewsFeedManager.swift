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
    
    func fetchFeaturedNews() {
        let urlString = Shared.instance.featuredNewsUrl + getCountry() + Shared.instance.apiKey
        performRequest(with: urlString, newsType: .featuredNews)
    }
    
    func fetchOtherNews() {
        let urlString = Shared.instance.otherNewsUrl + Shared.instance.apiKey
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
                let publishedAt = item.publishedAt ?? ""
                let displayDate = getDate(from: publishedAt)
                
                let article = News(source: source, title: title, description: description, url: url, urlToImage: urlToImage, publishedAt: displayDate)
                news.append(article)
            }
            return news
        } catch {
            print(error)
            return nil
        }
    }
    
    private func getCountry() -> String {
        var country: String?
        
        if let locale = Locale.current.regionCode {
            let loc = locale.lowercased()
            if Shared.instance.localeCountries.contains(loc) {
                country = locale
            }
        } else if let locale = Locale.current.languageCode {
            if Shared.instance.localeCountries.contains(locale) {
                country = locale
            }
        }
        return "country=\(country ?? "us")"
    }
    
    // https://stackoverflow.com/a/42811162/16935118
    private func getDate(from isoDate: String) -> String {
        // String -> Date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
    
        if let date = dateFormatter.date(from:isoDate) {
            // Date -> local Date -> String
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "🕓 MMMM dd, yyyy"
            return dateFormatter.string(from: date)
        } else {
            return "No date provided"
        }
    }
}