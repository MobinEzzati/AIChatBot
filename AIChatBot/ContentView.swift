//
//  ContentView.swift
//  AIChatBot
//
//  Created by mobin on 3/27/23.
//

import SwiftUI
import OpenAISwift

final class ViewModel: ObservableObject {
    init(){}
    private var clinet: OpenAISwift?
    
    func setUp(){
        clinet = OpenAISwift(authToken: "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")
    }
    
    func send(text:String , completion: @escaping(String) -> Void){
        clinet?.sendCompletion(with: text, maxTokens: 500,completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(output)
            case .failure(_):
                break
            }
        })
    }
}

struct ContentView: View {
    @ObservedObject var model = ViewModel()
    @State var text = ""
    @State var models = [String]()
    
    var body: some View {
        VStack {
            ForEach(models, id: \.self){ string in
                Text(string)
            }
        }
        HStack{
            TextField("Type Here ...", text: $text)
            Button("send"){
                send()
            }
        }
        .onAppear{
            model.setUp()
        }
        .padding()
    }
    
    func send(){
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        models.append("Me: \(text)")
        model.send(text: text) { respone in
            DispatchQueue.main.async {
                self.models.append("chatGPT: "+respone)
                self.text = ""
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
