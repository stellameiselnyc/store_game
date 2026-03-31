//
//  FactoryView.swift
//  store_game
//
//  Created by Stella Meisel on 3/16/26.
//

import SwiftUI



struct FactoryView: View {
    let bagColor: Color
    private var pastelColor: Color {
        // Blend the chosen color with white to create a pastel tone
        bagColor.opacity(0.2)
    }
    var body: some View {
       
        VStack{
            HStack {
                Text("Factory")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding(16)
            NavigationLink(destination: ShirtMachineView()) {
                Text("shirts")
                    .font(.headline)
                    .foregroundStyle(bagColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(pastelColor)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding(.horizontal)
            
//            Spacer(minLength: 8)q
            Button(action: { /* TODO: new item action */ }) {
                Text("new item")
                    .font(.headline)
                    .foregroundStyle(bagColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(pastelColor)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding(.horizontal)
         
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        FactoryView(bagColor: .blue)
    }
}

