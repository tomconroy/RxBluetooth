# RxBluetooth

RxBluetooth is a wrapper around [Core Bluetooth](https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html) that allows to receive data from observables.

## Wrapped delegates

The following delegates are wrapped:

* `CBCentralManagerDelegate`
* `CBPeripheralDelegate`
* `CBPeripheralManagerDelegate`

## Installation

### CocoaPods

Podfile
```
pod 'RxBluetooth', '~> 0.3'
```

### Carthage

Cartfile
```
github "SideEffects-xyz/RxBluetooth"
```

### Contributions

Contributions are welcomed in the `develop` repository. Any pull-request to the `master` branch will be rejected.

## LICENSE

This project is released under [MIT License](LICENSE).