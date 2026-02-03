//
//  ContentView.swift
//  JSONParsing
//
//  Created by kaniz fatema on 27/11/24.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ArticleViewModel() // Initialize ViewModel

        var body: some View {
            NavigationView {
                VStack {
                    if viewModel.isLoading {
                                ProgressView("Loading Articles...")
                                     } else if let errorMessage = viewModel.errorMessage {
                                         Text("Error: \(errorMessage)")
                                             .foregroundColor(.red)
                                             .padding()
                                     } else {
                                         List(viewModel.articles) { article in
                                             NavigationLink(destination: ArticleDetailView(article: article)) {
                                                 ArticleRowView(article: article)
                                             }
                                         }
                                         .listStyle(PlainListStyle())
                                     }
                }
                .navigationTitle("Country Infos")
                .onAppear {
                    viewModel.fetchArticles()
                }
            }
        }
    }

    struct ArticleRowView: View {
        let article: CountryElement

        var body: some View {
            HStack {
                if let imageUrl = article.flags.png, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 60, height: 60)
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                }

                VStack(alignment: .leading) {
                    Text(article.name.official)
                        .font(.headline)
                        .lineLimit(2)

                    Text(article.name.common)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }


    struct ArticleDetailView: View {
        let article: CountryElement
        

        var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    if let imageUrl = article.flags.png, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                        } placeholder: {
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                        }
                    }

                    Text(article.name.common)
                        .font(.title)
                        .padding(.top)

//                    Text("By \(article.author ?? "Unknown Author")")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)

//                    Text(article.flags.alt ?? "No description available.")
//                        .padding(.top)

//                    if let url = URL(string: article.url) {
//                        Link("Read more", destination: url)
//                            .padding(.top)
//                            .font(.headline)
//                            .foregroundColor(.blue)
//                    }
                }
                .padding()
            }
            .navigationTitle(article.name.common)
        }
    }
