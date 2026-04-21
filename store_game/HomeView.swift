import SwiftUI


struct HomeView: View {
    private struct MonthRecord: Codable, Identifiable {
        let id: UUID
        let month: Int
        let shirts: Int
        
        init(month: Int, shirts: Int, id: UUID = UUID()) {
            self.id = id
            self.month = month
            self.shirts = shirts
        }
    }
    
    let storeName: String
    let bagColor: Color
    
    @AppStorage("machineID") private var machineID: Int = 0
    
    @AppStorage("machineShirtsPerDay") private var machineShirtsPerDay: Int = 0
    
    @AppStorage("monthsData") private var monthsData: Data = Data()
    
    @AppStorage("availableCash") private var availableCash: Int = 0
    
    private var months: [MonthRecord] {
        get {
            if monthsData.isEmpty {
                let initial = [MonthRecord(month: 1, shirts: Int.random(in: 2...10))]
                if let data = try? JSONEncoder().encode(initial) {
                    monthsData = data
                }
                return initial
            }
            return (try? JSONDecoder().decode([MonthRecord].self, from: monthsData)) ?? []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                monthsData = data
            }
        }
    }
    
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
    
    private func shortsSoldFromMachine() -> Int {
        // Randomly choose a percentage between 60% and 100%
        let percentage = Double.random(in: 0.6...1.0)
        return Int(Double(machineShirtsPerDay) * percentage)
    }
    
    private func initializeStartingMachineIfNeeded() {
        // If no machine has been set yet, initialize with ID 1000 and 10 shirts/day
        if machineID == 0 {
            machineID = 1000
        }
        if machineShirtsPerDay == 0 {
            machineShirtsPerDay = 10
        }
        if availableCash == 0 {
            availableCash = 8000
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text(storeName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image("bluebag")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(bagColor)
                    .frame(width: 30, height: 30)
            }


            HStack {
                Text("Available Cash: $\(availableCash)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack {
                NavigationLink(destination: StoreOfficeView(storeName: storeName, bagColor: bagColor)) {
                    ZStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 90))
                            .foregroundStyle(.black)
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
                NavigationLink(destination: FactoryView (bagColor: bagColor)) {
                    ZStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 90))
                            .foregroundStyle(.black)
                        Text("factory")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)
                    }}
            }
            Text("Updates:")
                .frame(maxWidth: .infinity, alignment: .leading)

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(months.sorted { $0.month < $1.month }) { record in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("MONTH \(record.month)")
                                .bold()
                            Text("\(storeName) sold \(record.shirts) shorts today.")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.bottom, 80) // keep content above the floating button
            }
        }
        .padding()
        .background(pastelBackground.ignoresSafeArea())
        .overlay(
            VStack {
                Spacer()
                Button(action: {
                    let nextMonth = (months.map { $0.month }.max() ?? 0) + 1
                    var updated = months
                    updated.append(MonthRecord(month: nextMonth, shirts: shortsSoldFromMachine()))
                    // Persist by encoding directly to @AppStorage to avoid mutating self
                    if let data = try? JSONEncoder().encode(updated) {
                        monthsData = data
                    }
                    if let lastShirts = updated.last?.shirts {
                        availableCash += lastShirts * 40
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(22)
                        .background(Circle().fill(bagColor))
                        .shadow(radius: 4)
                }
                .padding(.bottom, 24)
            }
        )
       // .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            initializeStartingMachineIfNeeded()
        }
    }
}


#Preview {
    NavigationStack {
        HomeView(storeName: "Demo Store", bagColor: .blue)
    }
}

