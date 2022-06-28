////
////  CollectionViewController.swift
////  LoginAppNew
////
////  Created by Shabuddin on 22/05/22.
////
//
//import Foundation
//import UIKit
//import RealmSwift
//
//class CollectionViewController: UIViewController  {
//
//
//
//    var  isListView = false
//
//    var viewToggleButton = UIBarButtonItem()
//
//    private var collectionView: UICollectionView?
//
//
//    let vm = TodoViewModel.sharedInstance
//
//    private func configureHierarchy() {
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: isListView ? listViewLayout() : gridViewLayout())
//
//        guard let collectionView = collectionView else {
//            return
//        }
//        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        collectionView.backgroundColor = .systemBackground
//        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
//
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.frame = view.bounds
//        view.addSubview(collectionView)
//
//        viewToggleButton = UIBarButtonItem(title: "list", style: .plain, target: self, action: #selector(listButtonTapped(sender:)))
//        self.navigationItem.setRightBarButton(viewToggleButton, animated: true)
//
//    }
//
////    private func createLayout() -> UICollectionViewLayout {
////        let layout: UICollectionViewLayout
////        //list view
////        if isListView {
////            layout = listViewLayout()
////        } else {
////        //Grid View
////            layout = gridViewLayout()
////        }
////        isListView = !isListView
////
////        return layout
////    }
////
//    @objc func listButtonTapped(sender: UIBarButtonItem) {
//        if isListView {
//                viewToggleButton = UIBarButtonItem(title: "List", style: .plain, target: self, action: #selector(listButtonTapped(sender:)))
//                isListView = false
//            }else {
//                viewToggleButton = UIBarButtonItem(title: "Grid", style: .plain, target: self, action: #selector(listButtonTapped(sender:)))
//                isListView = true
//            }
//
//            self.navigationItem.setRightBarButton(viewToggleButton, animated: true)
//            self.collectionView?.reloadData()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        configureHierarchy()
//        floatingButton()
//    }
//
//
//    override func viewDidAppear(_ animated: Bool) {
//        vm.loadItems {
//            collectionView?.reloadData()
//        }
//
//    }
//
//
//    func floatingButton() {
//        let button = UIButton()
//
//        button.tintColor = .black
//        button.setTitleColor(.black, for: .normal)
//        button.layer.cornerRadius = 25
//        button.backgroundColor = .red
//        button.setImage(UIImage(systemName: "plus"), for: .normal)
//        button.addTarget(self, action: #selector(addNotes), for: .touchUpInside)
//        view.addSubview(button)
//
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
//        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
//        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
//    }
//
//    @objc func addNotes(){
//        let addVC = AddNotesViewController()
//        navigationController?.pushViewController(addVC, animated: true)
//
//    }
//
//
//}
//extension CollectionViewController {
//    func listViewLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .absolute(66))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//        let spacing = CGFloat(10)
//        group.interItemSpacing = .fixed(spacing)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = spacing
//
//        //Another way to add spacing. This is done for the section
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//
//        return layout
//    }
//
//    func gridViewLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
////        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .absolute(100))
//
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
//        let spacing = CGFloat(10)
//        group.interItemSpacing = .fixed(spacing)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = spacing
//
//        //Another way to add spacing. This is done for the section
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//
//        return layout
//    }
//}
//
//extension CollectionViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return  vm.tasks.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
//
//        let data = vm.tasks[indexPath.row]
//        cell.configure(label: data.title, notes: data.notes)
////        cell.contentView.backgroundColor = .lightGray
//        return cell
//    }
//}
//
//extension CollectionViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        // update the selected cell
//
//        let notesItem = vm.tasks[indexPath.row]
//        let addVC = AddNotesViewController()
//
//        addVC.item = notesItem
//
//        navigationController?.pushViewController(addVC, animated: true)
//
//
//    }
//}
//
