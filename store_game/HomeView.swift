import SwiftUI

struct HomeView: View {
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
        VStack(spacing: 24) {
            HStack{
                
                Text(storeName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image("bluebag")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(bagColor)
                    .frame(width: 30, height: 30)

            }
               
            Text("Net Worth:")
                .frame(maxWidth: .infinity, alignment: .leading)
                
            Text("Available Cash:")
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                
                NavigationLink(destination: OfficeView(storeName: storeName, bagColor: bagColor)) {
                    ZStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 90))
                        Text("office")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }

                ZStack {
                    Image(systemName: "star.fill")
                        .font(.system(size: 90))
                    Text("store")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                }

                ZStack {
                    Image(systemName: "star.fill")
                        .font(.system(size: 90))
                    Text("factory")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                
                }
            }
                

            Spacer()
        }
        .padding()
        .background(pastelBackground.ignoresSafeArea())
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OfficeView: View {
    let storeName: String
    let bagColor: Color

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Office")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding(.top)

            Image(systemName: "building.2.fill")
                .font(.system(size: 80))
                .foregroundStyle(bagColor)

            Text("Welcome to the office for \(storeName)")
                .font(.headline)

            Spacer()
        }
        .padding()
        .navigationTitle("Office")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HomeView(storeName: "Demo Store", bagColor: .blue)
    }
}
