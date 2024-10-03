//
//  CustomRecordsCell.swift
//  Stopwatch
//
//  Created by Amankeldi Zhetkergen on 03.10.2024.
//

import UIKit

class CustomRecordsCell: UITableViewCell {

    static let identifier = String(describing: CustomRecordsCell.self)

    private let lapNumberLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .label
        nameLabel.font = .systemFont(ofSize: 18, weight: .regular)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private let timeRecordedLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .label
        nameLabel.font = .systemFont(ofSize: 18, weight: .regular)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(lapNumberLabel)
        contentView.addSubview(timeRecordedLabel)
    
        let lapNumberLabelConstraints = [
            lapNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 45),
            lapNumberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        let timeRecordedLabelConstraints = [
            timeRecordedLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 60),
            timeRecordedLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
    
        NSLayoutConstraint.activate(lapNumberLabelConstraints)
        NSLayoutConstraint.activate(timeRecordedLabelConstraints)
    }
    
    func configure(count: Int, time: String) {
        lapNumberLabel.text = "Lap \(count)"
        timeRecordedLabel.text = time
    }

}
