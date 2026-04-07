import SwiftUI

struct RightPanelView: View {
    private let background = Color(red: 0.14, green: 0.14, blue: 0.15)
    private let cardBackground = Color(red: 0.17, green: 0.17, blue: 0.18)
    private let accent = Color(red: 0.72, green: 0.74, blue: 0.78)
    private let muted = Color(red: 0.58, green: 0.60, blue: 0.64)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            section(
                title: "Token Usage",
                body: [
                    "Phase 1 placeholder for context and spend tracking.",
                    "Live totals will appear here in a later phase.",
                ]
            )

            section(
                title: "사용중 ports",
                body: [
                    "Reserved for active local port discovery.",
                    "This panel will later show service names and listeners.",
                ]
            )

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(background)
    }

    private func section(title: String, body: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(accent)

            VStack(alignment: .leading, spacing: 6) {
                ForEach(body, id: \.self) { line in
                    Text(line)
                        .font(.subheadline)
                        .foregroundStyle(muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

