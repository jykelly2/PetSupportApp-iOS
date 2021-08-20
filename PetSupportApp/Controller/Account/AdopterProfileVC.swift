//
//  AdopterProfileVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/18/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class AdopterProfileVC: UIViewController {
    @IBOutlet weak var idealPetIncompleteView: UIView!
    @IBOutlet weak var aboutMeIncompleteView: UIView!
    @IBOutlet weak var btnNext: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView(){
        let path = UIBezierPath(roundedRect: idealPetIncompleteView.bounds, byRoundingCorners:[.topRight,.bottomLeft], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = idealPetIncompleteView.bounds
        maskLayer.path = path.cgPath
        idealPetIncompleteView.layer.mask = maskLayer
        
        let aboutPath = UIBezierPath(roundedRect: aboutMeIncompleteView.bounds, byRoundingCorners:[.topRight,.bottomLeft], cornerRadii: CGSize(width: 15, height: 15))
        let aboutMaskLayer = CAShapeLayer()
        aboutMaskLayer.frame = aboutMeIncompleteView.bounds
        aboutMaskLayer.path = aboutPath.cgPath
        aboutMeIncompleteView.layer.mask = aboutMaskLayer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    override func viewDidLayoutSubviews() {
        makeRound()
    }
    
    func makeRound(){
        btnNext.layer.cornerRadius = btnNext.frame.height/2
        btnNext.clipsToBounds = true
    }
    

    //MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func incompleteAboutmeButtonTapped(_ sender: UIButton) {
        let vc = SAccount.instantiateViewController(withIdentifier: "AboutMeVC") as! AboutMeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func incompleteIdealpetButtonTapped(_ sender: UIButton) {
        let vc = SAccount.instantiateViewController(withIdentifier: "IdealPetVC") as! IdealPetVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
