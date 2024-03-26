//
//  PageView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 3/26/24.
//

import SwiftUI

struct PageView: View {
    
    let page: PageData
    let imageWidth: CGFloat = 150
    let textWidth: CGFloat = 350
    
    var body: some View {
        
        if page.title != "import" {
            
            return AnyView(VStack(alignment: .center, spacing: 50) {
                
                Text(page.title)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(page.textColor)
                    .frame(width: textWidth)
                    .multilineTextAlignment(.center)
                VStack(alignment: .center, spacing: 5) {
                    Text(page.header)
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundColor(page.textColor)
                        .frame(width: 300, alignment: .center)
                        .multilineTextAlignment(.center)
                    Text(page.content)
                        .font(Font.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(page.textColor)
                        .frame(width: 300, alignment: .center)
                        .multilineTextAlignment(.center)
                }
            })

        } else {
            return AnyView(ImportClassesView())
        }
        
    }
}

