//
//  ViewController.swift
//  Stopwatch
//
//  Created by Amankeldi Zhetkergen on 03.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var timer = Timer()
    var isRunning = false
    var startTime: Date?
    var elapsedTime: TimeInterval = 0
    var records: [TimeInterval?] = []

    let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Stopwatch"
        label.textAlignment = .center
        label.backgroundColor = .systemGray4
        label.textColor = .brown
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00.00"
        label.textAlignment = .center
        label.backgroundColor = .systemGray6
        label.font = .systemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackButtons: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.backgroundColor = .systemGray5
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let startStopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let lapResetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Lap", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let timeTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(CustomRecordsCell.self, forCellReuseIdentifier: CustomRecordsCell.identifier)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        
        timeTableView.dataSource = self
        timeTableView.delegate = self
    }

    private func setupUI() {
        view.addSubview(appNameLabel)
        view.addSubview(timeLabel)
        view.addSubview(stackButtons)
        stackButtons.addArrangedSubview(lapResetButton)
        stackButtons.addArrangedSubview(startStopButton)
        view.addSubview(timeTableView)
        
        let appNameLabelConstraints = [
            appNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            appNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            appNameLabel.heightAnchor.constraint(equalToConstant: 30)
        ]
        let timeLabelConstraints = [
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            timeLabel.heightAnchor.constraint(equalToConstant: 200)
        ]
        let stackButtonsConstraints = [
            stackButtons.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            stackButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackButtons.heightAnchor.constraint(equalToConstant: 60)
        ]
        let timeTableViewConstraints = [
            timeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timeTableView.topAnchor.constraint(equalTo: stackButtons.bottomAnchor),
            timeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(appNameLabelConstraints)
        NSLayoutConstraint.activate(timeLabelConstraints)
        NSLayoutConstraint.activate(stackButtonsConstraints)
        NSLayoutConstraint.activate(timeTableViewConstraints)
    }
    
    func setupActions() {
        startStopButton.addTarget(self, action: #selector(startOrStop), for: .touchUpInside)
        lapResetButton.addTarget(self, action: #selector(lapOrReset), for: .touchUpInside)
        }
    
    @objc func startOrStop() {
        isRunning ? stopTimer() : startTimer()
    }
     
    @objc func lapOrReset() {
        isRunning ? lapRecord() : resetTimer()
    }
    
    @objc func startTimer() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
            RunLoop.current.run()
           }
        isRunning = true
        startTime = Date()
        startStopButton.setTitle("Stop", for: .normal)
        startStopButton.setTitleColor(.systemRed, for: .normal)
        lapResetButton.setTitle("Lap", for: .normal)
        }
    
    @objc func stopTimer() {
        isRunning = false
        timer.invalidate()
        if let start = startTime {
            elapsedTime += Date().timeIntervalSince(start)
        }
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.setTitleColor(.systemGreen, for: .normal)
        lapResetButton.setTitle("Reset", for: .normal)
    }
        
    @objc func resetTimer() {
        timer.invalidate()
        isRunning = false
        startTime = nil
        elapsedTime = 0
        records = []
        timeTableView.reloadData()
        timeLabel.text = "00:00.00"
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.setTitleColor(.systemGreen, for: .normal)
        }
    
    @objc func lapRecord() {
        if let start = startTime {
            let currentLapTime = Date().timeIntervalSince(start) + elapsedTime
            records.insert(currentLapTime, at: 0)
            timeTableView.reloadData()
        }
    }
    
    @objc func updateTimer() {
        if let start = startTime {
            let currentTime = Date().timeIntervalSince(start) + elapsedTime
            DispatchQueue.main.async {
                self.timeLabel.text = self.formatTime(currentTime)
            }
        }
    }
        
    func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60 % 60
        let seconds = Int(interval) % 60
        let milliseconds = Int((interval - floor(interval)) * 100)
        return String(format: "%02i:%02i.%02i", minutes, seconds, milliseconds)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomRecordsCell.identifier, for: indexPath) as? CustomRecordsCell else {
            fatalError("Could not dequeue cell [1]")
        }
        if let record = records[indexPath.row] {
            let recordFormatted = formatTime(record)
            cell.configure(count: records.count - indexPath.row, time: "\(recordFormatted)")
        }
        return cell
    }
}
