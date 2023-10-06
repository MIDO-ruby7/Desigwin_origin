import SwiftUI
import CoreData
import Combine
import UIKit

let maxCharacterLength = Int(20)
//アラートタイプ
enum AlertType {
    case save
    case err
}

struct ContentView: View {
    @State var showAlert = false
    @State var alertType: AlertType = .err //アラート表示切り替え
    //@State private var isMydw: Bool = false
    @State private var name = ""
    @State private var flameName = "Desigwin_flame169"
    @State private var flameEditName = "Desigwin_flame169_edit"
    @State private var flameOverName = "Desigwin_flame169_over"
    @State var isOnboard: Bool
    @State var isOnboardCamera: Bool
    @State private var isListDw = false
    @State private var isTakePhoto = false
    @ObservedObject var avFoundationVM = AVFoundationVM()
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var myDwModel = MyDwModel()
    @ObservedObject private var viewModel = ViewModel()
    
    init() {
        self.isOnboard = UserDefaults.standard.bool(forKey: "isOnboard")
        self.isOnboardCamera = UserDefaults.standard.bool(forKey: "isOnboardCamera")
        // TextEditorの背景色を設定するため
        UITextView.appearance().backgroundColor = .clear
        UINavigationBar.appearance().tintColor = .black // backボタン色
    }
    
