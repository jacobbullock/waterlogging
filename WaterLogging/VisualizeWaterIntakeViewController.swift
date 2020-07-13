//
//  VisualizeWaterIntakeViewController.swift
//  WaterLogging
//
//

import UIKit

class VisualizeWaterIntakeViewController: UIViewController {

    private let goalService: GoalService = CoreDataGoalService()
    private let intakeService: IntakeService = CoreDataIntakeService()
    
    private let trackingLabel = UILabel()
    private let progressView = CircularProgressView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Set Up

    private func setUp() {
        view.addSubview(progressView)
        trackingLabel.textColor = .label
        trackingLabel.numberOfLines = 0
        trackingLabel.textAlignment = .center
        view.backgroundColor = .systemBackground
        
        view.addSubview(trackingLabel)
        progressView.setNeedsLayout()
        
        setUpConstraints()
    }

    private func setUpConstraints() {
        trackingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Label constraints
        
        let trackingLabelConstraints = [trackingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                        trackingLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                        trackingLabel.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor),
                                        trackingLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor),
                                        trackingLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor),
                                        trackingLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor)
                                        ]
        
        NSLayoutConstraint.activate(trackingLabelConstraints)
        
        // Progress Bar constraints
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        let progressBarConstraints = [progressView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                      progressView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                      progressView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
                                      progressView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
                                      progressView.heightAnchor.constraint(equalTo: progressView.widthAnchor)
                                      ]
        
        
        NSLayoutConstraint.activate(progressBarConstraints)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateVisualization()
    }
    
    private func color(for progress: Double) -> CGColor {
        let color: UIColor
        if progress >= 1 {
            color = .blue
        } else if progress > 0.7 {
            color = .green
        } else if progress > 0.5 {
            color = .yellow
        } else {
            color = .red
        }
        
        return color.cgColor
    }
    
    private func updateVisualization() {
        let amount = intakeService.totalIntakeForToday()
        if let goal = goalService.currentGoal?.amount {
            trackingLabel.text = "\(String(format: "%.2f", amount))oz of \(goal)oz\nconsumed today"
            let progress = amount / goal
            progressView.progressColor = color(for: progress)
            progressView.animate(to: progress)
        } else {
            trackingLabel.text = "\(amount)oz\nconsumed today"
            progressView.animate(to: 0)
        }
    }
}

