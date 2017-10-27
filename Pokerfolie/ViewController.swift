//----------------------//----------------------
import UIKit
//----------------------//----------------------
//---Crées les éléments pour les Views, imageViews, Labels et les images que simulent les moviments. ---
class ViewController: UIViewController {
    @IBOutlet weak var tempLabel: UILabel!
    
    //---Connexion avec les imageViews de chaque View 1-5. ---
    @IBOutlet weak var slot_1: UIImageView!
    @IBOutlet weak var slot_2: UIImageView!
    @IBOutlet weak var slot_3: UIImageView!
    @IBOutlet weak var slot_4: UIImageView!
    @IBOutlet weak var slot_5: UIImageView!
    
    //---Pour faire la illusion des movements des cartes avec des images flouées. ---
    var card_blur_1: UIImage!
    var card_blur_2: UIImage!
    var card_blur_3: UIImage!
    var card_blur_4: UIImage!
    var card_blur_5: UIImage!
    
    //---Connexion avec chaque View (que contient le imageViews, les buttons, les labels). ---
    @IBOutlet weak var bg_1: UIView!
    @IBOutlet weak var bg_2: UIView!
    @IBOutlet weak var bg_3: UIView!
    @IBOutlet weak var bg_4: UIView!
    @IBOutlet weak var bg_5: UIView!
    
    //---Connexion avec chaque Label que on utilise pour garder les cartes choisis. ---
    @IBOutlet weak var keep_1: UILabel!
    @IBOutlet weak var keep_2: UILabel!
    @IBOutlet weak var keep_3: UILabel!
    @IBOutlet weak var keep_4: UILabel!
    @IBOutlet weak var keep_5: UILabel!
    
    //--- Trois connections. pour les labels et pour le bouton:
    @IBOutlet weak var dealButton: UIButton! //Pour le bouton "Distribuer". ---
    @IBOutlet weak var creditsLabel: UILabel! //Pour le label "Crédits". ---
    @IBOutlet weak var betLabel: UILabel! //Pour le label "Mise". ---
    
//---Crée les tableaux pour chaque élément ci-haut. Les tableaux ici sont utilisés pour faire la repetition automatiquement de chaque View a chaque fois que le boucle "tourne".
   
    //---Un tableau avec les references pour les images floués. ---
    var arrOfCardImages: [UIImage]!
    
    //---Un tableau avec les references pour les imageViews. ---
    var arrOfSlotImageViews: [UIImageView]!
    
    /*--- Un tableau de Tuple: un mélange de types différentes de valeurs. Ici, le mélange d'un Integer et d'un String. Chaque Tuple va representer une carte avec deux données: le "Int" et le "String" (Entiéer et String - qui represent le chiffre et la sort de la carte, respectivement). C'est tableau ici, il ira avoir 52 cartes (pour le deck entiér). le tableau est vide au depart. */
    var deckOfCards = [(Int, String)]()

    //---Pour créer un tableau pour les Views. Celuici que va recevoir les cartes(Views). ---
    var arrOfBackgrounds: [UIView]!
    
    //---pour créeer le tableau que va montrer/cacher les Labels de guarder les cartes. ---
    var arrOfKeepLabels: [UILabel]!
    
    //--- Une variable pour gérer à quelle moment on peux faire la selection des cartes. ---
    var permissionToSelectCards = false
    
    //--- Une variable pour le Mise. Il depart à zéro. ---
    var bet = 0
    
    //--- Une variable pour le Crédits. Il depart à 2000 de crédits. ---
    var credits = 2000
    
    //--- Une variable que vai gerér quand les cartes peut our ne peut pas être choisis.---
    var chances = 2