    var body: some View {
        //let bounds = UIScreen.main.bounds
        let bounds = UIScreen.main.nativeBounds
        let sWidth = Int(bounds.width)
        let sHeight = Int(bounds.height)
        
        if !self.isOnboard {
            OnboardingView(isOnboard: $isOnboard)
                .statusBar(hidden: true)
        } else {
            if avFoundationVM.image == nil || !self.isTakePhoto {
                //Spacer()
                NavigationView {
                    ZStack(alignment: .bottom) {
                        GeometryReader { geometry in
                            //カメラの映像
                            CALayerView(caLayer: avFoundationVM.previewLayer)
                            //フレーム表示
                            Image(self.flameName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .edgesIgnoringSafeArea(.all)
                                .statusBar(hidden: true)
                            //flameImageView()
                            /*Rectangle()
                                  .aspectRatio(CGSize(width: 9, height: 16), contentMode:.fit)*/
                            
                        }
                        
                        //撮影ボタン
                        Button(action: {
                            self.avFoundationVM.takePhoto()
                            self.isTakePhoto = true
                        }) {
                            Image("bt-big-camera")
                                //.renderingMode(.original)
                                .resizable()
                                .frame(width: 80, height: 80, alignment: .center)
                        }
                        .shadow(color: .black.opacity(0.2), radius: 6)
                        .padding(.bottom, 110.0)
                        
                        //保存リストボタン
                       /* Button(action: {
                            self.isMydw = true
                        }) {
                            Image(systemName: "book.circle.fill")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 60, height: 60, alignment: .center)
                        }
                        .sheet(isPresented: self.$isMydw) {
                            HStack {
                                Text("モーダルビュー")
                                Image(systemName: "paperplane")
                            }
                        }*/
                            
                        
                        //必殺技リスト
                        NavigationLink(destination: MyDwListView(avFoundationVM: avFoundationVM, isTakePhoto: $isTakePhoto)) {
                            VStack {
                                Image("bt-ichiran")
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .center)
                                Text("リスト").font(.caption2)
                                    .bold()
                                    .accentColor(.black)
                                
                            }
                            .shadow(color: .black.opacity(0.2), radius: 2)
                            .padding(.trailing, 25.0)
                            .padding(.bottom, 20.0)
                            //.shadow(color: .gray.opacity(0.2), radius: 4)
                        }
                        .frame(width: UIScreen.main.bounds.size.width, height: 80, alignment: .trailing)
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        print(sWidth)
                        print(sHeight)
                        self.name = ""
                        self.isTakePhoto = false
                        self.getAspectH(w: sWidth, h: sHeight)
                        self.avFoundationVM.startSession()
                        self.isOnboardCamera = UserDefaults.standard.bool(forKey: "isOnboardCamera")
                    }
                    .onDisappear {
                        self.avFoundationVM.endSession()
                    }
                }
            } else {
                NavigationView {
                    
                    ZStack {
                        GeometryReader { geometry in
                            ZStack(alignment: .bottom) {
                                ZStack(alignment: .bottom) {
                                    Image(uiImage: avFoundationVM.image!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .edgesIgnoringSafeArea(.all)
                                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                                        .offset(x: 0, y: 0)
                                        .statusBar(hidden: true)

                                    Image(self.flameEditName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        //.frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
                                        .offset(x: 0, y: 0)
                                        .edgesIgnoringSafeArea(.all)
                                        .onTapGesture(count: 2) {
                                            if (name != "") {
                                            //ダブルタップ
                                                alertType = .save
                                            //カメラロールに保存
                                            let captureImage = capture(rect: geometry.frame(in: .global))
                                            //ImageSaver($showAlert).writeToPhotoAlbum(image: captureImage)
                                            
                                            //DBに保存
                                            self.addItem(image: captureImage)
                                            } else {
                                                alertType = .err
                                                self.showAlert = true
                                            }
                                        }
                                        .alert(isPresented: $showAlert) {
                                            switch alertType {
                                            case .save:
                                                return Alert(
                                                title: Text("必殺技を保存しました！"),
                                                message: Text(""),
                                                dismissButton: .default(Text("OK"), action: {
                                                    self.showAlert = false
                                                    self.isListDw = true
                                                    
                                                    //カメラの操作方法非表示
                                                    UserDefaults.standard.set(true, forKey: "isOnboardCamera")
                                                }))
                                            case .err:
                                                return Alert(
                                                title: Text("必殺技の名前を\n入力してください"),
                                                message: Text(""),
                                                dismissButton: .default(Text("OK"), action: {
                                                    self.showAlert = false
                                                }))
                                            }
                                        }
                                        .onTapGesture(count: 1) {
                                            UIApplication.shared.closeKeyboard()
                                        }
                                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                            .onEnded({ value in
                                                if value.translation.width < 0 {
                                                    // left
                                                    //print("左")
                                                }
                                            
                                                //撮影に戻る　右フリック
                                                if value.translation.width > 40 {
                                                    // right
                                                    //print("右")
                                                    self.name = ""
                                                    self.isTakePhoto = false
                                                    self.avFoundationVM.image = nil
                                                }
                                            
                                                if value.translation.height < 0 {
                                                    // up
                                                    //print("上")
                                                }
                                            
                                                if value.translation.height > 0 {
                                                    // down
                                                    //print("下")
                                                }
                                            }))
                                
                                }

                            }
                            
                            
                            //ZStack(alignment: .bottom) {
                                VStack {
                                    TextField("", text: $name)
                                                .onReceive(Just(name), perform: { _ in
                                                    if maxCharacterLength < name.count {
                                                        name = String(name.prefix(maxCharacterLength))
                                                    }
                                                })
                                                .placeholder(when: name.isEmpty) {
                                                        Text("このデザインの必殺技は？").foregroundColor(.gray)
                                                }
                                                //.textFieldStyle(.roundedBorder)
                                                .multilineTextAlignment(.center)
                                                .font(.title)
                                                .background(Color.white.opacity(0.92))
                                                .foregroundColor(.black)
                                                //.background(Color.red)
                                                //.offset(x: 0, y: geometry.size.height - 115)
                                                .offset(x: 0, y: viewModel.bottomPadding)
                                                //.padding(.bottom, viewModel.bottomPadding)
                                                //.frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                                                .onReceive(
                                                            NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification),
                                                            perform: self.textDidBeginEditing
                                                        )
                     
                                }
                            
                            //}
                            
                            
                            //撮影画面の操作画像の表示
                            if !self.isOnboardCamera {
                                Image(self.flameOverName)
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .center)
                                    .onTapGesture(count: 1) {
                                        self.isOnboardCamera = true
                                        //UserDefaults.standard.set(true, forKey: "isOnboardCamera")
                                    }
                            }
                            
                            
                            NavigationLink(destination: MyDwListView(avFoundationVM: avFoundationVM, isTakePhoto: $isTakePhoto), isActive: $isListDw) {}
                            
                            
                        }.edgesIgnoringSafeArea(.all)
                    }
                    .onAppear {
                        //self.name = ""
                        
                            
                    }
                    .onDisappear {
                        
                    }
                }
            }
        }
    }
    
    //DBに保存
    private func addItem(image: UIImage) {
        let newItem = Mydw(context: viewContext)
        newItem.date = Date()
        newItem.name = name
        newItem.id = UUID()
        newItem.img = image.jpegData(compressionQuality: 0.8) //圧縮率

        do {
            try viewContext.save()
            showAlert = true
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    /// 最大公約数 GCD(greatest common divisor)
    private func getAspectH(w: Int, h: Int) {
        let w: Float = Float(w)
        let h: Float = Float(h)
        let as_h: Float = w / h * 100
        
        if (as_h == 56) {
            self.flameName = "Desigwin_flame16"
            self.flameEditName = "Desigwin_flame16_edit"
            self.flameOverName = "Desigwin_flame16_over"
        }
        
        print(Int(as_h))
    }
    
    //改行ボタンを変更
    private func textDidBeginEditing(_ notification: Notification) {
        // UITextField を取り出せる
        let textField = notification.object as! UITextField
        // returnKeyType を設定できる
        textField.returnKeyType = .done
    }
}

extension ContentView {
    func capture(rect: CGRect) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: rect.origin,
                                            size: rect.size))
        let hosting = UIHostingController(rootView: self.body)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.renderedImage
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: .center) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

//画面外でキーボードを閉じる
extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}


class ViewModel: ObservableObject {
    @Published var bottomPadding: CGFloat = UIScreen.main.bounds.size.height - 115
    
    init() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] (notification: Notification) -> Void in
            guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]managedObjectContext as? CGRect else { return }
            withAnimation {
                self?.bottomPadding = keyboardFrame.size.height
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] (notification: Notification) -> Void in
            self?.bottomPadding = UIScreen.main.bounds.size.height - 115
        }
        
    }
}
