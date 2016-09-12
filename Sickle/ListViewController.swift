//
//  ListViewController.swift
//  Sickle
//
//  Created by Vivien Leroy on 12/09/2016.
//  Copyright © 2016 Émeraude. All rights reserved.
//

import AppKit

class ListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
	@IBOutlet private weak var tableView: NSTableView!

	var monitors = [FolderMonitor]()

	var foldersToMonitor = [URL]() {
		didSet {
			for folder in foldersToMonitor {
				self.monitors.append(FolderMonitor(url: folder, handler: {
					print("Change!")
				}))
			}
		}
	}

	@IBAction func addFolder(sender: NSButton) {
		let panel = NSOpenPanel()
		panel.canChooseFiles = false
		panel.canChooseDirectories = true
		panel.allowsMultipleSelection = false
		panel.begin { [weak self] result in
			if result == NSFileHandlingPanelOKButton {
				if let folder = panel.urls.first {
					self?.foldersToMonitor.append(folder)
					self?.tableView.reloadData()
				}
			}
		}
	}

	func numberOfRows(in tableView: NSTableView) -> Int {
		return foldersToMonitor.count
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		return NSTextField(labelWithString: foldersToMonitor[row].description)
	}
}
