import SwiftUI

struct StoreOfficeView: View {
    let storeName: String
    let bagColor: Color

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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemGray6))
            )

            Button(action: { /* TODO: pricing action */ }) {
                Text("pricing")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemGray6))
            )

            Button(action: { /* TODO: employees action */ }) {
                Text("employees")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemGray6))
            )

            Button(action: { /* TODO: settings action */ }) {
                Text("settings")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemGray6))
            )

            Button(action: { /* TODO: save and restart action */ }) {
                Text("save and restart")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemGray6))
            )

            Button(role: .destructive, action: { /* TODO: close store action */ }) {
                Text("close store")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemGray6))
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
