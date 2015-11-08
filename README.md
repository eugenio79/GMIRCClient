# GMIRCClient

GMIRCClient is a lightweight iOS IRC client, entirely written in Swift.

NOTE: currently the set of features is minimal but I hope to extend them soon.

## Requirements

* iOS 8.0+
* XCode 7.1+

## Installation

GMIRCClient is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "GMIRCClient"
```

## Usage

### Registering to a server

```swift
let socket = GMSocket(host: "irc.freenode.net", port: 6667)
irc = GMIRCClient(socket: socket)
irc.register("nickname", user: "username", realName: "Firstname Lastname")
```

### Event handling

```swift
irc.delegate = self

func didWelcome() {
    print("Received welcome message - ready to join a chat room")
    irc.join("#test")
}

func didJoin(channel: String) {
    print("Joined chat room: \(channel)")
    irc.sendMessageToNickName("Hi, I'm Nick. Is there anybody?", nickName: "Lela")
}

func didReceivePrivateMessage(text: String, from: String) {
    print("Received message from \(from): \(text)")
}
```

## Author

Giuseppe Morana aka Eugenio, giuseppe.morana.79@gmail.com

## License

GMIRCClient is available under the MIT license. See the LICENSE file for more info.
