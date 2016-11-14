//
//  ViewController.swift
//  AllKindsOfSortForiOS
//
//  Created by Mr.LuDashi on 16/11/14.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

enum SortTypeEnum: Int {
    case BubbleSort = 0
    case SelectSort
    case InsertSort
    case ShellSort
    case HeapSort
    case MergeSort
    case QuickSort
}

class ViewController: UIViewController {

    @IBOutlet var displayView: UIView!
    var sortViews: Array<SortView> = []
    var sortViewHight: Array<Int> = []
    var sort: SortType = BubbleSort()
    
    let numberCount: Int = 50
    
    var displayViewHeight: CGFloat {
        get {
            return displayView.frame.height
        }
    }
    
    var displayViewWidth: CGFloat {
        get {
            return displayView.frame.width
        }
    }
    
    var sortViewWidth: CGFloat {
        get {
            return self.displayViewWidth / CGFloat(self.numberCount)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(sortViewWidth)
        print(displayViewWidth)
        print(displayViewHeight)
        if sortViews.isEmpty {
            self.configSortViewHeight()
            self.addSortViews()
        }
    }
    
    private func configSortViewHeight() {
        if !sortViewHight.isEmpty {
            sortViewHight.removeAll()
        }
        for _ in 0..<self.numberCount {
            self.sortViewHight.append(Int(arc4random_uniform(UInt32(displayViewHeight))))
        }
    }
    
    private func addSortViews() {
        for i in 0..<self.numberCount {
            let size: CGSize = CGSize(width: self.sortViewWidth, height: CGFloat(sortViewHight[i]))
            let origin: CGPoint = CGPoint(x: CGFloat(i) * sortViewWidth, y: 0)
            let sortView = SortView(frame: CGRect(origin: origin, size: size))
            self.displayView.addSubview(sortView)
            self.sortViews.append(sortView)
        }
    }
    
    private func updateSortViewHeight(index: Int, value: CGFloat) {
        
        UIView.animate(withDuration:0) {
            self.sortViews[index].updateHeight(height: value)
            let weight = value / self.displayViewHeight
            let color = UIColor(hue: weight, saturation: 1, brightness: 1, alpha: 1)
            self.sortViews[index].backgroundColor = color
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func tapSegmentContol(_ sender: UISegmentedControl) {
        self.configSortViewHeight()
        for i in 0..<self.sortViews.count {
           self.updateSortViewHeight(index: i, value: CGFloat(sortViewHight[i]))
        }
        
        let selectIndex: SortTypeEnum = SortTypeEnum(rawValue: sender.selectedSegmentIndex)!
        switch selectIndex {
        case .BubbleSort:
            self.sort = BubbleSort()
            
        case .SelectSort:
            self.sort = SimpleSelectionSort()
            
        case .InsertSort:
            self.sort = InsertSort()
            
        case .ShellSort:
            self.sort = ShellSort()
            
        case .HeapSort:
            self.sort = HeapSort()
        
        case .MergeSort:
            self.sort = MergingSort()
        
        case .QuickSort:
            self.sort = QuickSort()
        }
    }
    @IBAction func tapSortButton(_ sender: AnyObject) {
        sort.setSortResultClosure { (index, value) in
            let mainQueue: DispatchQueue = DispatchQueue.main
            mainQueue.async {
                self.updateSortViewHeight(index: index, value: CGFloat(value))
            }
        }
        let queue: DispatchQueue = DispatchQueue.global()
        queue.async {
            self.sortViewHight = self.sort.sort(items: self.sortViewHight)
            print(self.sortViewHight)
        }
    }
}

