//
//  HalfSheet.swift
//  Voca
//
//  Created by USER on 2022/02/02.
//

import SwiftUI

struct SheetExample: View {
    @State var isShowingHalfSheet = false
    
    var body: some View {
        VStack {
            Button("show sheet") {
                isShowingHalfSheet.toggle()
            }
            Text(isShowingHalfSheet.description)

        }
        .halfSheet(showSheet: $isShowingHalfSheet) {
            VStack {
                TextField("", text: .constant("sample text"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("close sheet") {
                    isShowingHalfSheet = false
                }
                .buttonStyle(BorderedButtonStyle())
                .controlSize(.large)
            }
        }

    }
}

struct SheetExample_Previews: PreviewProvider {
    static var previews: some View {
        SheetExample()
    }
}

extension View {
    func halfSheet<SheetView: View>(
        showSheet: Binding<Bool>,
        @ViewBuilder sheetView: @escaping () -> SheetView
    ) -> some View {
        return self.background(
            HalfSheet(sheetView: sheetView(), showSheet: showSheet)
        )
    }
}

struct HalfSheet<SheetView: View>: UIViewControllerRepresentable {

    var sheetView: SheetView
    @Binding var showSheet: Bool
    let controller = UIViewController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if showSheet {
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true) {
            }
        } else {
            uiViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent: HalfSheet
        init(parent: HalfSheet) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet.toggle()
        }
    }
    
}

class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
            presentationController.prefersGrabberVisible = true
        }
    }
}
