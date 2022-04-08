//
//  API.swift
//  NewsApp
//
//  Created by Nick Sagan on 07.04.2022.
//

import Foundation

struct API {

    let key = "&apiKey=3694dad9cbc345c3b86afe90fe329cca"
    let featuredNews = "https://newsapi.org/v2/top-headlines?"
    let otherNews = "https://newsapi.org/v2/everything?domains=techcrunch.com&sortBy=popularity"
    let page = "&page="
    
    let localeCountries = Set(["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"])
}