    //---Pour appeller la class UserDefaultsManager.---
    let callerForUserDefaultsManager = UserDefaultsManager()
    //---Pour appeller la class PokerHands.---
    let pokerHands = PokerHands()
    //---Un tableau vide pour être rempli.---
    var handToAnalyse = [(0, ""), (0, ""), (0, ""), (0, ""), (0, "")]
    //---Un tableau de Tuple pour mettre la valeur en Hands
    var theHand = [(Int, String)]()
    
//----Lorsque le Document, la inteface est prêt que est que tu va... ---
    override func viewDidLoad() {
    super.viewDidLoad()
        
        //--- ...enregistrer le crédit...
        if callerForUserDefaultsManager.doesKeyExist(theKey: "credits") == false {
            callerForUserDefaultsManager.setKey(theValue: 2000 as AnyObject, theKey: "credits")
        } else {
            credits = callerForUserDefaultsManager.getvalue(theKey: "credits") as! Int
            creditsLabel.text = "Crédits: \(credits)"
        }
        
        
        //--- ...executer la Méthode "createCardObjectsFromImages". Créer la animation des images floué. ---
        createCardObjectsFromImages()
        
        //---
        fillUpArrays() //--- ...remplir les Arrays(tableaux): "arrOfCardImages", "arrOfSlotImageViews" , "arrOfBackgrounds", "arrOfKeepLabels" avec les references de chaque image. ---

        //--- ...contrôler les animations dans le tableau "arrOfCardImages" (elle est limitée pour la Methode "Timer.scheduledTimer" que va donner un delay pour montrer le resultats aprées l'animation et combien de fois qu'elle va repeter). Il va prende 0.5 secondes la animation des images (dans "arrOfCardImages"). ---
        prepareAnimations(duration: 0.5,
                          repeating: 5,
                          cards: arrOfCardImages)
        
        //--- ... donner un style au "SlotImageViews", que sont les cartes("imageViews") dans le tableau "arrOfSlotImageViews". ---
        stylizeSlotImageViews(radius: 10,
                              borderWidth: 0.5,
                              borderColor: UIColor.black.cgColor,
                              bgColor: UIColor.yellow.cgColor)
        
        //--- ... donner un style au "BackgroundViews", que sont les arriéres plans des las cartes, à travers de cette Méthode là. ---
        stylizeBackgroundViews(radius: 10,
                               borderWidth: nil,
                               borderColor: UIColor.black.cgColor,
                               bgColor: nil)
        
        //--- ... créer le jeux des cartes. ---
        createDeckOfCards()
    }
    
//----La Méthodes ---------------------------------
    //--- Cette Fonction a de boucle pour remplir les 52 cards du tableau "deckOfCards". ---
    func createDeckOfCards() {
        deckOfCards = [(Int, String)]()
        for a in 0...3 {
            let suits = ["d", "h", "c", "s"]
            for b in 1...13 {
                deckOfCards.append((b, suits[a]))
            }
        }
    }
    
    //--- Cette Méthod pour donner de style à les "imageViews" en "arrOfSlotImageViews". ---
    func stylizeSlotImageViews(radius r: CGFloat,
                               borderWidth w: CGFloat,
                               borderColor c: CGColor,
                               bgColor g: CGColor!) { 
        for slotImageView in arrOfSlotImageViews {
            slotImageView.clipsToBounds = true
            slotImageView.layer.cornerRadius = r
            slotImageView.layer.borderWidth = w
            slotImageView.layer.borderColor = c
            slotImageView.layer.backgroundColor = g
        }
    }
    
