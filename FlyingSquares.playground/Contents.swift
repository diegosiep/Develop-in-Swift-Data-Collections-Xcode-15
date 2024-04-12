import UIKit
import PlaygroundSupport

let liveViewFrame = CGRect(x: 0, y: 0, width: 500, height: 500)
let liveView = UIView(frame: liveViewFrame)


PlaygroundPage.current.liveView = liveView


let smallFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
let square = UIView(frame: smallFrame)
square.backgroundColor = .purple
liveView.addSubview(square)

// MARK: - Move, increase the size, change the colour, add the apple logo and rotate the square

//UIView.animate(withDuration: 3.0) {
//    square.backgroundColor = .orange
//    square.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
//} completion: { _ in
//    UIView.animate(withDuration: 3.0) {
//        square.backgroundColor = .purple
//        square.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        square.addSubview(UIImageView(image: UIImage(systemName: "apple.logo")))
//        square.transform = CGAffineTransform(rotationAngle: 20)
//    }
//}

// MARK: - Move, change the colour of the square and add the apple logo at the end, to the square, using the .curveEaseIn option and applying some delay

//UIView.animate(withDuration: 3.0, delay: 2.0, options: [.curveEaseIn]) {
//    square.backgroundColor = .yellow
//    square.frame = CGRect(x: 400, y: 400, width: 100, height: 100)
//} completion: { _ in
//    UIView.animate(withDuration: 3.0) {
//        square.backgroundColor = .purple
//        square.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        square.addSubview(UIImageView(image: UIImage(systemName: "apple.logo")))
//        square.transform = CGAffineTransform(rotationAngle: 20)
//    }
//}

// MARK: - Change the square's frame with a spring with damping effect and specifying its initial velocity

//UIView.animate(withDuration: 1.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: []) {
//    square.frame = CGRect(x: 150, y: 150, width: 200, height: 200)
//} completion: { _ in
//
//}

// MARK: - Apply CGAffineTransform animation to the square

//UIView.animate(withDuration: 2.0) {
//    square.backgroundColor = .orange
//
//    let scaleTransform = CGAffineTransform(scaleX: 2.0, y: 2.0)
//    let rotateTransform = CGAffineTransform(rotationAngle: .pi)
//    let translateTransform = CGAffineTransform(translationX: 200, y: 200)
//    let comboTransform = scaleTransform.concatenating(rotateTransform).concatenating(translateTransform)
//
//    square.transform = comboTransform
//}

// MARK: - Apply CGAffineTransform animation to the square and use the identity property to undo the transformation.

UIView.animate(withDuration: 2.0) {
    square.backgroundColor = .orange
    
    let scaleTransform = CGAffineTransform(scaleX: 2.0, y: 2.0)
    let rotateTransform = CGAffineTransform(rotationAngle: .pi)
    let translateTransform = CGAffineTransform(translationX: 200, y: 200)
    let comboTransform = scaleTransform.concatenating(rotateTransform).concatenating(translateTransform)
    
    square.transform = comboTransform
} completion: { _ in
    UIView.animate(withDuration: 2.0) {
        square.transform = CGAffineTransform.identity
        //        CGAffineTransform.identity will undo any transform animations; the colour is still orange because it is not a CGAffineTransformation
    }
}


