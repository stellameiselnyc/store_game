import SwiftUI

struct StoreOfficeView: View {
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
                Text("Office")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding(.top)

            Button(action: { /* TODO: advertising action */ }) {
                Text("advertising")
                    .font(.headline)
                    .foregroundStyle(bagColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(pastelBackground)
            )

            Button(action: { /* TODO: pricing action */ }) {
                Text("pricing")
                    .font(.headline)
                    .foregroundStyle(bagColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(pastelBackground)
            )

            Button(action: { /* TODO: employees action */ }) {
                Text("employees")
                    .font(.headline)
                    .foregroundStyle(bagColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(pastelBackground)
            )

            Button(action: { /* TODO: settings action */ }) {
                Text("settings")
                    .font(.headline)
                    .foregroundStyle(bagColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(pastelBackground)
            )

            Button(action: { /* TODO: save and restart action */ }) {
                Text("save and restart")
                    .font(.headline)
                    .foregroundStyle(bagColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(pastelBackground)
            )

            Button(role: .destructive, action: { /* TODO: close store action */ }) {
                Text("close store")
                    .font(.headline)
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.red.opacity(0.15))
            )

            Spacer()
        }
        .padding()
        .navigationTitle("Office")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        StoreOfficeView(storeName: "Demo Store", bagColor: .blue)
    }
}
