import SwiftUI

struct ProduceDetailView: View {
    let item: ProduceItem

    private var currentRegion: ProduceRegion {
        SharedDataManager.shared.currentRegion
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
                    Text(item.emoji)
                        .font(.system(size: 80))
                    Text(item.name)
                        .font(.largeTitle.bold())
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

                Spacer(minLength: 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
