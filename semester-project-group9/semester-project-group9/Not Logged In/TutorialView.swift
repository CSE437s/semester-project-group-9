//
//  TutorialView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 2/25/24.
//

import SwiftUI
import ConcentricOnboarding

struct PageData {
    let title: String
    let header: String
    let content: String
    let color: Color
    let textColor: Color
}

struct TutorialData {
    static let pages: [PageData] = [
        PageData(
            title: "WebSTAC Class Import",
            header: "Step 1",
            content: "Log into WebSTAC and navigate to your class schedule.",
            color: Color(hex: "F38181"),
            textColor: Color(hex: "FFFFFF")),
        PageData(
            title: "WebSTAC Class Import",
            header: "Step 2",
            content: "Select all text starting from the name of your first class to the room number of your last class, copy and paste it into the text field and hit 'Submit'.",
            color: Color(hex: "FCE38A"),
            textColor: Color(hex: "4A4A4A")),
        PageData(
            title: "WebSTAC Class Import",
            header: "Step 3",
            content: "import",
            color: Color(hex: "4F844D"),
            textColor: Color(hex: "FFFFFF"))
            ]
}

struct TutorialView: View {
    
    
    var body: some View {
        return ZStack {
            ConcentricOnboardingView(pageContents: TutorialData.pages.map {
                (PageView(page: $0), $0.color)
            })
            .navigationBarBackButtonHidden(true)
        }
    
    }
}

/// Color converter from hex string to SwiftUI's Color
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
