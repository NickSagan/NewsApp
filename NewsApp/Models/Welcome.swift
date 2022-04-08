//
//  Articles.swift
//  NewsApp
//
//  Created by Nick Sagan on 07.04.2022.
//

import Foundation

struct Welcome: Codable {
    let articles: [Article]
    let totalResults: Int
}

struct Article: Codable {
    let source: Source
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}

struct Source: Codable {
    let name: String?
}
