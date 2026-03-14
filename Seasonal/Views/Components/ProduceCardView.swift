import SwiftUI

struct ProduceCardView: View {
    let item: ProduceItem

    private var currentRegion: ProduceRegion {
        SharedDataManager.shared.currentRegion
    }

    private var currentMonth: Int {
        Calendar.current.component(.month, from: Date())
    }

    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .topTrailing) {
                ProduceIconView(item: item, size: 36)

                if item.isPeakSeason(for: currentRegion, month: currentMonth) {
                    Text("Peak")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.orange, in: Capsule())
                        .offset(x: 8, y: -4)
                }
            }

            Text(item.name)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: item.colorHex).opacity(0.12))
        )
    }
}
