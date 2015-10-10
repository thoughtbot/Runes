import SwiftCheck
import Runes

struct AsyncOf<T : Arbitrary> : Arbitrary {

    let getAsync: (T->Void)->Void

    init(_ async:(T->Void)->Void){
        self.getAsync = async
    }

    static var arbitrary : Gen<AsyncOf<T>> {
        return { x in return AsyncOf{$0(x)} } <^> T.arbitrary
    }
}

func == <T:Equatable>(lhs:(T->Void)->Void, rhs:(T->Void)->Void) -> Bool{
    var equal:Bool?
    lhs{x in
        rhs{y in
            equal = x == y
        }
    }
    return equal ?? false
}
