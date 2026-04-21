import SwiftUI

struct SeasonCalendarView: View {
    let activeMonths: [Int]
    var accentColor: Color = .green

    private let currentMonth = Calendar.current.component(.month, from: Date())

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...12, id: \.self) { month in
                VStack(spacing: 4) {
                    Text(month.shortMonthName)
                        .font(.system(size: 9))
                        .foregroundStyle(.secondary)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(activeMonths.contains(month) ? accentColor : Color.gray.opacity(0.2))
                        .frame(height: 24)
                        .overlay {
                            if month == currentMonth {
                                RoundedRectangle(cornerRadius: 4)
                                    .strokeBorder(.primary, lineWidth: 2)
                            }
                        }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
