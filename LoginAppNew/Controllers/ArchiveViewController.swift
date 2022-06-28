import UIKit
import FirebaseAuth


class ArchiveViewController: UIViewController {
    
    var  isListView = true
    var isInSearchMode = false
    var hasMoreNotes = true
    var isLoading = false

    var notes = [Note]()
    var filteredNotes = [Note]()

    var viewToggleButton = UIBarButtonItem()
    var logOutButton : UIBarButtonItem!
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Title"
        searchBar.backgroundImage(for: .top, barMetrics: .default)
        searchBar.searchBarStyle = UISearchBar.Style.default
        
        return searchBar
    }()
    
    private var collectionView: UICollectionView?

//MARK : - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        view.backgroundColor = .black
        checkIsUserLoggedIn()
        fetchInitialNotes()
    }

    func fetchInitialNotes() {
        FireBaseNoteService.shared.fetchInitialArchiveNotes { note, error in
            if error != nil{
                print("\(error?.localizedDescription)")
                return
            } else {
                self.hasMoreNotes = !(note!.count < 13)
                self.notes = note!
                self.collectionView?.reloadData()
            }
        }
    }

    func fetchMoreNotes() {
        FireBaseNoteService.shared.fetchMoreArchiveNotes { note, error in
                if error != nil{
                    print("\(error?.localizedDescription)")
                    return
                } else {
                    self.hasMoreNotes = !(note!.count < 13)
                    self.notes.append(contentsOf: note!)
                    self.collectionView?.reloadData()
                }
            self.isLoading = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        fetchInitialNotes()
    }

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: isListView ? listViewLayout() : gridViewLayout())
        
        guard let collectionView = collectionView else {
            return
        }
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = view.bounds
        view.addSubview(collectionView)

    }

    @objc func listButtonTapped(sender: UIBarButtonItem) {
        if isListView {
                viewToggleButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.circle.fill"), style: .plain, target: self, action: #selector(listButtonTapped(sender:)))
            }else {
                viewToggleButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2.fill"),  style: .plain, target: self, action: #selector(listButtonTapped(sender:)))
                print("Inside Grid")
            }
       isListView = !isListView
        navigationItem.rightBarButtonItems = [logOutButton,viewToggleButton]

        configureHierarchy()
        self.collectionView?.reloadData()
    }

    @objc func handelLogout(){
        AuthService.shared.logout()
        presentLoginPage()
    }

    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func configureNavigationBar(){
        
        configureHierarchy()

        view.backgroundColor = .lightGray
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
                
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "x.circle"), style: .plain, target: self, action: #selector(handleDismiss))
        
        logOutButton = UIBarButtonItem(image: UIImage(systemName: "person.fill.badge.minus")!, style: .plain, target: self, action: #selector(handelLogout))
        
        viewToggleButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.circle.fill"), style: .plain, target: self, action: #selector(listButtonTapped(sender:)))
        
        
        navigationItem.rightBarButtonItems = [logOutButton,viewToggleButton]
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authenticationCompleted()

        print("View will appear")
    }

    func presentLoginPage() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginTableViewController") as? LoginTableViewController
            let nav = UINavigationController(rootViewController: loginVC!)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }

// Check if user is logged in
    func checkIsUserLoggedIn() {
        
        if Auth.auth().currentUser?.uid == nil{
            presentLoginPage()
        } else {
            configureNavigationBar()
            
        }
    }
}

extension ArchiveViewController: DidAuthenticationCompleted{
    func authenticationCompleted() {
        configureNavigationBar()
    }
}

extension ArchiveViewController {
    func listViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(66))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        
        //Another way to add spacing. This is done for the section
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }

    func gridViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    //        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing

        //Another way to add spacing. This is done for the section
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension ArchiveViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        return  vm.tasks.count
        return !isInSearchMode ? notes.count : filteredNotes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        
        let note = !isInSearchMode ? notes[indexPath.row] : filteredNotes[indexPath.row]
        
        cell.configure(title: note.title, description: note.description)
    //        cell.contentView.backgroundColor = .lightGray
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (hasMoreNotes && !isLoading && indexPath.row == notes.count - 1) {
            print("inside will display")
            isLoading = true
            fetchMoreNotes()
        }
    }

}

extension ArchiveViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // update the selected cell
        
        let note = notes[indexPath.row]
        let addVC = AddNotesViewController()

        addVC.note = note
                
        navigationController?.pushViewController(addVC, animated: true)
        
    }


}

extension ArchiveViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            isInSearchMode = false

        } else {
            
            isInSearchMode = true
            
            filteredNotes = notes.filter({$0.title.lowercased().contains(searchBar.text!.lowercased())})

        }
        collectionView?.reloadData()

    }
}
