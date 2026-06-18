//
//  SearchHistoryStore.swift
//  SearchRepositoryApp
//
//  Created by Sanskruti Shinde on 12/06/26.
//


import Foundation

final class SearchHistoryStore {
    private let key = "search_history"

    func load() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }

    func save(_ term: String) {
        var items = load()
        items.removeAll{ $0 == term}
        items.insert(term, at: 0)
        UserDefaults.standard.set(Array(items.prefix(10)), forKey: key)
        
    }
}

