//
//  OnboardingView.swift
//  Desigwin
//
//  Created by kuroisi on 2022/02/04.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboard: Bool
    @State private var isStep1 = false
    @State private var flameOnboard01Name = "setsumei1"
    @State private var flameOnboard02Name = "setsumei2"
    
    var body: some View {
        let bounds = UIScreen.main.nativeBounds
        let sWidth = Int(bounds.width)
        let sHeight = Int(bounds.height)
        
        ZStack {
            if (isStep1) {
                Image(self.flameOnboard02Name)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .center)
                    .edgesIgnoringSafeArea(.all)
                    .statusBar(hidden: true)
            } else {
                Image(self.flameOnboard01Name)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .center)
                    .edgesIgnoringSafeArea(.all)
                    .statusBar(hidden: true)
            }
            
            VStack {
                Spacer()
                if (self.isStep1) {
                    Button(action: {
                        self.isOnboard = true
                        UserDefaults.standard.set(true, forKey: "isOnboard")
                    }) {
                        Image("bt-setsumei2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.size.width * 0.5, height: 150, alignment: .center)
                            .padding(.bottom, 40)
                    }
                } else {
                    Button(action: {
                        self.isStep1 = true
                    }) {
                        Image("bt-setsumei1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.size.width * 0.5, height: 150, alignment: .center)
                            .padding(.bottom, 40)
                    }
                }
            }
        }
        .onAppear {
            self.getAspectH(w: sWidth, h: sHeight)
        }
    }
    
    /// 最大公約数 GCD(greatest common divisor)
    private func getAspectH(w: Int, h: Int) {
        let w: Float = Float(w)
        let h: Float = Float(h)
        let as_h: Float = w / h * 100
        
        if (as_h == 56) {
            self.flameOnboard01Name = "setsumei1_16"
            self.flameOnboard02Name = "setsumei2_16"
        }
    }
}
