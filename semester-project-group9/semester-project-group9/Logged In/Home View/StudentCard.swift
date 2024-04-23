//
//  StudentCard.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 4/23/24.
//

import SwiftUI

struct StudentCard: View {
    
    let student: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                
                Text(student)
                            .font(Font.system(size: 24))
                            .bold()
                            .foregroundStyle(Color(hex: "32652F"))
                Spacer()
                    
                    Text("Student")
                        .bold()
                        .font(Font.system(size: 16))
                        .bold()
                        .foregroundStyle(Color(hex: "32652F"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color(hex: "C6DAC5"))
                        .cornerRadius(12)
                
                    }
                }
                .padding()
                .foregroundColor(.black)
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 5)

    }
}

#Preview {
    StudentCard(student: "Cole Sherman")
}
