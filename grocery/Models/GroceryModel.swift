//
//  GroceryModel.swift
//  grocery
//
//  Created by administrator on 15/11/2021.
//  Abdullah Albohalika

// MARK: Firebase data setup

import Firebase

class GroceryItems {
    
    var item: String? // Strore the item that the user enters
    var user: String? // Store the user's email
    
    init(item: String?, user: String?){
        self.item = item
        self.user = user
    }
}
