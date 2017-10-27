//----------------
import Foundation
//----------------
class UserDefaultsManager {
    //Ici, c'est la Méthode pour verifier se la valeur est gardé.---
    func doesKeyExist(theKey: String) -> Bool {
        if UserDefaults.standard.object(forKey: theKey) == nil {
            return false
        }
        return true
    }
    //--- Ici on va garder une valeur avec la class UserDefault et la Méthode standard.set.---
    func setKey(theValue: AnyObject, theKey: String) {
        UserDefaults.standard.set(theValue, forKey: theKey)
    }
    //--- Pour retirer la valeur dans la mémoire.---
    func removeKey(theKey: String) {
        UserDefaults.standard.removeObject(forKey: theKey)
    }
    //---Pour prendre la valeur (getValue).---
    func getvalue(theKey: String) -> AnyObject {
        return UserDefaults.standard.object(forKey: theKey) as AnyObject
    }
}
//----------------------------------



