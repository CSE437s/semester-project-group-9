//
//  ClassCard.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 4/22/24.
//

import SwiftUI

enum Day: String, CaseIterable {
    case M, T, W, R, F
}
struct ClassCard: View {
    
    let course: Class
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                        Text(course.name)
                            .font(Font.system(size: 24))
                            .bold()
                            .foregroundStyle(Color(hex: "32652F"))
                Spacer()
                
                        Text(course.building_room)
                            .bold()
                            .font(Font.system(size: 16))
                            .bold()
                            .foregroundStyle(Color(hex: "32652F"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color(hex: "C6DAC5"))
                            .cornerRadius(12)


                    }
                                        
                    HStack() {
                        HStack {
                            ForEach(Day.allCases, id: \.self) { day in
                                Text(String(day.rawValue.first!))
                                                    .bold()
                                                    .foregroundColor(.white)
                                                    .frame(width: 30, height: 30)
                                                    .background(course.days.contains(day.rawValue) ? Color(hex: "32652F").cornerRadius(10) : Color.gray.cornerRadius(10))
                            }
                        }
                        Spacer()
                        HStack {
                            Image(systemName: "clock.circle")
                                .foregroundStyle(Color(hex: "32652F"))
                            Text(course.times)
                                .bold()
                                .font(Font.system(size: 14))
                                .foregroundStyle(Color(hex: "32652F"))
                        }


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

