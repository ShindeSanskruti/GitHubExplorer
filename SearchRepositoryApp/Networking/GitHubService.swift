//
//  GitHubService.swift
//  SearchRepositoryApp
//
//  Created by Sanskruti Shinde on 12/06/26.
//

import Foundation

protocol GitHubServiceProtocol {
    func search(
        query: String,
        page: Int
    ) async throws -> [Repository]
}

final class GitHubService: GitHubServiceProtocol {
   func search(query: String,page: Int) async throws -> [Repository] {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query

        let url = URL(string:"https://api.github.com/search/repositories?q=\(encoded)&page=\(page)&per_page=20")!
        let (data, response) =
            try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        return try decoder
            .decode(SearchResponse.self, from: data)
            .items
    }
}
