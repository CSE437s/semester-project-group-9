//
//  MainView.swift
//  semester-project-group9
//
//  Created by Cole Sherman on 3/26/24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case bearChat = "BearChat"
    case profile = "Profile"
    
    var systemImage: String {
        switch self {
        case .home:
            return "house"
        case .bearChat:
            return "bubble.left"
        case .profile:
            return "person"
        }
    }
    
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
}

struct PositionKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func viewPosition(completion: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    
                    Color.clear
                        .preference(key: PositionKey.self, value: rect)
                        .onPreferenceChange(PositionKey.self, perform: completion)
                }
            }
    }
}

struct TabShape: Shape {
    var midpoint: CGFloat
    
    /// Adding Shape Animation
    var animatableData: CGFloat {
        get { midpoint }
        set {
            midpoint = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            /// First Drawing the Rectangle Shape
            path.addPath(Rectangle().path(in: rect))
            /// Now Drawing Upward Curve Shape
            path.move(to: .init(x: midpoint - 60, y: 0))
            
            let to = CGPoint(x: midpoint, y: -25)
            let control1 = CGPoint(x: midpoint - 30, y: 0)
            let control2 = CGPoint(x: midpoint - 30, y: -25)
            
            path.addCurve(to: to, control1: control1, control2: control2)
            
            let to1 = CGPoint(x: midpoint + 60, y: 0)
            let control3 = CGPoint(x: midpoint + 30, y: -25)
            let control4 = CGPoint(x: midpoint + 30, y: 0)
            
            path.addCurve(to: to1, control1: control3, control2: control4)
        }
    }
}

struct Home: View {
    /// View Properties
    @State private var activeTab: Tab = .home
    
    var user: User {
        if let data = UserDefaults.standard.data(forKey: "currentUser") {
            do {
                let decoder = JSONDecoder()
                
                let current = try decoder.decode(User.self, from: data)
                return current
            } catch {
                print("unable to decode: \(error)")
                return User(firstName: "", lastName: "", email: "", firstMajor: "", secondMajor: "", graduationYear: "")
            }
        } else {
            return User(firstName: "", lastName: "", email: "", firstMajor: "", secondMajor: "", graduationYear: "")
        }
    }
    
    /// For Smooth Shape Sliding Effect, We're going to use Matched Geometry Effect
    @Namespace private var animation
    @State private var tabShapePosition: CGPoint = .zero
    init() {
        /// Hiding Tab Bar Due To SwiftUI iOS 16.4 Bug
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                LoggedInView()
                    .tag(Tab.home)
                    /// Hiding Native Tab Bar
                    /// Bug on iOS 16.4
                    // .toolbar(.hidden, for: .tabBar)
                
                ChannelListView(navigatedFromProfile: false)
                    .tag(Tab.bearChat)
                    /// Hiding Native Tab Bar
                    /// Bug on iOS 16.4
                    // .toolbar(.hidden, for: .tabBar)
                
                ProfileView(currentUser: user)
                    .tag(Tab.profile)
                
            }
            
            CustomTabBar()
        }
    }
    
    /// Custom Tab Bar
    /// With More Easy Customization
    @ViewBuilder
    func CustomTabBar(_ tint: Color = Color(hex: "32652F"), _ inactiveTint: Color = Color(hex: "32652F")) -> some View {
        /// Moving all the Remaining Tab Item's to Bottom
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) {
                TabItem(
                    tint: tint,
                    inactiveTint: inactiveTint,
                    tab: $0,
                    animation: animation,
                    activeTab: $activeTab,
                    position: $tabShapePosition
                )
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(content: {
            TabShape(midpoint: tabShapePosition.x)
                .fill(.white)
                .ignoresSafeArea()
                /// Adding Blur + Shadow
                /// For Shape Smoothening
                .shadow(color: tint.opacity(0.2), radius: 5, x: 0, y: -5)
                .blur(radius: 2)
                .padding(.top, 25)
        })
        /// Adding Animation
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
    }
}

/// Tab Bar Item
struct TabItem: View {
    var tint: Color
    var inactiveTint: Color
    var tab: Tab
    var animation: Namespace.ID
    @Binding var activeTab: Tab
    @Binding var position: CGPoint
    
    /// Each Tab Item Position on the Screen
    @State private var tabPosition: CGPoint = .zero
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundColor(activeTab == tab ? .white : inactiveTint)
                /// Increasing Size for the Active Tab
                .frame(width: activeTab == tab ? 58 : 35, height: activeTab == tab ? 58 : 35)
                .background {
                    if activeTab == tab {
                        Circle()
                            .fill(tint.gradient)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
            
            Text(tab.rawValue)
                .font(.caption)
                .foregroundColor(activeTab == tab ? tint : .gray)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .viewPosition(completion: { rect in
            tabPosition.x = rect.midX
            
            /// Updating Active Tab Position
            if activeTab == tab {
                position.x = rect.midX
            }
        })
        .onTapGesture {
            activeTab = tab
            
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                position.x = tabPosition.x
            }
        }
    }
}

struct MainView: View {
  var body: some View {
    Home()
  }
}

/*#Preview {
    MainView()
}
*/
