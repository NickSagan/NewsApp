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
    let api = API()
    
    func fetchFeaturedNews(refresh: Bool = false) {
        let urlString = api.featuredNews + getCountry() + api.key
        performRequest(with: urlString, newsType: .featuredNews, refresh: refresh)
    }
    
    func fetchOtherNews(page num: Int, refresh: Bool = false) {
        let urlString = api.otherNews + api.page + "\(num)" + api.key
        performRequest(with: urlString, newsType: .otherNews, refresh: refresh)
    }
    
    private func performRequest(with urlString: String, newsType: NewsType, refresh: Bool = false) {
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                let date = data,
                let news = try? self.parseJSON(date)
            else {
                print("Request fail: \(String(describing: error))");
                return
            }
            
            switch newsType {
            case .featuredNews:
                if refresh {
                    Shared.instance.featuredNews = news
                } else {
                    Shared.instance.featuredNews += news
                }
                self.delegate?.didRecieveFeaturedNews(self, news: news)
            case .otherNews:
                if refresh {
                    Shared.instance.otherNews = news
                } else {
                    Shared.instance.otherNews += news
                }
                self.delegate?.didRecieveOtherNews(self, news: news)
            }
        }

        task.resume()
    }
    
    private func parseJSON(_ safeData: Data) throws -> [News] {
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(Welcome.self, from: safeData)
        var news = [News]()

        for item in decodedData.articles {
            let title = item.title ?? "No title"
            let description = item.description ?? "No decription"
            let url = item.url ?? ""
            let urlToImage = item.urlToImage ?? ""
            let publishedAt = item.publishedAt ?? ""

            let article = News(
                source: item.source.name ?? "No source",
                title: title,
                description: description,
                url: url,
                urlToImage: urlToImage,
                publishedAt: getDate(from: publishedAt)
            )
            
            news.append(article)
        }

        return news
    }
    
    private func getCountry() -> String {
        let locale = Locale.current
        var country = "us"

        if let locale = locale.languageCode, api.localeCountries.contains(locale) {
            country = locale
        } else if let locale = locale.regionCode?.lowercased(), api.localeCountries.contains(locale) {
            country = locale
        }
        return "country=\(country)"
    }

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
            return "No date"
        }
    }
}
