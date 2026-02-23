import SwiftUI

struct ProduceListView: View {
    @EnvironmentObject var locationService: LocationService
    @State private var selectedCategory: ProduceCategory? = nil
    @State private var searchText = ""

    private var currentRegion: ProduceRegion {
        SharedDataManager.shared.currentRegion
    }

    private var currentMonth: Int {
        Calendar.current.component(.month, from: Date())
    }

    private var inSeasonItems: [ProduceItem] {
        SeasonalData.shared.inSeason(for: currentRegion, month: currentMonth)
            .filter { item in
                if let cat = selectedCategory { return item.category == cat }
                return true
            }
            .filter { item in
                searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)
            }
    }

    private var comingSoonItems: [ProduceItem] {
        SeasonalData.shared.comingSoon(for: currentRegion, month: currentMonth)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentMonth.monthName)
                        .font(.largeTitle.bold())
                    HStack(spacing: 6) {
                        Text(currentRegion.flag)
                        Text(currentRegion.displayName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)

                // Category filter
                Picker("Category", selection: $selectedCategory) {
                    Text("All").tag(nil as ProduceCategory?)
                    Text("Fruits").tag(ProduceCategory.fruit as ProduceCategory?)
                    Text("Vegetables").tag(ProduceCategory.vegetable as ProduceCategory?)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // In Season grid
                if inSeasonItems.isEmpty {
                    ContentUnavailableView(
                        "Nothing Found",
                        systemImage: "leaf.fill",
                        description: Text("No produce matches your search.")
                    )
                    .padding(.top, 40)
                } else {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 100), spacing: 12)
                    ], spacing: 12) {
                        ForEach(inSeasonItems) { item in
                            NavigationLink(value: item) {
                                ProduceCardView(item: item)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }

                // Coming Soon
                if !comingSoonItems.isEmpty {
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
        .searchable(text: $searchText, prompt: "Search produce")
        .navigationDestination(for: ProduceItem.self) { item in
            ProduceDetailView(item: item)
        }
        .navigationTitle("Seasonal")
        .navigationBarTitleDisplayMode(.inline)
    }
}
