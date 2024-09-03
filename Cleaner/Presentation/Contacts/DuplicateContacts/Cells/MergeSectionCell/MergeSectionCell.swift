//
//  MergeSectionCell.swift
//  Cleaner
//
//  Created by Максим Лебедев on 26.10.2023.
//

import UIKit
import Contacts
import Reusable

class MergeSectionCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var thirdCardCheckBox: UIImageView!
    @IBOutlet weak var secondCardCheckBox: UIImageView!
    @IBOutlet weak var firstCardChackBox: UIImageView!
    @IBOutlet weak var selectAllCheckBox: UIImageView!
    @IBOutlet weak var selectAllStackView: UIStackView!
    @IBOutlet weak var thirdCardInfo2: UILabel!
    @IBOutlet weak var thirdCardInfo1: UILabel!
    @IBOutlet weak var thirdCardName: UILabel!
    @IBOutlet weak var secondCardinfo2: UILabel!
    @IBOutlet weak var secondCardInfo1: UILabel!
    @IBOutlet weak var secondCardName: UILabel!
    @IBOutlet weak var firstCardInfo2: UILabel!
    @IBOutlet weak var firstCardInfo1: UILabel!
    @IBOutlet weak var firstCardName: UILabel!
    @IBOutlet weak var thirdCard: UIView!
    @IBOutlet weak var secondCard: UIView!
    @IBOutlet weak var firstCard: UIView!
    @IBOutlet weak var thirdMergedLabel: UILabel!
    @IBOutlet weak var secondMergedLabel: UILabel!
    @IBOutlet weak var firstMergedLabel: UILabel!
    @IBOutlet weak var mergedName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    //cringe
    func setupData(data: [CNContact]) {
        mergedName.text = data[0].givenName + " " + data[0].familyName
        firstMergedLabel.text = data[0].phoneNumbers.first?.value.stringValue
        if data[0].phoneNumbers.first?.value.stringValue != data[1].phoneNumbers.first?.value.stringValue{
            secondMergedLabel.text = data[1].phoneNumbers.first?.value.stringValue
        } else {
            secondMergedLabel.isHidden = true
        }
        if data.count > 2 {
            thirdMergedLabel.text = data[2].phoneNumbers.first?.value.stringValue
        } else {
            thirdMergedLabel.isHidden = true
        }
        
        firstCardName.text = data[0].givenName + " " + data[0].familyName
        firstCardInfo1.text = data[0].phoneNumbers.first?.value.stringValue
//        if data[0].emailAddresses.isEmpty {
//            firstCardInfo2.isHidden = true
//        } else {
//            firstCardInfo2.text = (data[0].emailAddresses.first?.value ?? "") as String
//        }
        secondCardName.text = data[1].givenName + " " + data[1].familyName
        secondCardInfo1.text = data[1].phoneNumbers.first?.value.stringValue
//        if data[1].emailAddresses.isEmpty {
//            secondCardinfo2.isHidden = true
//        } else {
//            secondCardinfo2.text = (data[1].emailAddresses.first?.value ?? "") as String
//        }
        
        if data.count >= 3 {
            thirdCard.isHidden = false
            thirdCardName.text = data[2].givenName + " " + data[2].familyName
            thirdCardInfo1.text = data[2].phoneNumbers.first?.value.stringValue
//            if data[2].emailAddresses.isEmpty {
//                thirdCardInfo2.isHidden = true
//            } else {
//                thirdCardInfo2.text = (data[2].emailAddresses.first?.value ?? "") as String
//            }
        } else {
            thirdCard.isHidden = true
        }
    }
}
