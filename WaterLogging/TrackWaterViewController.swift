//
//  TrackWaterViewController.swift
//  WaterLogging
//
//

import UIKit

class TrackWaterViewController: UIViewController {
    
    private let goalService: GoalService = CoreDataGoalService()
    private let fluidService: FluidService = CoreDataFluidService()
    private let intakeService: IntakeService = CoreDataIntakeService()
    private var fluids: [Fluid]!
    
    private let addWaterButton = UIButton()
    private let updateGoalButton = UIButton()
    private let notificationView = BannerNotificationView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Set Up
    
    private func setUp() {
        addWaterButton.setTitle("Add Intake", for: .normal)
        updateGoalButton.setTitle("Update Daily Goal", for: .normal)
        
        addWaterButton.addTarget(self, action: #selector(addWaterButtonPressed), for: .touchUpInside)
        updateGoalButton.addTarget(self, action: #selector(goalButtonPressed), for: .touchUpInside)
        
        view.backgroundColor = .systemBackground
        addWaterButton.backgroundColor = .black
        updateGoalButton.backgroundColor = .black
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notificationView)
        NSLayoutConstraint.activate([notificationView.topAnchor.constraint(equalTo: view.topAnchor),
                                     notificationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     notificationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     notificationView.heightAnchor.constraint(equalToConstant: 60)])
        
        
        let container = UIView()
    
        addWaterButton.translatesAutoresizingMaskIntoConstraints = false
        updateGoalButton.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(addWaterButton)
        container.addSubview(updateGoalButton)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(container)
        
        // Buttons constraints
        
        let addWaterButtonConstraints = [addWaterButton.topAnchor.constraint(equalTo: container.topAnchor),
                                         addWaterButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                                         addWaterButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),]
        
        NSLayoutConstraint.activate(addWaterButtonConstraints)
        
        let updateGoalButtonConstraints = [updateGoalButton.topAnchor.constraint(equalTo: addWaterButton.bottomAnchor, constant: 10),
                                           updateGoalButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                                           updateGoalButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                                           updateGoalButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)]
        
        NSLayoutConstraint.activate(updateGoalButtonConstraints)
        
        // ContainerView constraints
        
        let containerConstraints = [container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                    container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                    container.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor),
                                    container.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor),
                                    container.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor),
                                    container.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor)]
        
        NSLayoutConstraint.activate(containerConstraints)
        
    }

    // MARK: - Forms
    
    func presentGoalForm() {
        let alert = UIAlertController(title: "Update Daily Goal",
                                      message: "You should drink about 0.7 ounces of water for every pound you weigh.",
                                      preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Ounces"
            textField.keyboardType = .decimalPad
        }

        alert.addAction(UIAlertAction(title: "Save", style: .default) { action in
            self.updateGoal(value: alert.textFields?.first?.text)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentIntakeForm() {
        loadFluids()

        let message = """
         Select a liquid and enter the total number of ounces consumed.
         Note: While other liquids can help you reach your daily intake goal, but make sure to watch out for those added sugars. Looking at you, fruit juice.
         \n\n\n\n\n\n\n
         """
        let alertView = UIAlertController(
            title: "Add Intake",
            message: message,
            preferredStyle: .alert)

        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 120, width: 260, height: 162))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.alpha = 0

        alertView.view.addSubview(pickerView)
        alertView.addTextField { (textField) in
            textField.keyboardType = .decimalPad
            textField.placeholder = "Total ounces"
        }
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            self.addIntake(volume: Double(alertView.textFields?.first?.text ?? "") ?? -1,
                           fluid: self.fluids[pickerView.selectedRow(inComponent: 0)])
        }))
        
        present(alertView, animated: true) {
            pickerView.frame.size.width = alertView.view.frame.size.width
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: [.curveLinear], animations: {
              pickerView.alpha = 1
            })
        }
    }
    
    // MARK: - Services
    
    func loadFluids() {
        if fluids == nil {
            fluids = fluidService.fetchAll()
        }
    }
    
    func updateGoal(value: String?) {
        guard let value = value,
              let amount = Double(value) else {
                notificationView.flashError(message: "Error updating daily goal")
                return
        }
        
        guard let goal = try? goalService.updateGoal(amount: amount) else {
            notificationView.flashError(message: "Error updating goal")
            return
        }
        
        notificationView.flashSuccess(message: "New daily goal set: \(String(format: "%.2f", goal.amount))oz.")
    }
    
    func addIntake(volume: Double, fluid: Fluid) {
        guard volume > 0 else {
            notificationView.flashError(message: "Intake volume must be greater than zero")
            return
        }
        let intake = intakeService.addIntakeToday(volume: volume, fluid: fluid)
        notificationView.flashSuccess(message: "Added \(intake.volume)oz of \(intake.fluid.name)")
    }
    
    
    // MARK: - Actions
    
    @objc private func addWaterButtonPressed() {
        presentIntakeForm()
    }
    
    @objc private func goalButtonPressed() {
        presentGoalForm()
    }

}

extension TrackWaterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fluids.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let fluid = fluids[row]
        return "\(fluid.name) (\(Int(fluid.waterBase * 100))% h2o)"
    }
}

extension TrackWaterViewController: UIPickerViewDelegate { }
