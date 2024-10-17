//
//  ContentView.swift
//  InfWorld
//
//  Created by Brody on 10/16/24.
//

import SwiftUI

struct ColorStringPair: Hashable {
    let text: String
    let color: Color
}

//Global
private var validWordsSet: Set<String> = []
private var screenHeight = UIScreen.main.bounds.height
private var screenWidth = UIScreen.main.bounds.width


func loadDictionary() {
    if let dictionaryURL = Bundle.main.url(forResource: "ValidWords", withExtension: "txt") {
        if let dictionaryWords = try? String(contentsOf: dictionaryURL) {
            let wordArray = dictionaryWords.components(separatedBy: "\n")
            validWordsSet = Set(wordArray.map { $0.uppercased() })
        }
    }
}




class GridViewClass: ObservableObject{
    
    var answerWord: String
    var inputWord: String = ""
    var attempt: Int = 1
    var inputList: [ColorStringPair] = []
    var showWinScreen: Bool = false
    var showLoseScreen: Bool = false
    
    var row1 = Array(repeating: ColorStringPair(text: "?", color: .gray), count: 5)
    var row2 = Array(repeating: ColorStringPair(text: "?", color: .gray), count: 5)
    var row3 = Array(repeating: ColorStringPair(text: "?", color: .gray), count: 5)
    var row4 = Array(repeating: ColorStringPair(text: "?", color: .gray), count: 5)
    var row5 = Array(repeating: ColorStringPair(text: "?", color: .gray), count: 5)
    
    @Published var keyColors: [String: Color] = [:]
        
    
    
    init(){
        loadDictionary()
        self.answerWord = validWordsSet.randomElement()?.uppercased() ?? "power"
        print("ANSWERWORD: \(self.answerWord)")
    }
    
    func updateKeyColors(for inputWord: String, answerWord: String) {
        print("new Answerword -> \(answerWord)")
        objectWillChange.send()
        for (index, letter) in inputWord.enumerated() {
            let letterString = String(letter)
            
            if Array(answerWord)[index] == letter { // Correct letter and position
                keyColors[letterString] = Color.green
            } else if answerWord.contains(letterString) { // Correct letter, wrong position
                keyColors[letterString] = Color.orange
            } else {
                keyColors[letterString] = Color.gray.opacity(0.3)
            }
        }
        print("new dict -> \(keyColors)")
    }
    
    func wordChecker(){
        inputList = []
        var inputColor: Color = Color.gray
        
        //Color assigner
        for (index, letter) in inputWord.enumerated() {
            print("comparing letter -> \(Array(answerWord)[index]) with -> \(Array(inputWord)[index]) ")
            //Check if letter is the same as the slot for the answer word {}
            if Array(answerWord)[index] == Array(inputWord)[index]{ inputColor = Color.green }
            else if answerWord.contains(Array(inputWord)[index]){ inputColor = Color.orange }
            else { inputColor = Color.gray }
            
            inputList.append(ColorStringPair(text: "\(letter)", color: inputColor))
            print("inputWord: \(inputWord) ==?  answerWord: \(answerWord)")
            if inputWord == answerWord {
                print("enter")
                showWinScreen = true
            }
        }
    }
    
    func visualRowChange(row: [ColorStringPair]){
        objectWillChange.send()
        switch attempt {
            case 1: row1 = row
            case 2: row2 = row
            case 3: row3 = row
            case 4: row4 = row
            case 5: row5 = row
            default: fatalError("Not on Valid Attempt Number! No Row Replaced")
        }
    }
    
    func swapRows(){
        withAnimation(.spring(response:0.6, dampingFraction: 1.2)){
            objectWillChange.send()
            
                switch attempt {
                    
                case 1:
                    row1 = inputList
                    print("row1 was swapped into \(row1)")
                    
                        
                    
                    
                case 2:
                    row2 = inputList
                    print("row2 was swapped into \(row2)")
                    
                    
                case 3:
                    row3 = inputList
                    print("row3 was swapped into \(row3)")
                    
                    
                case 4:
                    row4 = inputList
                    print("row4 was swapped into \(row4)")
                    
                    
                case 5:
                    row5 = inputList
                    print("row5 was swapped into \(row5)")
                    if inputWord != answerWord {
                        showLoseScreen = true
                    }
                        
                default:
                    fatalError("Not on Valid Attempt Number! No Row Replaced")
                }
        }
        
        
        
    }
    
