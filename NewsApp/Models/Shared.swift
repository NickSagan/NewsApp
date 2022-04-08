//
//  NewsData.swift
//  NewsApp
//
//  Created by Nick Sagan on 08.04.2022.
//

import Foundation

class Shared {
    
    static let instance = Shared()
    private init() { }
    
    var featuredNews: [News] = []
    var otherNews: [News] = []
    var page: Int = 1
}
