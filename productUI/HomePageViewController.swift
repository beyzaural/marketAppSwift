import UIKit


class HomePageViewController: UIViewController {
    
    var types: [FoodType] = []
    
    let homePageLabel = UILabel()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupHomePageLabel()
        setupCollectionView()
        fetchTypes()
        layout()
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.layer.cornerRadius = 16
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FoodTypeCell.self, forCellWithReuseIdentifier: "FoodTypeCell")
    }
    
    private func setupHomePageLabel() {
        homePageLabel.text = "Market"
        homePageLabel.font = UIFont.boldSystemFont(ofSize: 24)
        homePageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(homePageLabel)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            homePageLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            homePageLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.topAnchor.constraint(equalTo: homePageLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -90)
        ])
    }
    
    private func fetchTypes() {
        let url = URL(string: "http://localhost:3000/products/getTypes")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch types:", error)
                return
            }
            
            guard let data = data else {
                print("No data found")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print("JSON is HERE : \(json)")
                let fetchedTypes = try JSONDecoder().decode([FoodType].self, from: data)
                print("Fetched types:", fetchedTypes) // Debug log
                DispatchQueue.main.async {
                    self.types = fetchedTypes
                    print("Types count:", self.types.count) // Debug log
                    self.collectionView.reloadData()
                }
            } catch let jsonError {
                print("Failed to decode JSON:", jsonError)
            }
        }.resume()
    }
}

extension HomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of items:", types.count) // Debug log
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Cell for item at indexPath:", indexPath) // Debug log
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodTypeCell", for: indexPath) as! FoodTypeCell
        cell.foodTypeLabel.text = types[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 15) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedType = types[indexPath.row]
        let vegetableListVC = ProductController(type: selectedType)
        self.navigationController?.pushViewController(vegetableListVC, animated: true)
    }
}
