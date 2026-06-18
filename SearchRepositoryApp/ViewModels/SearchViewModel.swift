//
//  SearchViewModel.swift
//  SearchRepositoryApp
//
//  Created by Sanskruti Shinde on 12/06/26.
//


import Foundation
import Observation

@MainActor
@Observable
final class SearchViewModel {
    var repositories: [Repository] = []
    var history: [String] = []
    var isLoading = false
    var errorMessage: String?

    private let service: GitHubServiceProtocol = GitHubService()
    private let store = SearchHistoryStore()

    private var currentQuery = ""
    private var currentPage = 1

    private var searchTask: Task<Void, Never>?

    init() {
        history = store.load()
    }

    func search(_ text: String) {
        searchTask?.cancel()
        searchTask = Task {
            do {
                try Task.checkCancellation()

                await performSearch(text)
            } catch {
                print(error)
            }
        }
    }

    private func performSearch(_ text: String) async {
        guard !text.isEmpty else { return }
        currentQuery = text
        currentPage = 1
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            repositories = try await service.search(query: text,page: currentPage)
            store.save(text)
            history = store.load()
        } catch {
            errorMessage = "Unable to fetch repositories."
        }
    }
    func loadMore() async {
        guard !currentQuery.isEmpty else { return }
        currentPage += 1
        do {
            let newRepos = try await service.search(query: currentQuery,page: currentPage)
            repositories.append(contentsOf: newRepos)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    func refresh() async {
        guard !currentQuery.isEmpty else { return }
        await performSearch(currentQuery)
    }
}
