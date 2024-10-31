//
//  MenuView.swift
//  InfWorld
//
//  Created by Brody on 10/30/24.
//

import SwiftUI

struct MenuView: View {
    
    @State var navPath: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navPath){
            ZStack{
                Color.blue.ignoresSafeArea()
                VStack{
                    HStack{
                        
                    }
                    Spacer()
                    Text("Infinite Worlde")
                        .foregroundColor(.white)
                        .font(.system(size: 50))
                        .bold()
                    Spacer()
                    ZStack{
                        Button(action: {
                            navPath.append("Game")
                        }, label: {
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 50)
                                    .cornerRadius(20)
                                    .shadow(color: .gray, radius: 3)
                                Text("Play")
                                    .foregroundColor(.blue)
                            }
                            
                        })
                               
                    }
                    Spacer()
                    Spacer()
                    
                }
            }
            .navigationDestination(for: String.self) { view in
                if view == "Game"{
                    ContentView()
                }
                else{
                    ZStack{
                        Color.red.ignoresSafeArea()
                    }
                }
            }
            
        }
        
        
    }
}

#Preview {
    MenuView()
}
