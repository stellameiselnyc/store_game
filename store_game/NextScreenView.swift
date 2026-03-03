import UIKit
import SwiftUI

struct NextScreenView: View {
    @State private var brandName: String = ""
    @State private var bagColor: Color = .blue
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    private var canProceed: Bool {
        !brandName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var pastelBackground: Color {
        // Blend the selected color with white to create a soft pastel
        // Using a simple approach: 20% selected color over white
        let ui = UIColor(bagColor)
        var r: CGFloat = 1, g: CGFloat = 1, b: CGFloat = 1, a: CGFloat = 1
        if !ui.getRed(&r, green: &g, blue: &b, alpha: &a) {
            // Fallback to white if extraction fails
            r = 1; g = 1; b = 1; a = 1
        }
        let blend: (CGFloat) -> CGFloat = { component in
            (component * 0.2) + (1.0 * 0.8)
        }
        return Color(red: Double(blend(r)), green: Double(blend(g)), blue: Double(blend(b)), opacity: 1)
    }
    
    var body: some View {
        Group {
            if hasSeenOnboarding {
                HomeView(storeName: brandName, bagColor: bagColor)
            } else {
                ZStack {
                    pastelBackground
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        Spacer()
                            .frame(maxHeight: 30)   // at least 40 points tall if there’s room
                        Text("Name your brand:")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("Enter brand name", text: $brandName)
                            .textFieldStyle(.roundedBorder)
                            .submitLabel(.done)
                            //.padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Choose your logo color:")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ColorPicker("bag color", selection: $bagColor, supportsOpacity: false)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        //bag code
                        ZStack {
                            // Attempt to render as template and tint
                            Image("bluebag")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundStyle(bagColor)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                                .opacity(0.0) // Hidden if template not applicable
                                .overlay(
                                    // Fallback: overlay colorized version for non-template assets
                                    Image("bluebag")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 120, height: 120)
                                        .overlay(bagColor)
                                        .mask(
                                            Image("bluebag")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        )
                                )
                        }
                        NavigationLink(destination: HomeView(storeName: brandName, bagColor: bagColor)) {
                            Text("Next")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(bagColor)
                        .disabled(!canProceed)
                        .opacity(canProceed ? 1.0 : 0.5)
                        .simultaneousGesture(TapGesture().onEnded {
                            if canProceed {
                                hasSeenOnboarding = true
                            }
                        })
                        
                        Spacer()
                            .frame(maxHeight:300)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                }
            }
        }
    }
}

struct BrandSummaryView: View {
    let brandName: String
    let bagColor: Color

    var body: some View {
        VStack(spacing: 24) {
            Text("Your Brand")
                .font(.title2)
                .fontWeight(.bold)

            Text(brandName.isEmpty ? "(No name provided)" : brandName)
                .font(.headline)

            Image("bluebag")
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(bagColor)
                .aspectRatio(contentMode: .fit)
                .frame(width: 160, height: 160)
                .overlay(
                    Image("bluebag")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 160, height: 160)
                        .overlay(bagColor)
                        .mask(
                            Image("bluebag")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        )
                )

            Spacer()
        }
        .padding()
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NextScreenView()
    }
}