    func resetGame() {
        withAnimation{
            
            row1 = Array(repeating: ColorStringPair(text: "?", color: .gray), count: 5)
            row2 = Array(repeating: ColorStringPair(text: "?", color: .gray), count: 5)
            row3 = Array(repeating: ColorStringPair(text: "?", color: .gray), count: 5)
            row4 = Array(repeating: ColorStringPair(text: "?", color: .gray), count: 5)
            row5 = Array(repeating: ColorStringPair(text: "?", color: .gray), count: 5)
            
            inputWord = ""
            attempt = 1
            showWinScreen = false
            keyColors = [:]
            answerWord = validWordsSet.randomElement()?.uppercased() ?? "POWER"
            print("New answer word: \(answerWord)")
            
            objectWillChange.send()
        }
            
    }
}
struct GridView: View {
    
    let rows: Int
    let columns: Int
    
    
    
    @ObservedObject var gridViewClass: GridViewClass
    
    
    

    var body: some View {
        VStack {
            // Row 1
            ZStack {
            
                if gridViewClass.attempt == 1 {
                    Rectangle()
                        .stroke(lineWidth: 0)
                        .frame(width: 370, height: 70)
                        .cornerRadius(3)
                        .transition(.scale)
                        
                        
                }
                HStack {
                    ForEach(gridViewClass.row1, id: \.self) { tuple in
                        WordSquare(inputChar: "\(tuple.text)",  inputColor: tuple.color, inputHeight: 1.0, inputWidth: 1.0)
                            
                    }
                }
            }

            // Row 2
            ZStack {
                if gridViewClass.attempt == 2 {
                    Rectangle()
                        .stroke(lineWidth: 0)
                        .frame(width: 370, height: 70)
                        .cornerRadius(3)
                        
                        
                }
                HStack {
                    ForEach(gridViewClass.row2, id: \.self) { tuple in
                        WordSquare(inputChar: "\(tuple.text)",  inputColor: tuple.color, inputHeight: 1.0, inputWidth: 1.0)
                    }
                }
            }

            // Row 3
            ZStack {
                if gridViewClass.attempt == 3 {
                    Rectangle()
                        .stroke(lineWidth: 0)
                        .frame(width: 370, height: 70)
                        .cornerRadius(3)
                        
                        
                }
                HStack {
                    ForEach(gridViewClass.row3, id: \.self) { tuple in
                        WordSquare(inputChar: "\(tuple.text)",  inputColor: tuple.color, inputHeight: 1.0, inputWidth: 1.0)
                    }
                }
            }

            // Row 4
            ZStack {
                if gridViewClass.attempt == 4 {
                    Rectangle()
                        .stroke(lineWidth: 0)
                        .frame(width: 370, height: 70)
                        .cornerRadius(3)
                        
                }
                HStack {
                    ForEach(gridViewClass.row4, id: \.self) { tuple in
                        WordSquare(inputChar: "\(tuple.text)",  inputColor: tuple.color, inputHeight: 1.0, inputWidth: 1.0)
                    }
                }
            }

            // Row 5
            ZStack {
                if gridViewClass.attempt == 5 {
                    Rectangle()
                        .stroke(lineWidth: 0)
                        .frame(width: 370, height: 70)
                        .cornerRadius(3)
                        
                }
                HStack {
                    ForEach(gridViewClass.row5, id: \.self) { tuple in
                        WordSquare(inputChar: "\(tuple.text)",  inputColor: tuple.color, inputHeight: 1.0, inputWidth: 1.0)
                    }
                }
            }
        }.padding(.horizontal)
    }
}
struct WordSquare : View {
    @State var inputChar: String
    @State var inputColor: Color
    @State var inputHeight: CGFloat
    @State var inputWidth: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let sizeH = geometry.size.height * inputHeight
            let sizeW = geometry.size.width * inputWidth

            Text(inputChar)
                .frame(width: sizeW, height: sizeH)
                .foregroundStyle(.white)
                .font(.system(size: sizeH * 0.6))
                .background(inputColor)
                .cornerRadius(3)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
        }
        //Keeps the squares within frame
        .aspectRatio(1, contentMode: .fit)
        
            
    }
}

struct KeyboardSquare : View {
    @State var inputChar: String
    @State var inputColor: Color
    @State var inputSize: CGFloat
    
    var body: some View {
        Text(inputChar)
            .frame(width: inputSize * 1.2, height: inputSize * 2.0) // Set frame size here
            .foregroundStyle(.white)
            .font(.system(size: inputSize * 0.6))
            .background(inputColor)
            .cornerRadius(3)
    }
}


struct HeaderBar: View{
    @Binding var attempt: Int
    @Binding var restartID: UUID
    @Binding var showWinScreen: Bool
    @Binding var showLoseScreen: Bool
    @Binding var isKeyboardVisible: Bool
    @Binding var inputWord: String
    @Binding var answerWord: String
    
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false

