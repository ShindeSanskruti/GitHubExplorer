//
//  Repository.swift
//  SearchRepositoryApp
//
//  Created by Sanskruti Shinde on 12/06/26.
//


import Foundation

struct Repository: Codable, Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let stargazersCount: Int
    let language: String?
    let forksCount: Int
    let openIssuesCount: Int
    let htmlURL: String
    let owner: Owner

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case language
        case owner

        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case htmlURL = "html_url"
    }
}

struct Owner: Codable {
    let login: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}

struct SearchResponse: Codable {
    let items: [Repository]
}
