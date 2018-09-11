//
//  MazeViewController.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 1/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import UIKit

class MazeViewController: UIViewController {
    @IBOutlet private weak var mazeFrameContainerView: UIView!
    @IBOutlet private weak var timerLabel: UILabel!

    private var mazeFrameViewController = MazeFrameViewController()

    private lazy var viewModel: MazeViewModel = {
        var vm = MazeViewModel()
        vm.delegate = self
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()
    }
    
    @IBAction func didTapGenerateButton(_ sender: Any) {
        mazeFrameViewController.start()
        viewModel.start()
    }
    
    @IBAction func didTapLeftButton(_ sender: Any) {
        
    }
    
    @IBAction func didTapRightButton(_ sender: Any) {
        
    }
}

private extension MazeViewController {
    func basicSetup() {
        addChildViewController(mazeFrameViewController)
        mazeFrameContainerView.addSubview(mazeFrameViewController.view)
        mazeFrameViewController.didMove(toParentViewController: self)
        mazeFrameViewController.view.frame = CGRect(x: 10, y: 10, width: mazeFrameContainerView.bounds.size.width - 20, height: mazeFrameContainerView.bounds.size.height - 20)

        let frameViewModel = MazeFrameViewModel(viewLength: mazeFrameViewController.view.bounds.size.width)
        frameViewModel.delegate = mazeFrameViewController
        frameViewModel.childDelegate = viewModel
        viewModel.childViewModel = frameViewModel
        mazeFrameViewController.viewModel = frameViewModel
    }
}

extension MazeViewController: MazeViewModelDelegate {
    func timerDidTick(with timeText: String) {
        timerLabel.text = timeText
    }
}

