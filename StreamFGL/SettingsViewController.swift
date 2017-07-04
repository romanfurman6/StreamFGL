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
            .bind(to: tableView.rx.items(cellIdentifier: SettingsTableViewCell.reuseIdentifier)) { (_, element: AlertType, cell: SettingsTableViewCell) in
                cell.configure(with: element)
                cell.accessoryType = .disclosureIndicator
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(AlertType.self)
            .asObservable()
            .bind(to: viewModel.modelSelected)
            .disposed(by: disposeBag)
    }

    private func bindView() {

        doneButton.rx.tap
            .bind(to: viewModel.doneButtonTaps)
            .disposed(by: disposeBag)

        viewModel.showAlertView
            .bind(onNext: { [weak self] type in
                guard let `self` = self else { return }
                self.showAlert(with: type, in: self)
            })
            .disposed(by: disposeBag)

    }

    private func showAlert(with type: AlertType, in viewController: SettingsViewController) {
        switch type {
        case .code:
            showCodeAlert(in: viewController)
        case .video:
            showVideoAlert(in: viewController)
        case .audio:
            showAudioAlert(in: viewController)
        }
    }

    private func showCodeAlert(in viewController: SettingsViewController) {
        let currentCode = viewModel.streamService.streamCode.value
        let title = currentCode.isEmpty ? "Set stream code" : "Current code: \(currentCode)"
        let alertController = UIAlertController(title: title, message: "Please, write here your stream code.", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "12345"
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { alert in
            guard let text = alertController.textFields?.first?.text else { return }
            if text.isInt && text.characters.count <= 5 {
                viewController.viewModel.streamService.streamCode.value = text
            }
        }))
        viewController.present(alertController, animated: true, completion:nil)
    }

    private func showVideoAlert(in viewController: SettingsViewController) {
        let currentQuality: () -> String = { [weak self] _ -> String in
            guard let `self` = self else { return "" }
            let videoQuality = self.viewModel.streamService.videoQuality.value
            switch videoQuality {
            case .high3:
                return "High"
            case .medium3:
                return "Medium"
            case .low3:
                return "Low"
            default:
                return ""
            }
        }
        let alertController = UIAlertController(title: "Current quality: \(currentQuality())", message: "Choose quality. Attention! Stream will be reloaded", preferredStyle: .actionSheet)
        let highAction = UIAlertAction(title: "High", style: .default, handler: { _ in
            viewController.viewModel.streamService.videoQuality.value = .high3
        })
        let mediumAction = UIAlertAction(title: "Medium", style: .default, handler: { _ in
            viewController.viewModel.streamService.videoQuality.value = .medium3
        })
        let lowAction = UIAlertAction(title: "Low", style: .default, handler: { _ in
            viewController.viewModel.streamService.videoQuality.value = .low3
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(highAction)
        alertController.addAction(mediumAction)
        alertController.addAction(lowAction)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }

    private func showAudioAlert(in viewController: SettingsViewController) {
        let currentQuality: () -> String = { [weak self] _ -> String in
            guard let `self` = self else { return "" }
            let videoQuality = self.viewModel.streamService.audioQuality.value
            switch videoQuality {
            case .high:
                return "High"
            case .medium:
                return "Medium"
            case .low:
                return "Low"
            default:
                return ""
            }
        }
        let alertController = UIAlertController(title: "Current quality: \(currentQuality())", message: "Choose quality. Attention! Stream will be reloaded", preferredStyle: .actionSheet)
        let highAction = UIAlertAction(title: "High", style: .default, handler: { _ in
            viewController.viewModel.streamService.audioQuality.value = .high
        })
        let mediumAction = UIAlertAction(title: "Medium", style: .default, handler: { _ in
            viewController.viewModel.streamService.audioQuality.value = .medium
        })
        let lowAction = UIAlertAction(title: "Low", style: .default, handler: { _ in
            viewController.viewModel.streamService.audioQuality.value = .low
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
