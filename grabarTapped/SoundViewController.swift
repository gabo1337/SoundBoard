//
//  SoundViewController.swift
//  grabarTapped
//
//  Created by Mac 03 on 20/05/22.
//

import UIKit
import AVFoundation
import CloudKit


class SoundViewController: UIViewController {


    @IBOutlet weak var grabarButtton: UIButton!
    @IBOutlet weak var reproducitButton: UIButton!
    @IBOutlet weak var agregarButton: UIButton!
    @IBOutlet weak var nombreTextField: UITextField!
    var grabarAudio:AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        reproducitButton.isEnabled = false
        agregarButton.isEnabled = false
    }
    
    func configurarGrabacion(){
        do{
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("**********************************")
            print(audioURL!)
            print("**********************************")
            
            var setting:[String:AnyObject] = [:]
            setting[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            setting[AVSampleRateKey] = 44100.0 as AnyObject?
            setting[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: setting)
            grabarAudio!.prepareToRecord()
        }catch let error as NSError{
            print(error)
        }
            
        }
    
    

    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording{
            grabarAudio?.stop()
            grabarButtton.setTitle("GRABAR", for: .normal)
            reproducitButton.isEnabled = true
            agregarButton.isEnabled = true
        }else{
            grabarAudio?.record()
            grabarButtton.setTitle("DETENER", for: .normal)
            reproducitButton.isEnabled = false
        }
    }
    
    
    @IBAction func reproducirTapped(_ sender: Any) {
        do{
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            print("Reproduciendo")
        }catch{}
    }
    
    
    
    @IBAction func agregarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let grabacion = Grabacion(context: context)
        grabacion.nombre = nombreTextField.text
        grabacion.audio = NSData(contentsOf: audioURL!)! as Data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