    //----------------------------------------------
    func stylizeBackgroundViews(radius r: CGFloat,
                                borderWidth w: CGFloat?,
                                borderColor c: CGColor,
                                bgColor g: CGColor?) {
        for bgView in arrOfBackgrounds {
            bgView.clipsToBounds = true
            bgView.layer.cornerRadius = r
            bgView.layer.borderWidth = w ?? 0
            bgView.layer.borderColor = c
            bgView.layer.backgroundColor = g
        }
    }
    //---Le contenu de la remplissage des Arrays avec des references----------------------
    func fillUpArrays() {
        arrOfCardImages = [card_blur_1, card_blur_2, card_blur_3, card_blur_4,
                           card_blur_5]
        arrOfSlotImageViews = [slot_1, slot_2, slot_3, slot_4, slot_5]
        arrOfBackgrounds = [bg_1, bg_2, bg_3, bg_4, bg_5]
        arrOfKeepLabels = [keep_1, keep_2, keep_3, keep_4, keep_5]
    }
    //---Remplis les references card_blur_x avec des images fluées---
    func createCardObjectsFromImages() {
        card_blur_1 = UIImage(named: "blur_1.png")
        card_blur_2 = UIImage(named: "blur_2.png")
        card_blur_3 = UIImage(named: "blur_3.png")
        card_blur_4 = UIImage(named: "blur_4.png")
        card_blur_5 = UIImage(named: "blur_5.png")
    }
    //---Prepares les paramétres des animations. La duration est nùmero double(d), ls repetition est definée pour un nùmero Integer(r) et les cards sont definis comme les images floués en le Méthod "returnRandomBlurCards" le paramétre "arrBlurCards"(c)--- 
    func prepareAnimations(duration d: Double,
                           repeating r: Int,
                           cards c: [UIImage]) {
        for slotAnimation in arrOfSlotImageViews {
            slotAnimation.animationDuration = d //--- combien de temps l'animation va durer ---
            slotAnimation.animationRepeatCount = r //--- compter de fois que l'animation a repeté ---
            slotAnimation.animationImages = returnRandomBlurCards(arrBlurCards: c) //--- mettre les animations des cards au hasard, selon la Fonction "returnRandomBlurCards". ---
        }
    }
    //--- Ici cette Méthode c'est pour faire les cartes que sont floués se animer de maniéer aléatoire.
    func returnRandomBlurCards(arrBlurCards: [UIImage]) -> [UIImage] {
        var arrToReturn = [UIImage]()
        var arrOriginal = arrBlurCards
        for _ in 0..<arrBlurCards.count {
            let randomIndex = Int(arc4random_uniform(UInt32(arrOriginal.count)))
            arrToReturn.append(arrOriginal[randomIndex])
            arrOriginal.remove(at: randomIndex)
        }
        return arrToReturn
    }
    //---- La méthode pour le bouton "Distribuer"---
    @IBAction func play(_ sender: UIButton) {
        //---Si jamais le "chances" être egale à zero ou (||) que le button "Distribuer" avoir l'alpha eguale à 0.5, nous avons faire le "Retourn", l'arrêt de ça fonction. ---
        if chances == 0 || dealButton.alpha == 0.5 {
            return
        //---Si c'est jamais le case, le chances vont être chances -1...---
        } else {
            chances = chances - 1
        }
        //---Declare la variable "allSelected" à True---
        var allSelected = true
        
        /*---Pour lancer les animations à partir du tableau "arrOfSlotImageViews".
        Aussi, il va dire que si la borde de la image (borderWidth) c'est different de 1 ((!= 1.0) Ça veux dire que la carte a été selectioné) il ne devera pas animer la carte selectioné.---*/
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1.0 {
                allSelected = false
                break
            }
        }
        
        //---
        if allSelected {
            displayRandomCards()
            return
        }
        //---
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1.0 {
                slotAnimation.startAnimating()
            }
        }
        //---Mettre le delay de 2.55 secondes. Aprés le delay,il va executer la Method "displayRandomCards".---
        Timer.scheduledTimer(timeInterval: 2.55,
                             target: self,
                             selector: #selector(displayRandomCards),
                             userInfo: nil,
                             repeats: false)
    }
    
