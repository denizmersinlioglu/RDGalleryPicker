import Foundation

class Once {
    
    var already: Bool = false
    var alreadyId: Int = -1
    
    func run(for id: Int = 0,_ block: () -> Void){
        guard alreadyId != id else {return}
        block()
        alreadyId = id
    }
    
    func run(_ block: () -> Void) {
        guard !already else { return }
        block()
        already = true
    }
}
