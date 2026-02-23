import SwiftUI

struct ProduceCardView: View {
    let item: ProduceItem

    var body: some View {
        VStack(spacing: 6) {
            Text(item.emoji)
                .font(.system(size: 36))
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
