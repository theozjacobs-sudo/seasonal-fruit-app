import SwiftUI

struct ProduceIconView: View {
    let item: ProduceItem
    var size: CGFloat = 40

    var body: some View {
        if let asset = item.iconAsset, UIImage(named: asset) != nil {
            Image(asset)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
        } else {
            Text(item.emoji)
                .font(.system(size: size * 0.8))
        }
    }
}