    @State var rowToMod: Int = 0
    @State var rowToInsert = Array(repeating: ColorStringPair(text: "?", color: .gray), count: 5)
    
    @ObservedObject var gridViewClass: GridViewClass
    
    var body: some View{
        ZStack{
            Color.blue.ignoresSafeArea()
            VStack{
                Spacer()
                if !isKeyboardVisible{
                    VStack{
                        Spacer(minLength: 40)
                        HStack{
                            Text("Brody Wordle")
                                .bold()
                                .foregroundStyle(Color.white)
                                .font(.largeTitle)
                        }
                        Spacer(minLength: 20)
                    }
                }
                
                HStack{
                    if !showWinScreen && !showLoseScreen{
                        Spacer()
                        Spacer()
                        Button("ENTER"){
                            inputGuess()
                            
                        }
                            .frame(width: 100, height: 20)
                            .padding()
                            .foregroundStyle(Color.blue)
                            .background(Color.white)
                            .cornerRadius(10)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                        
                            .alert(errorTitle, isPresented: $showingError) {
                                Button("OK") {}
                            } message: {
                                Text(errorMessage)
                            }
                            .allowsHitTesting(isKeyboardVisible ? false : true)
                            .opacity(isKeyboardVisible ? 0.0 : 1.0)
                        
                            //responsible for editing grid
                            .onChange(of: inputWord) { newValue in
                                inputWord = newValue.uppercased()
                                inputWord =  String(inputWord.prefix(5))
                                for index in 0..<5 {
                                            if index < inputWord.count {
                                                let character = inputWord[inputWord.index(inputWord.startIndex, offsetBy: index)]
                                                rowToInsert[index] = ColorStringPair(text: String(character), color: Color.gray)
                                            } else {
                                                rowToInsert[index] = ColorStringPair(text: "?", color: Color.gray)
                                            }
                                        }
                                //swap rows here
                                gridViewClass.visualRowChange(row: rowToInsert)
                                
                            }
                            .padding(.top, 10)
                            .shadow(radius: 3)
                        Spacer()
                        Spacer()
                    }
                    if showWinScreen || showLoseScreen{
                        Button("Restart: "){
                            gridViewClass.resetGame()
                            showWinScreen = false
                            showLoseScreen = false
                            answerWord = gridViewClass.answerWord
                            
                            
                        }
                            .frame(width: 100, height: 20)
                            .padding()
                            .foregroundStyle(Color.blue)
                            .background(Color.white)
                            .cornerRadius(30)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                            
                    }
                    
                        
                }
                Spacer()
                    .frame(height: 15)
                
            }
        }
        .frame( height: 70)
        
            
    }
    
    
    
    
    func spellCheck(word: String) -> Bool {
        let wordLower = word.uppercased()
        
        if !validWordsSet.contains(wordLower){
            return false
        }
        print("wordlower: \(wordLower)")
        return true
    }
    
    func charCheck(word: String) ->Bool{
        if word.count == 5 {
            return true
        } else{
            return false
        }
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    
    func inputGuess() {
        // Updates word
        
        guard spellCheck(word: inputWord) else {
            wordError(title: "Word not recognized", message: "Word doesn't exist!")
            return
        }
        guard charCheck(word: inputWord) else{
            wordError(title: "Word not long enough", message: "The word must be 5 characters!")
            return
        }
        
        
        // main actions occur here:
        
        gridViewClass.inputWord = inputWord.uppercased()
        gridViewClass.wordChecker()
        gridViewClass.swapRows()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            withAnimation(.spring(response: 0.6, dampingFraction: 1.2)){
                if !showWinScreen{
                    gridViewClass.attempt += 1
                } else {
                    gridViewClass.attempt = 0
                }
                gridViewClass.updateKeyColors(for: inputWord, answerWord: answerWord)
                inputWord = ""
            }
           
            
        }
        
    }
    
    
}

struct AppColors {
    static let keyboard = Color(red: 165/255, green: 165/255, blue: 165/255)
    static let deleteButton = Color(red: 125/255, green: 125/225, blue: 125/255)
}

struct VisualKeyboard: View{
    private let keyboardRow1: [String] = ["Q","W","E","R","T","Y","U","I","O","P"]
    private let keyboardRow2: [String] = ["A","S","D","F","G","H","J","K","L"]
    private let keyboardRow3: [String] = ["Z","X","C","V","B","N","M"]
    
    let squareSize = screenWidth/15
    
    
    @ObservedObject var gridViewClass: GridViewClass
    @Binding var inputWord: String
    @State var answerWord: String
    
