//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Kedar Mohile on 9/29/19.
//  Copyright © 2019 Arti Karnik. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController
{
    var player : AVAudioPlayer = AVAudioPlayer()
    var duration : Double = 0
    var arrPlayList :Array = ["music","music1","music2","music3","music4"]
    var timer : Timer? = nil
    var isPause = false
    var currentSong : Int = 0
    var TotalDuration : Double = 0.0
    
    @IBOutlet var lblsongName: UILabel!
    @IBOutlet var lblTotalDuration: UILabel!
    @IBOutlet var sliderForBack: UISlider!
    @IBOutlet var btnSliderVolume: UISlider!
    @IBOutlet var sliderLoop: UIImageView!
    @IBOutlet var btnPlayPause: UIButton!
    @IBOutlet var btnPlayPauseClicked: UIButton!
    
   // IBAction Methods
    
    @IBAction func btnPlayPauseClicked(_ sender: Any)
    {
        if player.isPlaying
        {
            player.pause()
            isPause = true
            stopTimer()
            setImageForButton(IsPause: isPause)
        }
        else
        {
            if isPause
            {
                player.play(atTime: player.currentTime)
                SliderLoop(self)
                startTimer()
                isPause = false
            }
            else
            {
               playAudio()
            }
           
            setImageForButton(IsPause: isPause)
        }
    }
    @IBAction func btnNextClicked(_ sender: Any)
    {
        
       currentSong = currentSong + 1
        isPause = false
        if currentSong < 0 || currentSong >= arrPlayList.count
        {
            currentSong = 0
        }
        setAudioForSongNo(songNo: currentSong)
        playAudio()
    }
    @IBAction func btnPrevClicked(_ sender: Any)
    {
        isPause = false
        currentSong = currentSong - 1
        if currentSong < 0 || currentSong >= arrPlayList.count
        {
            currentSong = arrPlayList.count - 1
        }
        setAudioForSongNo(songNo: currentSong)
        playAudio()
    }
    @IBAction func SliderLoop(_ sender: Any)
    {
        
        if player.isPlaying
        {
            player.pause()
          
            let newTime : TimeInterval =  Double (sliderForBack.value)
            player.currentTime = newTime
            TotalDuration = player.duration - newTime
            player.play()
        }
    }
    @IBAction func btnVolumeChanged(_ sender: Any)
    {
        UserDefaults.standard.setValue(btnSliderVolume.value, forKey: "Volume")
        player.volume = btnSliderVolume.value
    }
    // Function to start timer
    func startTimer ()
    {
        if timer?.isValid == true
        {
            timer?.invalidate()
            timer = nil
        }
        timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.ShowRemainingTime), userInfo: nil, repeats: true)
    }
    // Stop timer
    func  stopTimer()
    {
        if timer?.isValid == true
        {
            timer?.invalidate()
            timer = nil
        }
    }
    override func viewDidLoad()
    {
        setAudioForSongNo(songNo: currentSong)
        super.viewDidLoad()
   }
    func setImageForButton (IsPause : Bool)
    {
        if isPause
        {
            btnPlayPause.setImage(UIImage(named: "play.png"), for: .normal)

        }
        else
        {
            btnPlayPause.setImage(UIImage(named: "stop.png"), for: .normal)
        }
    }
    func playAudio()
    {
        player.play()
        setLabelsForDurationAndSliders()
        startTimer()
        setImageForButton(IsPause: false)
    }
    func setLabelsForDurationAndSliders()
    {
        lblsongName.text = arrPlayList[currentSong]

        let minutes = Int(player.duration) / 60 % 60
        let seconds = Int(player.duration) % 60
        lblTotalDuration.text = String(format:"%02i:%02i",minutes, seconds)

        sliderForBack.minimumValue = 0.0
        sliderForBack.maximumValue = Float(player.duration)
        TotalDuration = Double(sliderForBack.maximumValue)
        sliderForBack.value = sliderForBack.minimumValue
    }
    @objc func ShowRemainingTime()
    {
        TotalDuration = TotalDuration - 1
        let minutes = Int(TotalDuration) / 60 % 60
        let seconds = Int(TotalDuration) % 60
        sliderForBack.value = Float(player.currentTime)
        lblTotalDuration.text = String(format:"%02i:%02i",minutes, seconds)
        
        if TotalDuration <= 0
        {
            TotalDuration = 0
            player.stop()
            timer?.invalidate()
            btnNextClicked(self)
        }
    }
    func setAudioForSongNo (songNo : Int)
    {
        let  audioPath = Bundle.main.path(forResource: arrPlayList[songNo], ofType: "mp3")
        do
        {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            if let savedVolume = UserDefaults.standard.value(forKey: "Volume")
            {
                player.volume = savedVolume as! Float
            }
            else
            {
                player.volume = 0.5
            }
        }
        catch
        {
            print("error playing")
        }
        btnSliderVolume.value = player.volume
    }
}

