//
//  RepositoryDetailView.swift
//  SearchRepositoryApp
//
//  Created by Sanskruti Shinde on 12/06/26.
//

import SwiftUI

struct RepositoryDetailView: View {

    let repository: Repository

    var body: some View {
        ScrollView {
            VStack(alignment: .leading,spacing: 20) {
                AsyncImage(url: URL(string:repository.owner.avatarURL)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())

                Text(repository.name)
                    .font(.largeTitle)
                    .bold()

                Text(repository.description ?? "No description available")
                HStack {
                    StatView(title: "Stars",value:"\(repository.stargazersCount)")

                    StatView(title: "Forks",value:"\(repository.forksCount)")

                    StatView(title: "Issues",value:"\(repository.openIssuesCount)")
                }
                Divider()
                Text("Language: \(repository.language ?? "Unknown")")

                Text("Owner: \(repository.owner.login)")

                Link("Open on GitHub",destination:URL( string:repository.htmlURL)!)
            }.padding()
        }.navigationTitle("Repository")
    }
}

struct StatView: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .bold()
            Text(title)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
    }
}
