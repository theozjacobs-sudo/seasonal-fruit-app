import SwiftUI

struct RipenessTipCard: View {
    let tip: RipenessTip
    var accentColor: Color = .green

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: tip.sfSymbol)
                .font(.title2)
                .foregroundStyle(accentColor)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(tip.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(tip.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}
