//
//  SearchView.swift
//  SearchRepositoryApp
//
//  Created by Sanskruti Shinde on 12/06/26.
//


import SwiftUI

struct SearchView: View {
    
    @State private var vm = SearchViewModel()
    @State private var query = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField(
                        "Search repositories...",
                        text: $query
                    )
                    .submitLabel(.search)
                    .onSubmit {
                        vm.search(query)
                    }
                    if !query.isEmpty {
                        Button {
                            query = ""
                        } label: {
                            Image(systemName:"xmark.circle.fill").foregroundStyle(.secondary)
                        }
                    }
                }.padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                if vm.isLoading {
                    Spacer()
                    ProgressView("Searching...").controlSize(.large)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading,spacing: 20) {
                            // Recent Searches
                            if !vm.history.isEmpty {
                                Text("Recent Searches")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal)
                                ForEach(vm.history,id: \.self) { item in
                                    Button {
                                        query = item
                                        vm.search(item)
                                    } label: {
                                        Text(item).frame(maxWidth: .infinity,alignment: .leading).padding(.horizontal)
                                    }
                                    Divider()
                                }
                            }
                            // Repositories
                            if !vm.repositories.isEmpty {
                                Text("Repositories")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal)
                                ForEach(vm.repositories) { repo in
                                    NavigationLink {RepositoryDetailView(repository: repo)} label: {
                                        HStack(alignment: .top,spacing: 12) {
                                            AsyncImage(url: URL(string:repo.owner.avatarURL)) { image in
                                                image.resizable().scaledToFill()} placeholder: {
                                                    ProgressView()
                                                }.frame(width: 50,height: 50)
                                                    .clipShape(Circle())
                                                        VStack(alignment: .leading,spacing: 8) {
                                                    Text(repo.name).font(.headline).foregroundStyle(.primary)
                                                    Text(repo.description ?? "No Description")
                                                        .font(.caption)
                                                        .foregroundStyle(.secondary)
                                                        .lineLimit(2)
                                                    HStack {
                                                        Label("\(repo.stargazersCount)",systemImage:"star.fill" )
                                                        Spacer()
                                                        Text(repo.language ?? "Unknown" )
                                                    }
                                                    .font(.caption)
                                                }
                                                        Image(systemName:"chevron.right")
                                                    .foregroundStyle(.secondary)
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    // Pagination Trigger
                                    Color.clear
                                        .frame(height: 1)
                                        .onAppear {
                                            if repo.id ==
                                                vm.repositories.last?.id {
                                                Task {
                                                    await vm.loadMore()
                                                }
                                            }
                                        }
                                }
                            }
                            
                            // Empty State
                            if vm.repositories.isEmpty &&
                                query.isEmpty {
                                ContentUnavailableView(
                                    "Search Repositories",
                                    systemImage:
                                        "magnifyingglass",
                                    description:
                                        Text(
                                            "Search GitHub repositories to discover open-source projects."
                                        )
                                )
                                .padding(.top, 100)
                            }
                        }
                        .padding(.bottom)
                    }
                    .refreshable {
                        await vm.refresh()
                    }
                }
            }
            .navigationTitle("RepoExplorer")
            .alert(
                "Error",
                isPresented: Binding(
                    get: {
                        vm.errorMessage != nil
                    },
                    set: { _ in
                        vm.errorMessage = nil
                    }
                )) {
                    Button("OK") { }
                } message: {
                    Text(
                        vm.errorMessage ?? ""
                    )
                }
        }
    }
}

#Preview {
    SearchView()
}
