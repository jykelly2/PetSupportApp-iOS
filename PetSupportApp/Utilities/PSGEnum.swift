//
//  PSGEnum.swift
//  PetSupportApp
//
//  Created by Enam on 8/12/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import Foundation
import UIKit

enum FilterModalMenu :String {
    case DistanceModalVC
    case AgeModalVC
    case BreadModalVC
    case SizeModalVC
    case GoodWithModalVC
    case ShelterRescueModalVC
    case ColarModalVC
    case CoatLengthModalVC
    case Filter
}

enum Pet_Status :String {
    case Approved
    case Reviewing
    case InProgress = "In progress"
}


enum DateTimeFormaterEnum : String
{
    case yyyymmdd           = "yyyy-MM-dd"
    
    case MMM_d_Y            = "MMM d, yyyy"
    
    case MMM_dd_YYYY            = "MMM dd, yyyy"
    
    case HHmmss             = "HH:mm:ss"
    
    case hhmma              = "hh:mma"
    
    case MM              = "MM"
    
    case E_MMM_dd  = "E, MMM dd yyyy"
    
    case E_dd_MMM_dd_yyyy  = "E, dd-MMM-yyyy"
    
    case yyyy              = "yyyy"
    
    case HHmm               = "HH:mm"
    
    case dmmyyyy            = "d/MM/yyyy"
    
    case hhmmA              = "hh:mm a"
    
    case UTCFormat          = "yyyy-MM-dd HH:mm:ss"
    
    case ddmm_yyyy          = "dd MMM, yyyy"
    
    case WeekDayhhmma       = "EEE,hh:mma"
    
    case ddMMyyyy           = "dd/MM/yyyy"
    
    case MMyy               = "MM/yy"
    
    case ddMMMyyyy          = "dd - MMM - yyyy"
    
    case ddMMMYYYYhhmma                             = "dd MMM, yyyy hh:mm a"
    
    case yyyyMMddTHHMMSSZ = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
    
}
