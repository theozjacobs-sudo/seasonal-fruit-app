import SwiftUI

struct ComingSoonChip: View {
    let item: ProduceItem

    var body: some View {
        HStack(spacing: 6) {
            ProduceIconView(item: item, size: 20)
            Text(item.name)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color(hex: item.colorHex).opacity(0.12))
        )
    }
}