    func inDict(_ inputChar: String) -> Color {
        if let color = gridViewClass.keyColors[inputChar] {
            return color
        } else {
            return AppColors.keyboard
        }
    }


    
    var body: some View{
        VStack(spacing: -10){
            HStack(spacing: 5){
                ForEach(keyboardRow1, id: \.self ) { char in
                    ZStack{
                        // make conditoinal to choose the correct color
                        // we already have the input word and the answer from the contentView
                        // compare them and make the right color
                        
                        
                        
                        KeyboardSquare(inputChar: char, inputColor: inDict(char), inputSize: squareSize)
                            .frame(width: squareSize * 1.2, height: squareSize * 2)
                            .onTapGesture {
                                inputWord += String(char)
                            }
                            .onChange(of: gridViewClass.keyColors){
                                print("dictionary changed")
                            }
                    }
                    
                    
                }
            }.id(gridViewClass.keyColors)
            HStack(spacing: 5){
                Spacer()
                    .frame(height: 100)
                ForEach(keyboardRow2, id: \.self ) { char in
                    KeyboardSquare(inputChar: char, inputColor: inDict(char), inputSize: squareSize)
                        .frame(width: squareSize * 1.2, height: squareSize * 2)
                        .onTapGesture {
                            inputWord += String(char)
                        }

                }
                Spacer()
                    .frame(height: 100)
            }.id(gridViewClass.keyColors)
            HStack(spacing:5){
                Spacer(minLength: 50)
                ForEach(keyboardRow3, id: \.self ) { char in
                    KeyboardSquare(inputChar: char, inputColor: inDict(char), inputSize: squareSize)
                        .frame(width: squareSize * 1.2, height: squareSize * 2)
                        .onTapGesture {
                            inputWord += String(char)
                        }

                }.id(gridViewClass.keyColors)
                ZStack{
                    Text("")
                        .frame(width: squareSize * 1.2, height: squareSize * 2.0) // Set frame size here
                        .foregroundStyle(.white)
                        .font(.system(size: squareSize * 0.6))
                        .background(Color.blue)
                        .cornerRadius(3)
                    Image(systemName: "delete.backward")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                }
                .onTapGesture {
                    if inputWord.count >= 1{
                        inputWord.removeLast()
                    }
                    
                }
                
                    
                Spacer(minLength: 30)
            }
        }
    }
}



struct ContentView: View {
    
    @State var attempt: Int = 1
    @State var inputWord: String = ""
    @State var isKeyboardVisible: Bool = false
    @StateObject var gridViewClass = GridViewClass()
    @State var answerWord: String = ""
    @State var showWinScreen: Bool = false
    @State var showLoseScreen:Bool = false
    @State var keyColors: [String: Color] = [:]
    @State private var restartID = UUID()
    

    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.white.ignoresSafeArea()
                VStack{
                    HeaderBar(attempt: $attempt, restartID: $restartID, showWinScreen: $showWinScreen, showLoseScreen: $showLoseScreen, isKeyboardVisible: $isKeyboardVisible, inputWord: $inputWord, answerWord: $answerWord, gridViewClass: gridViewClass)
                    Spacer(minLength: 10)
                    .opacity(isKeyboardVisible ? 0.0 : 1.0)
                    GridView(rows: 5, columns: 5, gridViewClass: gridViewClass)
                        .frame(width:screenWidth * 0.92, height: screenHeight * 0.4)
                        .padding(.horizontal)
                    Spacer()
                    VisualKeyboard(gridViewClass: gridViewClass, inputWord: $inputWord, answerWord: answerWord)
                        .frame(width:screenWidth * 0.6, height: screenHeight * 0.2)
                        .padding(.horizontal)
                    Spacer()
                        .frame(height: 20)
                    
                }
                if showWinScreen{
                    Text("YOU WON THE GAME!")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 50))
                        .frame(width: 350, height: 240)
                        .background(Color.blue)
                        .cornerRadius(30)
                        .bold()
                        .foregroundStyle(.white)
                        .padding()
                }
                if showLoseScreen{
                    Text("YOU LOST!\nThe Word was\n\(answerWord)")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 50))
                        .frame(width: 350, height: 240)
                        .background(Color.red)
                        .cornerRadius(30)
                        .bold()
                        .foregroundStyle(.white)
                        .padding()
                }
            }
            .onAppear{
                answerWord = gridViewClass.answerWord
                print("from contentView, answerWord: \(answerWord)")
            }
            .onChange(of: gridViewClass.showWinScreen) { showScreen in
                print("update in winscreeen from class object")
                withAnimation{
                    showWinScreen = showScreen
                }
                
            }
            .onChange(of: gridViewClass.showLoseScreen){ showScreen in
                withAnimation{
                    showLoseScreen = showScreen
                }
            }
            //restart game on change? i think...
            .id(restartID)
        }
    }
    
    
}



#Preview {

    ContentView()

}

