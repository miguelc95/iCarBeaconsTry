//
// Please report any problems with this app template to contact@estimote.com
//

import UIKit

class ViewController: UIViewController, ProximityContentManagerDelegate {
    
    var values:NSArray = []
    //Beacons

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var Imagen: UIImageView!
    @IBOutlet weak var nombre: UILabel!

    var proximityContentManager: ProximityContentManager!
    var nombres : [NSArray] = []
    var info : [NSArray] = []
    var fotos : [NSArray] = []



    override func viewDidLoad() {
        super.viewDidLoad()
        
        get()
        //print(values)

        self.activityIndicator.startAnimating()

        self.proximityContentManager = ProximityContentManager(
            beaconIDs: [
                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 12913, minor: 10250),
                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 19952, minor: 59011),
                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 18012, minor: 47752)

            ],
            beaconContentFactory: CachingContentFactory(beaconContentFactory: BeaconDetailsCloudFactory()))
        self.proximityContentManager.delegate = self
        self.proximityContentManager.startContentUpdates()
    }
    
    func get(){
        let url = NSURL(string: "http:/softitution.mx/beacons.php")
        let data = NSData(contentsOfURL: url!)
        values = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        print(values)

        
    }

    func proximityContentManager(proximityContentManager: ProximityContentManager, didUpdateContent content: AnyObject?) {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
        
        

        if let beaconDetails = content as? BeaconDetails {
            switch beaconDetails.beaconName {
                
            case "mint":
                let maindata = values[0]
                let link = maindata["Foto"] as? String
                 var url = try! NSURL(string: link!)
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                    dispatch_async(dispatch_get_main_queue(), {
                        self.Imagen.image = UIImage(data: data!)
                    });
                }
                self.nombre.text = maindata["Nombre"] as? String
               self.label.text = maindata["Datos"] as? String
                self.label.adjustsFontSizeToFitWidth = true
                break
                
            case "blueberry":
                let maindata = values[1]
                
                let link = maindata["Foto"] as? String
                var url = try! NSURL(string: link!)
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                    dispatch_async(dispatch_get_main_queue(), {
                        self.Imagen.image = UIImage(data: data!)
                    });
                }
                self.nombre.text = maindata["Nombre"] as? String
                self.label.text = maindata["Datos"] as? String
                self.label.adjustsFontSizeToFitWidth = true

                break
                
            case "ice":
                let maindata = values[2]
                let link = maindata["Foto"] as? String
                var url = try! NSURL(string: link!)
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                    dispatch_async(dispatch_get_main_queue(), {
                        self.Imagen.image = UIImage(data: data!)
                    });
                }
                self.nombre.text = maindata["Nombre"] as? String
                self.label.text = maindata["Datos"] as? String
                self.label.adjustsFontSizeToFitWidth = true

                break


            default:
                self.label.text = "No beacons in range."
            }
            
            
            self.view.backgroundColor = beaconDetails.backgroundColor
           // self.image.hidden = false
        } else {
            self.view.backgroundColor = BeaconDetails.neutralColor
            self.label.text = "No beacons in range."
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
