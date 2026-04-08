import SwiftUI

struct RightPanelView: View {
    private let background = Color(red: 0.10, green: 0.10, blue: 0.11)
    private let cardBackground = Color(red: 0.14, green: 0.14, blue: 0.15)
    private let cardBorder = Color.white.opacity(0.07)
    private let titleColor = Color.white.opacity(0.88)
    private let muted = Color.white.opacity(0.55)
    private let trackColor = Color.white.opacity(0.10)
    private let contextFill = Color(red: 0.54, green: 0.49, blue: 0.95)
    private let sessionFill = Color(red: 0.31, green: 0.67, blue: 0.52)
    private let livePillFill = Color(red: 0.19, green: 0.36, blue: 0.16)
    private let livePillText = Color(red: 0.65, green: 0.88, blue: 0.57)

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            metricCard(
                title: "TOKEN USAGE",
                content: AnyView(tokenUsageContent)
            )

            metricCard(
                title: "사용중 PORTS",
                content: AnyView(portsContent)
            )

            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(background)
    }

    private func metricCard(title: String, content: AnyView) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(muted)
                .textCase(.uppercase)
                .tracking(0.9)

            content
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(cardBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(cardBorder, lineWidth: 1)
                }
        }
    }

    private var tokenUsageContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            usageRow(label: "context", value: "42%", fill: contextFill, fraction: 0.42)
            usageRow(label: "session", value: "68%", fill: sessionFill, fraction: 0.68)

            Divider()
                .overlay(Color.white.opacity(0.06))

            HStack {
                Text("오늘 비용")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(muted)

                Spacer(minLength: 8)

                Text("$2.14")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(titleColor)
            }
        }
    }

    private var portsContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            portRow(port: "3000", label: "dev server", isLive: true)
            portRow(port: "5432", label: "postgres", isLive: true)
            portRow(port: "8080", label: "api proxy", isLive: true)
        }
    }

    private func usageRow(label: String, value: String, fill: Color, fraction: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(muted)

                Spacer(minLength: 12)

                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(titleColor)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule(style: .continuous)
                        .fill(trackColor)

                    Capsule(style: .continuous)
                        .fill(fill)
                        .frame(width: max(12, proxy.size.width * fraction))
                }
            }
            .frame(height: 6)
        }
    }

    private func portRow(port: String, label: String, isLive: Bool) -> some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(port)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(titleColor)

                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(muted)
            }

            Spacer(minLength: 12)

            if isLive {
                Text("live")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(livePillText)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule(style: .continuous)
                            .fill(livePillFill)
                    )
            }
        }
        .padding(.vertical, 6)
    }
}
