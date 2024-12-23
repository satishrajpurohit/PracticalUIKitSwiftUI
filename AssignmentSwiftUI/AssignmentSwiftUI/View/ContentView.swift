//
//  ContentView.swift
//  AssignmentSwiftUI
//
//  Created by Satish Rajpurohit on 23/12/24.
//

import SwiftUI

// MARK: - ContentView
struct ContentView: View {
    @State private var searchText = ""
    @StateObject private var catViewModel = CatViewModel()
    @State private var isPresented = false
    @State private var currentCatPagerIndex: Int = 0
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                    HorizontalCatPagerView(currentCatPagerIndex: $currentCatPagerIndex ,searchText: $searchText, catImages: catViewModel.catImages)
                        .frame(width: UIScreen.main.bounds.width - 32 ,height: 270)
                        .onChange(of: searchText) { oldValue, newValue in
                            catViewModel.searchBreeds(searchValue: newValue)
                        }
                        .onChange(of: currentCatPagerIndex) { oldIndex, newIndex in
                            catViewModel.fetchCatBreeds(selectedBreedPage: newIndex)
                            searchText = ""
                        }
                    Section {
                        ListOfCat(filteredBreeds: catViewModel.filteredBreeds, searchQuery: searchText)
                    } header: {
                        StickySearchBar(searchText: $searchText)
                    }
                }
            }
            .font(.title2)
            .padding()
            .task {
                ReachabilityManager.shared.setReachabilityHandler { isConnected in
                    catViewModel.fetchCatImages()
                    catViewModel.fetchCatBreeds()
                }
            }
            
            FloatingButton {
                isPresented.toggle()
            }
            .sheet(isPresented: $isPresented) {
                StatisticView(visibleBreeds: catViewModel.filteredBreeds)
            }
        }
    }
}

// MARK: - StickySearchBar
/// A search bar component that remains sticky at the top
struct StickySearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            TextField("Search...", text: $searchText)
                .font(.title3)
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                .background(Color.white)
        }
    }
}

// MARK: - HorizontalCatPagerView
/// A view that displays a horizontally scrollable pager of cat images
struct HorizontalCatPagerView: View {
    @Binding var currentCatPagerIndex: Int
    @Binding var searchText: String
    var catImages: [CatImage]
    
    var body: some View {
        TabView(selection: $currentCatPagerIndex) {
            ForEach(catImages) { catImage in
                VStack {
                    AsyncImage(url: URL(string: catImage.url)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 100, height: 100)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width - 34, height: 200)
                                .cornerRadius(10)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo.fill")
                                .frame(width: UIScreen.main.bounds.width - 32, height: 200)
                                .cornerRadius(10)
                                .padding()
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(catImages.firstIndex(where: { $0.id == catImage.id }) ?? 0)
            }
        }
        .onAppear() {
            UIPageControl.appearance().currentPageIndicatorTintColor = .blue
            UIPageControl.appearance().pageIndicatorTintColor = .gray
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(maxHeight: .infinity)
    }
}

// MARK: - ListOfCat
/// A view displaying a list of cat breeds with optional filtering by search query
struct ListOfCat: View {
    var filteredBreeds: [CatBreed]
    var searchQuery: String
    var body: some View {
        LazyVStack {
            // List of Cat Breeds
            ForEach(filteredBreeds) { breed in
                
                HStack {
                    // Display cat image if it exists
                    if let imageUrl = breed.image?.url, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(4)
                            case .failure:
                                Image(systemName: "photo.fill")
                                    .frame(width: 100, height: 100)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "photo.fill")
                            .frame(width: 100, height: 100)
                    }
                    
                    // Display breed name and description
                    VStack(alignment: .leading) {
                        Text(breed.name)
                            .font(.headline)
                        Text(breed.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 10)
                }
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 4))
            }
        }
        
    }
}
