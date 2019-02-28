//
//  ViewController.swift
//  PDF Practice
//
//  Created by Jacob Bailosky on 1/8/19.
//  Copyright © 2019 Jacob Bailosky. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UIViewController, PDFDocumentDelegate {
    
    var document: PDFDocument!
    var searchedItem: PDFSelection?
    
    
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var pageCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setup pfdView
        
        let url = Bundle.main.url(forResource: "MAASTO Abstracts Flyer", withExtension: "pdf")
        document = PDFDocument(url: url!)
        pdfView.document = document
        pdfView.document?.delegate = self
        pdfView.autoScales = true
        
//        if let documentURL = Bundle.main.url(forResource: "ATT_154611826_20181017", withExtension: "pdf"),
//            let document = PDFDocument(url: documentURL)
//        {
//            pdfView.document = document
//            pdfView.document?.delegate = self
//        }
        
        // Add page changed listener
        NotificationCenter.default.addObserver(self, selector: #selector(handlePageChange(notification:)), name: Notification.Name.PDFViewPageChanged, object: nil)
        
        
        let pageCount: Int = (pdfView.document?.pageCount)!
        //print(String(page)," of ",String(pageCount))
        pageCountLabel.text = "1 of "+String(pageCount)

    }
    
    // Handle Page Change Event
    @objc private func handlePageChange(notification: Notification)
    {
        print("private func handlePageChange")
        let page: Int = (pdfView.currentPage?.pageRef!.pageNumber)!
        let pageCount: Int = (pdfView.document?.pageCount)!
        //print(String(page)," of ",String(pageCount))
        pageCountLabel.text = String(page)+" of "+String(pageCount)
    }
    
    @IBAction func getPageInfoButton(_ sender: Any) {
        
//        if let jumpToPage = pdfView.document?.page(at: 100) {
//            pdfView.go(to: jumpToPage)
//        } else {
//            print("out of page range")
//        }
        
        pdfView.go(to: searchedItem!)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.document?.beginFindString("maasto", withOptions: .caseInsensitive)
    }
    
    func documentDidEndDocumentFind(_ notification: Notification) {
        pdfView.setCurrentSelection(searchedItem, animate: false)
    }
    
    func documentDidFindMatch(_ notification: Notification) {
        if let selection = notification.userInfo?.first?.value as? PDFSelection {
            selection.color = .green
            if searchedItem == nil {
                // The first found item sets the object.
                searchedItem = selection
            } else {
                // All other found selection will be nested
                searchedItem!.add(selection)
            }
        }
    }
    

}

