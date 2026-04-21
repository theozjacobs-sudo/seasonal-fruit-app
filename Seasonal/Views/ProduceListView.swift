import SwiftUI

struct ProduceListView: View {
    @EnvironmentObject var locationService: LocationService
    @ObservedObject private var favorites = FavoritesManager.shared
    @State private var selectedCategory: ProduceCategory? = nil
    @State private var searchText = ""
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())

    private var currentRegion: ProduceRegion {
        SharedDataManager.shared.currentRegion
    }

    private var isCurrentMonth: Bool {
        selectedMonth == Calendar.current.component(.month, from: Date())
    }

    // MARK: - Filtered items

    private var allInSeason: [ProduceItem] {
        SeasonalData.shared.inSeason(for: currentRegion, month: selectedMonth)
    }

    private var inSeasonItems: [ProduceItem] {
        allInSeason
            .filter { item in
                if let cat = selectedCategory { return item.category == cat }
                return true
            }
            .filter { item in
                searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)
            }
    }

    private var favoriteInSeason: [ProduceItem] {
        inSeasonItems.filter { favorites.isFavorite($0.id) }
    }

    private var nonFavoriteInSeason: [ProduceItem] {
        inSeasonItems.filter { !favorites.isFavorite($0.id) }
    }

    private var comingSoonItems: [ProduceItem] {
        SeasonalData.shared.comingSoon(for: currentRegion, month: selectedMonth)
    }

    /// When searching, also show items NOT in season that match the query
    private var outOfSeasonResults: [ProduceItem] {
        guard !searchText.isEmpty else { return [] }
        let inSeasonIDs = Set(allInSeason.map(\.id))
        return SeasonalData.shared.allProduce
            .filter { !inSeasonIDs.contains($0.id) }
            .filter { item in
                if let cat = selectedCategory { return item.category == cat }
                return true
            }
            .filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedMonth.monthName)
                        .font(.largeTitle.bold())
                    HStack(spacing: 6) {
                        Text(currentRegion.flag)
                        Text(currentRegion.displayName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)

                // Month selector
                monthSelector

                // Category filter
                Picker("Category", selection: $selectedCategory) {
                    Text("All").tag(nil as ProduceCategory?)
                    Text("Fruits").tag(ProduceCategory.fruit as ProduceCategory?)
                    Text("Vegetables").tag(ProduceCategory.vegetable as ProduceCategory?)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if inSeasonItems.isEmpty && outOfSeasonResults.isEmpty {
                    ContentUnavailableView(
                        "Nothing Found",
                        systemImage: "leaf.fill",
                        description: Text("No produce matches your search.")
                    )
                    .padding(.top, 40)
                } else {
                    // Favorites section
                    if !favoriteInSeason.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Favorites", systemImage: "heart.fill")
                                .font(.headline)
                                .foregroundStyle(.red)
                                .padding(.horizontal)

                            produceGrid(items: favoriteInSeason)
                        }

                        if !nonFavoriteInSeason.isEmpty {
                            Label("All In Season", systemImage: "leaf.fill")
                                .font(.headline)
                                .padding(.horizontal)
                        }
                    }

                    // Main in-season grid
                    if !nonFavoriteInSeason.isEmpty {
                        produceGrid(items: nonFavoriteInSeason)
                    }

                    // Out-of-season search results
                    if !outOfSeasonResults.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Not In Season", systemImage: "moon.zzz.fill")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)

                            produceGrid(items: outOfSeasonResults, dimmed: true)
                        }
                    }
                }

                // Coming Soon
                if !comingSoonItems.isEmpty && searchText.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Coming Next Month")
                            .font(.headline)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(comingSoonItems) { item in
                                    ComingSoonChip(item: item)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .padding(.top, 8)
        }
        .searchable(text: $searchText, prompt: "Search all produce")
        .navigationDestination(for: ProduceItem.self) { item in
            ProduceDetailView(item: item)
        }
        .navigationTitle("Seasonal")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Month Selector

    private var monthSelector: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach([1,2,3,4,5,6,7,8,9,10,11,12], id: \.self) { (mo: Int) in
                        let isSelected = mo == selectedMonth
                        let isToday = mo == Calendar.current.component(.month, from: Date())

                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedMonth = mo
                            }
                        } label: {
                            VStack(spacing: 2) {
                                Text(mo.shortMonthName)
                                    .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                if isToday {
                                    Circle()
                                        .fill(isSelected ? .white : .accentColor)
                                        .frame(width: 4, height: 4)
                                } else {
                                    Circle()
                                        .fill(.clear)
                                        .frame(width: 4, height: 4)
                                }
                            }
                            .foregroundStyle(isSelected ? .white : .primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background {
                                if isSelected {
                                    Capsule().fill(Color.accentColor)
                                } else {
                                    Capsule().fill(.gray.opacity(0.1))
                                }
                            }
                        }
                        .id(mo)
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                proxy.scrollTo(selectedMonth, anchor: .center)
            }
        }
    }

    // MARK: - Grid Helper

    private func produceGrid(items: [ProduceItem], dimmed: Bool = false) -> some View {
        LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 100), spacing: 12)
        ], spacing: 12) {
            ForEach(items) { item in
                NavigationLink(value: item) {
                    ProduceCardView(item: item, month: selectedMonth)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
        .opacity(dimmed ? 0.5 : 1.0)
    }
}
