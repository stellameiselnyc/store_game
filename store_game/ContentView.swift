//
//  ContentView.swift
//  store game
//
//  Created by Stella Meisel on 2/25/26.
//

import SwiftUI

struct ContentView: View {
    @State private var isVisible = true
    @State private var navigateToNext = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Splash content overlay
                Color(red: 0.85, green: 0.93, blue: 1.0)
                    .ignoresSafeArea()
                
                VStack {
                    Image("bluebag")
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    Text("STORE GAME")
                }
                .padding()
                .opacity(isVisible ? 1 : 0)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut(duration: 1)) {
                        isVisible = false
                    }
                    // Navigate after fade completes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        navigateToNext = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToNext) {
                NextScreenView()
            }
        }
    }
}

#Preview {
    ContentView()
}

