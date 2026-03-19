import SwiftUI

struct StoreView: View {
    let storeName: String
    let bagColor: Color

    private var pastelBackground: Color {
        let ui = UIColor(bagColor)
        var r: CGFloat = 1, g: CGFloat = 1, b: CGFloat = 1, a: CGFloat = 1
        if !ui.getRed(&r, green: &g, blue: &b, alpha: &a) {
            r = 1; g = 1; b = 1; a = 1
        }
        let blend: (CGFloat) -> CGFloat = { component in
            (component * 0.2) + (1.0 * 0.8)
        }
        return Color(red: Double(blend(r)), green: Double(blend(g)), blue: Double(blend(b)), opacity: 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Store")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding(.top)

            Text("Welcome to the store for \(storeName)")
                .font(.headline)
                .foregroundStyle(.primary)

            Button(action: { /* TODO: inventory action */ }) {
                Text("inventory")
                    .font(.headline)
                    .foregroundStyle(bagColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(pastelBackground)
            )

            Button(action: { /* TODO: merchandising action */ }) {
                Text("merchandising")
                    .font(.headline)
                    .foregroundStyle(bagColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(pastelBackground)
            )

            Spacer()
        }
        .padding()
        .background(pastelBackground.ignoresSafeArea())
        .navigationTitle("Store")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        StoreView(storeName: "Demo Store", bagColor: .blue)
    }
}
