//
//  GalleryView.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/19/21.
//

import Combine
import Foundation
import UIKit

enum GalleryViewSection: CaseIterable {
  case gyazo
}

struct Colorino: Hashable {
  var color: UIColor
}

class GalleryView: UIView, GalleryViewControllerDelegate {

  var view: UIView {
    return self
  }
  
  lazy var layout: UICollectionViewCompositionalLayout = createCollectionViewLayout()
  
  // MARK: - Lazy Properties -
  lazy var collectionView: UICollectionView = createCollectionView()
  
  lazy var selection = PassthroughSubject<String?, Never>()
  
  lazy var diffableDataSource = UICollectionViewDiffableDataSource<GalleryViewSection, Source>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier, for: indexPath)
    cell.backgroundColor = .red
    return cell
  }
  
  // MARK: - init -
  
  init() {
    super.init(frame: .zero)
    
    setupCollectionView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout -
  
  override func layoutSubviews() {
//    updateSnapshot(withItems: [.init(color: .black), .init(color: .green), .init(color: .red)])
  }
  
  func updateSnapshot(withItems items: [Source] = []) {
    var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<GalleryViewSection, Source>()
    diffableDataSourceSnapshot.appendSections(GalleryViewSection.allCases)
    diffableDataSourceSnapshot.appendItems(items, toSection: .gyazo)
    diffableDataSource.apply(diffableDataSourceSnapshot)
  }
}

extension GalleryView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let datasource = diffableDataSource.snapshot()
    selection.send("\(datasource.itemIdentifiers[indexPath.item])")
  }
}

// MARK: - Private API -
extension GalleryView {
  
  private func setupCollectionView() {
    addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.leading.equalTo(layoutMarginsGuide.snp.leading)
      make.trailing.equalTo(layoutMarginsGuide.snp.trailing)
      make.bottom.equalTo(layoutMarginsGuide.snp.bottom)
      make.top.equalTo(layoutMarginsGuide.snp.top)
    }
    
    self.collectionView.delegate = self
  }
  
  private func createCollectionView() -> UICollectionView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .systemBackground
    
    collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier)
    
    return collectionView
  }
  
  private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let fraction: CGFloat = 1/3
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = .init(top: 4.0, leading: 4.0, bottom: 4.0, trailing: 4.0)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    return UICollectionViewCompositionalLayout(section: section)
  }
}
