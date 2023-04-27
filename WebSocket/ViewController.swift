//
//  ViewController.swift
//  WebSocket
//
//  Created by ShafiulAlam-00058 on 3/28/23.
//

import UIKit

class ViewController: UIViewController, URLSessionWebSocketDelegate {
    
    private var webSocket: URLSessionWebSocketTask!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: OperationQueue()
        )
        
        guard let url = URL(string: "wss://demo.piesocket.com/v3/channel_123?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self") else {
            return
        }
//        guard let url = URL(string: "ws://127.0.0.1:8080") else {
//            return
//        }
        
        webSocket = session.webSocketTask(with: url)
        webSocket.resume()
    }

    func ping() {
        webSocket.sendPing { error in
            guard let error = error else { return }
            print("Ping error: \(error)")
        }
    }
    
    func close() {
        webSocket.cancel(with: .goingAway, reason: "Demo ended".data(using: .utf8))
    }
    
    func send() {
        DispatchQueue.global().asyncAfter(deadline: .now()+1) { [weak self] in
            self?.webSocket.send(.string("Hello dear, this is Mr. Junior(\(Int.random(in: 0...1000)))")) { error in
                guard let error = error else { return }
                print(error)
            }
        }
    }
    
    func receive() {
        webSocket.receive { result in
            switch result {
            case .failure(let error):
                print("Receive error \(error)")
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Got data: \(data)")
                case.string(let str):
                    print("Got string: \(str)")
                @unknown default:
                    break
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Did connect to the socket")
        self.ping()
    }
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Did close connection with reason \(String(describing: reason))")
    }
    
    
    @IBAction func connect(_ sender: Any) {
        webSocket.resume()
    }
    
    @IBAction func send(_ sender: Any) {
        self.send()
    }
    
    @IBAction func receive(_ sender: Any) {
        self.receive()
    }
    
    @IBAction func closeWebSocket(_ sender: Any) {
        self.close()
    }
}

