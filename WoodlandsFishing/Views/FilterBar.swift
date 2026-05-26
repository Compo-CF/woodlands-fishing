import SwiftUI

struct FilterBar: View {
    @Binding var filter: SpotFilter

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search spots", text: $filter.searchText)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled()
                if !filter.searchText.isEmpty {
                    Button {
                        filter.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6), in: .capsule)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(title: "Public only", isOn: $filter.publicOnly)
                    FilterChip(title: "Keep fish OK", isOn: $filter.keepFishOnly)
                    FilterChip(title: "Bank access", isOn: $filter.bankOnly)
                    FilterChip(title: "Boat access", isOn: $filter.boatOnly)
                }
                .padding(.horizontal, 2)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

private struct FilterChip: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isOn ? Color.accentColor : Color.secondary.opacity(0.15), in: .capsule)
                .foregroundStyle(isOn ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}
