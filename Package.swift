// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "vital-ios",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(
      name: "VitalHealthKit",
      targets: ["VitalHealthKit"]),
    .library(
      name: "VitalDevices",
      targets: ["VitalDevices"]),
    .library(
      name: "VitalCore",
      targets: ["VitalCore"]),
  ],
  dependencies: [
    .package(name: "CombineCoreBluetooth", url: "https://github.com/StarryInternet/CombineCoreBluetooth.git", from: "0.3.0"),
    .package(url: "https://github.com/WeTransfer/Mocker.git", .upToNextMajor(from: "2.6.0")),
  ],
  targets: [
    .target(
      name: "VitalHealthKit",
      dependencies: ["VitalCore"]
    ),
    .target(
      name: "VitalDevices",
      dependencies: ["CombineCoreBluetooth", "VitalCore"],
      exclude: [
        "./LICENSE",
      ]
    ),
    .target(
      name: "VitalCore",
      dependencies: ["VitalLogging"],
      exclude: [
        "./Get/LICENSE",
        "./DataCompression/LICENSE",
        "./Keychain/LICENSE"
      ]
    ),
    .target(
      name: "VitalLogging",
      exclude: ["./LICENSE.txt", "./README.txt"]
    ),
    .testTarget(
      name: "VitalHealthKitTests",
      dependencies: ["VitalHealthKit"]),
    .testTarget(
      name: "VitalCoreTests",
      dependencies: ["VitalCore", "Mocker"]),
    .testTarget(
      name: "VitalDevicesTests",
      dependencies: ["VitalDevices"]),
  ]
)
