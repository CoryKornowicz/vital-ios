import SwiftUI
import VitalCore
import ComposableArchitecture
import VitalHealthKit
import os

@main
struct ExampleApp: App {
  final class Delegate: NSObject, UIApplicationDelegate {
    func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
      VitalLogger.stdOutEnabled = true
      VitalHealthKitClient.automaticConfiguration()
      return true
    }
  }

  @UIApplicationDelegateAdaptor var appDelegate: Delegate
  
  var body: some Scene {
    WindowGroup {
      WithViewStore(appStore) { viewStore in
        TabView {
          HealthKitExample()
            .tabItem {
              Image(systemName: "suit.heart")
              Text("HealthKit")
            }
            .tag(0)

          DevicesExample.RootView(store: devicesStore)
            .tabItem {
              Image(systemName: "laptopcomputer.and.iphone")
              Text("Devices")
            }
            .tag(1)
          
          LinkCreation.RootView(store: appStore.scope(state: \.linkCreationState, action: AppAction.linkCreation))
            .tabItem {
              Image(systemName: "link")
              Text("Link")
            }
            .tag(2)
          
          Settings.RootView(store: appStore.scope(state: \.settingsState, action: AppAction.settings))
            .tabItem {
              Image(systemName: "gear")
              Text("Settings")
            }
            .tag(3)
        }
        .onAppear {
          viewStore.send(.start)
        }
        .onOpenURL { url in
          viewStore.send(.callback(url))
        }
      }
    }
  }
}


struct AppState: Equatable {
  var linkCreationState: LinkCreation.State = .init()
  var settingsState: Settings.State = .init()
}

struct AppEnvironment: Equatable {}

enum AppAction: Equatable {
  case settings(Settings.Action)
  case linkCreation(LinkCreation.Action)
  
  case callback(URL)
  case start
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  settingsReducer.pullback(state: \.settingsState, action: /AppAction.settings, environment: { env in
    return Settings.Environment()
  }),
  
  linkCreationReducer.pullback(state: \.linkCreationState, action: /AppAction.linkCreation, environment: { env in
    return LinkCreation.Environment()
  }),

  Reducer { state, action, environment in
    switch action {
      case let .callback(url):
        return Effect<AppAction, Never>(value: AppAction.linkCreation(.callback(url)))
        
      case .start:
        return Effect<AppAction, Never>(value: AppAction.settings(.start))
      
      default:
        return .none
    }
  }
)

let appStore = Store(
  initialState: .init(),
  reducer: appReducer,
  environment: .init()
)
