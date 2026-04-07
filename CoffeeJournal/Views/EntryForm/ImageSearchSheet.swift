import SwiftUI

struct ImageSearchSheet: View {
    var onSelect: (ImageSearchResult) -> Void

    @State private var query: String = ""
    @State private var results: [ImageSearchResult] = []
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var currentPage = 0
    @State private var hasMore = true

    @Environment(\.dismiss) private var dismiss

    private let searchService: any ImageSearchService = GoogleCustomSearchClient()

    private let columns = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("Search for coffee bag images…", text: $query)
                        .submitLabel(.search)
                        .onSubmit { performSearch(reset: true) }
                    if !query.isEmpty {
                        Button { query = ""; results = [] } label: {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(10)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()

                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 4) {
                        ForEach(results) { result in
                            AsyncImage(url: result.thumbnailURL) { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable().aspectRatio(1, contentMode: .fill)
                                case .empty:
                                    Color.gray.opacity(0.2)
                                case .failure:
                                    Color.gray.opacity(0.3)
                                        .overlay(Image(systemName: "photo").foregroundStyle(.white))
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(height: 110)
                            .clipped()
                            .onTapGesture {
                                onSelect(result)
                                dismiss()
                            }
                        }
                    }
                    .padding(.horizontal, 4)

                    if hasMore && !results.isEmpty {
                        Button("Load More") { performSearch(reset: false) }
                            .buttonStyle(.bordered)
                            .padding()
                    }
                }
                .loadingOverlay(isLoading)
                .overlay {
                    if results.isEmpty && !isLoading && !query.isEmpty {
                        ContentUnavailableView.search(text: query)
                    }
                }
            }
            .navigationTitle("Search Images")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func performSearch(reset: Bool) {
        guard !query.isEmpty else { return }
        if reset {
            currentPage = 0
            results = []
            hasMore = true
        }
        isLoading = true
        errorMessage = nil

        Task {
            defer { isLoading = false }
            do {
                let newResults = try await searchService.search(query: query + " coffee bag", page: currentPage)
                if reset {
                    results = newResults
                } else {
                    results += newResults
                }
                hasMore = newResults.count == 10
                currentPage += 1
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