//----Pour faire afficher des cartes au hasard. A partir de 52 cartes, il affiche 5.---
    @objc func displayRandomCards() {
        //---
        theHand = returnRandomHand()
        //---
        let arrOfCards = createCards(theHand: theHand)
        //---
        displayCards(arrOfCards: arrOfCards)
        
        //---Permetre choisir des cartes affichées. ---
        permissionToSelectCards = true
        //---
        prepareForNextHand()
        //---
    }
    
    //---Pour preparer pour la prochaine main de cartes. ---
    func prepareForNextHand() {
        //---Donne une deuxième chance de distribuer las cartes si elles sont eguales à zéro.---
        if chances == 0 {
            permissionToSelectCards = false
            dealButton.alpha = 0.5
            resetCards()
            createDeckOfCards()
            handToAnalyse = [(0, ""), (0, ""), (0, ""), (0, ""), (0, "")]
            chances = 2
            bet = 0
            betLabel.text = "MISE : 0"
        }
        
        //---Enregistrer le crédit si il est different de zéro. Si il est zéro, il enregistre.
        if credits != 0 {
            callerForUserDefaultsManager.setKey(theValue: credits as AnyObject, theKey: "credits")
        }else {
            callerForUserDefaultsManager.removeKey(theKey: "credits")
        }
        //---
    }
    //----------------------//----------------------
    func displayCards(arrOfCards: [String]) {
        //---
        var counter = 0
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1 {
                if chances == 0 {
                    handToAnalyse = removeEmptySlotsAndReturnArray()
                    handToAnalyse.append(theHand[counter])
                }
                //---
                slotAnimation.image = UIImage(named: arrOfCards[counter])
            }
            counter = counter + 1
        }
        //---
        if chances == 0 {
            verifyHand(hand: handToAnalyse)
        }
        //---
    }
    //----------------------//----------------------
    func removeEmptySlotsAndReturnArray() -> [(Int, String)] {
        var arrToReturn = [(Int, String)]()
        for card in handToAnalyse {
            if card != (0, "") {
                arrToReturn.append(card)
            }
        }
        return arrToReturn
    }
    //----------------------//----------------------
    func createCards(theHand: [(Int, String)]) -> [String] {
        /*---Pour créer 5 chaines de characteres avec le tuple. Dans les parenteses on se trouve les chiffres et les lettres. En ajoutent le ".png".  Mettre les 5 cartes choisis au hasard dans un tableau---*/
        let card_1 = "\(theHand[0].0)\(theHand[0].1).png"
        let card_2 = "\(theHand[1].0)\(theHand[1].1).png"
        let card_3 = "\(theHand[2].0)\(theHand[2].1).png"
        let card_4 = "\(theHand[3].0)\(theHand[3].1).png"
        let card_5 = "\(theHand[4].0)\(theHand[4].1).png"
        return [card_1, card_2, card_3, card_4, card_5]
        //---
    }
    //----------------------//----------------------
    func returnRandomHand() -> [(Int, String)] {
        //---
        var arrToReturn = [(Int, String)]()
        //---Ici un boucle des interactions avec 5 cartes aléatoires aportées du tableau "h".
        for _ in 1...5 {
            let randomIndex = Int(arc4random_uniform(UInt32(deckOfCards.count)))
            arrToReturn.append(deckOfCards[randomIndex])
            deckOfCards.remove(at: randomIndex)
        }
        //---
        return arrToReturn
        //---
    }
    //----------------------//----------------------
    func verifyHand(hand: [(Int, String)]) {
        if pokerHands.royalFlush(hand: hand) {
            calculateHand(times: 250, handToDisplay: "QUINTE FLUSH ROYALE")
        } else if pokerHands.straightFlush(hand: hand) {
            calculateHand(times: 50, handToDisplay: "QUINTE FLUSH")
        } else if pokerHands.fourKind(hand: hand) {
            calculateHand(times: 25, handToDisplay: "CARRÉ")
        } else if pokerHands.fullHouse(hand: hand) {
            calculateHand(times: 9, handToDisplay: "FULL")
        } else if pokerHands.flush(hand: hand) {
            calculateHand(times: 6, handToDisplay: "COULEUR")
        } else if pokerHands.straight(hand: hand) {
            calculateHand(times: 4, handToDisplay: "QUINTE")
        } else if pokerHands.threeKind(hand: hand) {
            calculateHand(times: 3, handToDisplay: "BRELAN")
        } else if pokerHands.twoPairs(hand: hand) {
            calculateHand(times: 2, handToDisplay: "DEUX PAIRES")
        } else if pokerHands.onePair(hand: hand) {
            calculateHand(times: 1, handToDisplay: "PAIRE")
        } else {
            calculateHand(times: 0, handToDisplay: "RIEN...")
        }
    }
    //----------------------//----------------------
    func calculateHand(times: Int, handToDisplay: String) {
        credits += (times * bet)
        tempLabel.text = handToDisplay
        creditsLabel.text = "Crédits: \(credits)"
    }
    //---La Méthode pour les boutons. Si "chances" être égal ou moins que 1, il va arrêter  ----
    @IBAction func cardsToHold(_ sender: UIButton) {
        //--- si il n'y a pas de permission (!permissionToSelectCards) pour select des cartes, le Retourn va bloquer de continuer le code. Dans l,autre case,
        if !permissionToSelectCards {
            return
        }
        //---Pour faire une "Off" dans le jeux ---//
        if arrOfBackgrounds[sender.tag].layer.borderWidth == 0.5 {
            arrOfSlotImageViews[sender.tag].layer.borderWidth = 0.5
            arrOfBackgrounds[sender.tag].layer.borderWidth = 0.0
            arrOfBackgrounds[sender.tag].layer.backgroundColor = nil
            arrOfKeepLabels[sender.tag].isHidden = true
            //---
            manageSelectedCards(theTag: sender.tag, shouldAdd: false)
        } else {
        //---Pour faire une "On" dans le jeux ---//
            arrOfSlotImageViews[sender.tag].layer.borderWidth = 1.0
            arrOfBackgrounds[sender.tag].layer.borderWidth = 0.5
            arrOfBackgrounds[sender.tag].layer.borderColor = UIColor(red: 255/255,
                                                                     green: 102/255, blue: 51/255, alpha: 0.5).cgColor
            arrOfBackgrounds[sender.tag].layer.backgroundColor = UIColor(red: 255/255,
                                                                         green: 102/255, blue: 51/255, alpha: 0.5).cgColor
            arrOfKeepLabels[sender.tag].isHidden = false
            //---
            manageSelectedCards(theTag: sender.tag, shouldAdd: true)
        }
    }
    //----------------------//----------------------
    func manageSelectedCards(theTag: Int, shouldAdd: Bool) {
        if shouldAdd {
            handToAnalyse[theTag] = theHand[theTag]
        } else {
            handToAnalyse[theTag] = (0, "")
        }
    }
    //----------------------//----------------------
    @IBAction func betButtons(_ sender: UIButton) {
        //---
        if chances <= 1 {
            return
        }
        //---
        tempLabel.text = ""
        
        //---Pour faire la Mise de 1000 et deduire de le crédit.
        if sender.tag == 1000 {
            bet = credits
            betLabel.text = "MISE : \(bet)"
            credits = 0
            creditsLabel.text = "CRÉDITS : \(credits)"
            dealButton.alpha = 1.0
            resetBackOfCards()
            return
        }
        
        //---Pour faire la Mise et deduire de le crédit.
        let theBet = sender.tag
        
        //---Pour faire les Mises et activer (.alpha = 1.0)  button "Distribuer".
        if credits >= theBet {
            bet += theBet
            credits -= theBet
            betLabel.text = "MISE : \(bet)"
            creditsLabel.text = "CRÉDITS : \(credits)"
            dealButton.alpha = 1.0
        }
        //---pour fair apparêtre le back de las images.
        resetBackOfCards()
        //---
    }
    //----------------------//----------------------
    func resetBackOfCards() {
        for back in arrOfSlotImageViews {
            back.image = UIImage(named: "back.png")
        }
    }
    
    func resetCards() {
        /*---Une boucle entre zéro et quatre avec toutes les imageViews. Toutes les elements dans le tableaux ("arrOfSlotImageViews", "arrOfBackgrounds", "arrOfBackgrounds", "arrOfKeepLabels") ont recevoir le changement. ---*/
        for index in 0...4 {
            arrOfSlotImageViews[index].layer.borderWidth = 0.5 //---Changer la borde des les elements de ce tableau ci à 0.5.
            arrOfBackgrounds[index].layer.borderWidth = 0.0 //---Changer la borde des les elements de ce tableau ci à 0.0 pour faire il disparêtre.
            arrOfBackgrounds[index].layer.backgroundColor = nil //---Changer la couleur du background des les elements de ce tableau ci à nil pour faire le reset de couleur de l'arriér plan.
            arrOfKeepLabels[index].isHidden = true //---Changer le état du "Garder" des les elements de ce tableau ci à "True". Faire disparêtre les labels.
        }
        //---
        chances = 2
        //---
    }
    //---Le boputopn pour recommencer
    @IBAction func restartLeGame(_ sender: UIButton) {
        resetBackOfCards()
        dealButton.alpha = 0.5
        credits = 2000
        creditsLabel.text = "Crédits: \(credits)"
        bet = 0
        betLabel.text = "Mise: \(bet)"
        tempLabel.text = "Bonne Chance!"
    }
}
//----------------------//----------------------
