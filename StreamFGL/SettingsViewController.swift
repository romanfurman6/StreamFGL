//
//  SettingsViewController.swift
//  StreamFGL
//
//  Created by Roman Furman on 7/3/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsViewController: UIViewController, StoryboardInitializable {

    var viewModel: SettingsViewModelProtocol!

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindView()
    }

    private func setupTableView() {
        tableView.register(SettingsTableViewCell.nib, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.separatorStyle = .none

        viewModel.settings
            .bind(to: tableView.rx.items(cellIdentifier: SettingsTableViewCell.reuseIdentifier)) { (_, element: Setting, cell: SettingsTableViewCell) in
                cell.configure(with: element)
                cell.accessoryType = .disclosureIndicator
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Setting.self)
            .asObservable()
            .bind(to: viewModel.modelSelected)
            .disposed(by: disposeBag)
    }

    private func bindView() {

        doneButton.rx.tap
            .bind(to: viewModel.doneButtonTaps)
            .disposed(by: disposeBag)

        viewModel.showAlertView
            .bind(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.showAlertView(in: self)
            })
            .disposed(by: disposeBag)

        viewModel.showPickerView
            .bind(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.showPickerView(in: self)
            })
            .disposed(by: disposeBag)
    }

    private func showAlertView(in viewController: UIViewController) {
        let alertController = UIAlertController(title: "Stream Code", message: "Please, write here your stream code. For example: 12345", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Type here your stream code."
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] alert in
            guard let text = alertController.textFields?.first?.text else { return }
            if text.isInt && text.characters.count <= 5 {
                self?.viewModel.streamService.streamCode.value = text
            }
        }))
        viewController.present(alertController, animated: true, completion:nil)
    }

    private func showPickerView(in viewController: UIViewController) {
        let alertController = UIAlertController(title: "Stream quality", message: "Choose quality, stream will be reloaded ", preferredStyle: .actionSheet)
        let highAction = UIAlertAction(title: "High", style: .default, handler: { [weak self] _ in
            self?.viewModel.streamService.videoQuality.value = .high3
        })
        let mediumAction = UIAlertAction(title: "Medium", style: .default, handler: { [weak self] _ in
            self?.viewModel.streamService.videoQuality.value = .medium3
        })
        let lowAction = UIAlertAction(title: "Low", style: .default, handler: { [weak self] _ in
            self?.viewModel.streamService.videoQuality.value = .low3
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(highAction)
        alertController.addAction(mediumAction)
        alertController.addAction(lowAction)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate {}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

