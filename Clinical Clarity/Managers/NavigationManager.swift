//import SwiftUI
//import Combine
//
//@MainActor
//class NavigationManager: ObservableObject {
//    
//    @Published var path = NavigationPath()
//    
//    func push(_ route: AppRoute) {
//        path.append(route)
//    }
//    
//    func pop() {
//        path.removeLast()
//    }
//    
//    func popToRoot() {
//        path.removeLast(path.count)
//    }
//}
//
//struct MapRegion: Hashable {
//    let lat: Double
//    let lng: Double
//    let latDelta: Double
//    let lngDelta: Double
//}
//
//enum AppRoute: Hashable {
//    case profile
//    case bookings
//    case settings
//    case fullMap(libraries: [LibraryCardModel], region: MapRegion)
//    case editProfile
//    case content(type: String, title: String)
//    case helpSupport
//    case contactUs
//    case libraryDetail(LibraryCardModel)
//    case bookNow(LibraryCardModel, SubscriptionModel?)
//    case seatSelection(
//        LibraryCardModel,
//        SubscriptionModel,
//        Date
//    )
//    case searchLibrary
//}
