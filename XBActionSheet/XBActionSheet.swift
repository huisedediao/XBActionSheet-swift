//
//  XBActionSheet.swift
//  XCP
//
//  Created by xxb on 2016/12/22.
//  Copyright © 2016年 xxb. All rights reserved.
//

import UIKit

protocol XBActionSheetDelegate:NSObjectProtocol {
    func actionSheet(actionSheet:XBActionSheet, clickAt index:NSInteger) -> Void
}

class XBActionSheet: XBAlertViewBase {
    
    
    // MARK: - 文件私有变量
    
    fileprivate let f_sectionHeight:CGFloat = 5
    
    fileprivate let f_rowHeight:CGFloat = 44
    
    fileprivate var f_height:CGFloat?
    
    fileprivate let color_grayColorCus = UIColor.gray.withAlphaComponent(0.1)
    
    fileprivate lazy var tableView:UITableView={
        var tab=UITableView()
        tab.delegate=self
        tab.dataSource=self
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tab.separatorStyle=UITableViewCellSeparatorStyle.none
        return tab
    }()
    
    
    
    // MARK: - 公共变量
    
    weak var delegate:XBActionSheetDelegate?
    
    var arr_titleArr:[String]?{
        didSet{
            f_height=CGFloat((arr_titleArr?.count)! + 1) * f_rowHeight + f_sectionHeight
            tableView.reloadData()
            showFrame=CGRect(x: 0, y: XBPublicFunctions.ScreenHeight-f_height!, width: XBPublicFunctions.ScreenWidth, height: f_height!)
            hiddenFrame=CGRect(x: 0, y: XBPublicFunctions.ScreenHeight, width: XBPublicFunctions.ScreenWidth, height: f_height!)
        }
    }
    
    
    
    // MARK: - 方法重写
    
    override init(displayV: UIView) {
        super.init(displayV: displayV)
        backgroundColor=UIColor.white
        addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func show() {
        super.show()
        tableView.frame=bounds
    }
    
    override func hidden() {
        super.hidden()
    }
}


extension XBActionSheet:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0
        {
            if arr_titleArr != nil
            {
                return (arr_titleArr?.count)!
            }
            else
            {
                return 0
            }
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.font=UIFont.systemFont(ofSize: 15)
        if cell?.contentView.viewWithTag(1000) == nil && indexPath.section == 0 && indexPath.row != (arr_titleArr?.count)!-1
        {
            let line = CALayer()
            cell?.contentView.layer.addSublayer(line)
            line.backgroundColor=color_grayColorCus.withAlphaComponent(0.2).cgColor
            line.frame=CGRect(x: 10, y: f_rowHeight-0.5, width: XBPublicFunctions.ScreenWidth-20, height: 0.5)
        }
        cell?.textLabel?.textAlignment=NSTextAlignment.center
        if indexPath.section == 0
        {
            cell?.textLabel?.text=arr_titleArr?[indexPath.row]
        }
        else
        {
            cell?.textLabel?.text="取消"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section==1
        {
            let view = UIView()
            view.frame=CGRect(x: 0, y: 0, width: XBPublicFunctions.ScreenWidth, height: f_sectionHeight)
            view.backgroundColor=color_grayColorCus
            return view
        }
        else
        {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==1
        {
            return f_sectionHeight
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section==0) && (indexPath.row == (arr_titleArr?.count)!-1)
        {
            return f_rowHeight-0.5
        }
        else
        {
            return f_rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hidden()
        if indexPath.section == 0
        {
            if delegate != nil
            {
                weak var weakSelf=self
                delegate?.actionSheet(actionSheet: weakSelf!, clickAt: indexPath.row)
            }
        }
    }
}
