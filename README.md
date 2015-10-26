GMIRCClient is a lightweight iOS IRC client, entirely written in Swift.

Currently the set of features is minimal but my purpose is to extend them soon.

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
