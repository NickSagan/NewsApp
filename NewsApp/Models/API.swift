//
//  API.swift
//  NewsApp
//
//  Created by Nick Sagan on 07.04.2022.
//

import Foundation

struct API {

    let key = "&apiKey=21dfefbac30f4339a2f5c9d5df6f4b98"
    let featuredNews = "https://newsapi.org/v2/top-headlines?"
    let otherNews = "https://newsapi.org/v2/everything?domains=techcrunch.com&language=en&sortBy=publishedAt"
    let page = "&page="
    
    let localeCountries = Set(["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"])
}
