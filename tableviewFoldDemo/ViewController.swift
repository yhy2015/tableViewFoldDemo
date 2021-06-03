//
//  ViewController.swift
//  tableviewFoldDemo
//
//  Created by yang on 2021/6/3.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var dataArr: [YUGFundListModel] = []
    private var foldArr: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        for section in 0...30 {
            var fundList = [String]()
            for index in 0...7 {
                fundList.append("row\(index + 1)")
            }
            dataArr.append(YUGFundListModel(name: "section\(section)", list: fundList))
        }
        foldArr = Array.init(repeating: false, count: dataArr.count)
        
        tableView.reloadData()
    }
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        tb.estimatedRowHeight = UITableView.automaticDimension
        tb.estimatedSectionHeaderHeight = 0
        tb.estimatedSectionFooterHeight = 0
        tb.sectionHeaderHeight = 0.1
        tb.sectionFooterHeight = 0.1
        
        tb.register(YUGFirstCell.self, forCellReuseIdentifier: NSStringFromClass(YUGFirstCell.self))
        tb.register(YUGSecondCell.self, forCellReuseIdentifier: NSStringFromClass(YUGSecondCell.self))
//        tb.register(YUGFirstHeader.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(YUGFirstHeader.self))
        tb.register(YUGSecondHeader.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(YUGSecondHeader.self))
        tb.register(YUGFirstHeaderCell.self, forCellReuseIdentifier: NSStringFromClass(YUGFirstHeaderCell.self))
        
        tb.delegate = self
        tb.dataSource = self

        return tb
    }()
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foldArr[section] ?  1 : 2 + dataArr[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let header: YUGFirstHeaderCell  =  tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(YUGFirstHeaderCell.self)) as! YUGFirstHeaderCell
            header.isFold = foldArr[indexPath.section]
            header.update(dataArr[indexPath.section].name)
            header.clickClsure = { [weak self] in
                guard let self = self else {
                    return
                }
                self.foldArr[indexPath.section] = !self.foldArr[indexPath.section]
                self.tableView.reloadSections([indexPath.section], with: .automatic)
            }
            return header
        } else if indexPath.row == 1 {
            return tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(YUGSecondCell.self))!
        } else {
            let cell: YUGFirstCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(YUGFirstCell.self)) as! YUGFirstCell
            cell.update(dataArr[indexPath.section].list[indexPath.row - 2])
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header: YUGFirstHeader  =  tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(YUGFirstHeader.self)) as! YUGFirstHeader
//        header.isFold = foldArr[section]
//        header.update(dataArr[section].name)
//        header.clickClsure = { [weak self] in
//            guard let self = self else {
//                return
//            }
//            self.foldArr[section] = !self.foldArr[section]
//            self.tableView.reloadSections([section], with: .automatic)
//        }
//        return header
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 30
//        }
//        return 50
//    }
}

extension ViewController {
    struct YUGFundListModel {
        let name: String
        let list: [String]
    }
}


class YUGFirstCell: SFBaseTableViewCell {
    
    func update(_ name: String) {
        nameLabel.text = name
    }
    
    override func configureSubviews() {
        contentView.addSubview(nameLabel)
        nameLabel.textColor = .lightGray
        nameLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    override func configureConstraints() {
        nameLabel.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(10)
//            $0.height.equalTo(50)
        }
    }
    
    let nameLabel = UILabel()
}


class YUGSecondCell: SFBaseTableViewCell {
    override func configureSubviews() {
        contentView.addSubview(nameLabel)
        nameLabel.textColor = .red
        nameLabel.font = UIFont.systemFont(ofSize: 8)
        nameLabel.text = "我是导航栏"
    }
    
    override func configureConstraints() {
        nameLabel.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(10)
//            $0.height.equalTo(8)
        }
    }
    
    let nameLabel = UILabel()
}

//class YUGFirstHeaderCell: SFBaseTableViewCell {
//    override func configureSubviews() {
//        contentView.addSubview(nameLabel)
//        nameLabel.textColor = .red
//        nameLabel.font = UIFont.systemFont(ofSize: 8)
//        nameLabel.text = "我是导航栏"
//    }
//
//    override func configureConstraints() {
//        nameLabel.snp.makeConstraints {
//            $0.left.top.bottom.equalToSuperview().inset(10)
//            $0.height.equalTo(8)
//        }
//    }
//
//    let nameLabel = UILabel()
//}


class YUGFirstHeaderCell: SFBaseTableViewCell {
    
    var clickClsure: (() -> Void)?
    var isFold = false
    
    func update(_ name: String) {
        nameLabel.text = name
        
        if isFold {
            nameLabel.backgroundColor = .green
        } else {
            nameLabel.backgroundColor = .white
        }
    }
    
    override func configureSubviews() {
        contentView.addSubview(nameLabel)
        nameLabel.textColor = .lightGray
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        
        let gr = UITapGestureRecognizer(target: self, action: #selector(click))
        contentView.addGestureRecognizer(gr)
    }
    
    @objc func click() {
        clickClsure?()
    }
    
    override func configureConstraints() {
        nameLabel.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(10)
//            $0.height.equalTo(30)
        }
    }
    
    let nameLabel = UILabel()
}

class YUGSecondHeader: BaseTableViewHeaderFooterView {
    override func configureSubviews() {
        contentView.addSubview(nameLabel)
        nameLabel.textColor = .lightGray
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.text = "我是section header2 可折叠的哦"
    }
    
    override func configureConstraints() {
        nameLabel.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(15)
            $0.height.equalTo(30)
        }
    }
    
    let nameLabel = UILabel()
}

open class SFBaseTableViewCell: UITableViewCell {

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureSubviews()
        configureConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
        configureConstraints()
    }

    open override func awakeFromNib() {
        configureSubviews()
        configureConstraints()
    }

    open func configureSubviews() {}
    open func configureConstraints() {}
}

open class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureSubviews()
        configureConstraints()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
        configureConstraints()
    }
    
    open override func awakeFromNib() {
        configureSubviews()
        configureConstraints()
    }
    
    open func configureSubviews() {}
    open func configureConstraints() {}
}



