//
//  UserTableViewCell.swift
//  SOUsers
//
//  Created by Will Renton on 04/09/2025.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var reputationLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    
    static let identifier = "UserTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with user: User) {
        usernameLabel.text = user.username
        reputationLabel.text = "Reputation: \(user.reputationScore)"
        loadImage(from: user.profilePicture)
    }
    
    private func loadImage(from url: URL?) {
        guard let url else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                return
            }

            DispatchQueue.main.async {
                self.profilePictureImageView.image = image
            }
        }
        task.resume()
    }
}
