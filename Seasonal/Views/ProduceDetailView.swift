import SwiftUI

struct ProduceDetailView: View {
    let item: ProduceItem
    @State private var isFavorite: Bool = false

    private var currentRegion: ProduceRegion {
        SharedDataManager.shared.currentRegion
    }

    private var currentMonth: Int {
        Calendar.current.component(.month, from: Date())
    }

    private var seasonMonths: [Int] {
        item.seasons
            .first { $0.region == currentRegion.rawValue }?
            .months ?? []
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero
                VStack(spacing: 8) {
                    ProduceIconView(item: item, size: 80)

                    HStack(spacing: 8) {
                        Text(item.name)
                            .font(.largeTitle.bold())

                        if item.isPeakSeason(for: currentRegion, month: currentMonth) {
                            Text("Peak")
                                .font(.caption2.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.orange, in: Capsule())
                        }
                    }

                    Text(item.category.rawValue.capitalized)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial, in: Capsule())
                }
                .padding(.top)

                // Season Calendar
                VStack(alignment: .leading, spacing: 8) {
                    Label("Season Calendar", systemImage: "calendar")
                        .font(.headline)
                    SeasonCalendarView(
                        activeMonths: seasonMonths,
                        accentColor: Color(hex: item.colorHex)
                    )
                }
                .padding(.horizontal)

                // Ripeness Tips
                VStack(alignment: .leading, spacing: 12) {
                    Label("How to Pick a Ripe One", systemImage: "hand.thumbsup.fill")
                        .font(.headline)
                    ForEach(item.ripenessTips, id: \.title) { tip in
                        RipenessTipCard(tip: tip, accentColor: Color(hex: item.colorHex))
                    }
                }
                .padding(.horizontal)

                // Storage Tip
                VStack(alignment: .leading, spacing: 8) {
                    Label("Storage", systemImage: "refrigerator.fill")
                        .font(.headline)
                    Text(item.storageTip)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                // Fun Fact
                VStack(alignment: .leading, spacing: 8) {
                    Label("Did You Know?", systemImage: "lightbulb.fill")
                        .font(.headline)
                    Text(item.funFact)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                // Seasonal Recipes Link
                Button {
                    let query = "seasonal \(item.name) recipes".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    if let url = URL(string: "https://www.google.com/search?q=\(query)") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Label("Find Seasonal Recipes", systemImage: "fork.knife")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: item.colorHex).opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .padding(.horizontal)

                Spacer(minLength: 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isFavorite.toggle()
                    FavoritesManager.shared.toggle(item.id)
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(isFavorite ? .red : .secondary)
                }
            }
        }
        .onAppear {
            isFavorite = FavoritesManager.shared.isFavorite(item.id)
        }
    }
}
