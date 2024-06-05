import UIKit
import SnapKit

// Reusable Article Cell to match Medium's style
class ArticleCell: UITableViewCell {
    // Subviews
    let articleImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let dateLabel = UILabel()
    
    // Reuse identifier
    static let reuseIdentifier = "ArticleCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Setting up the subviews
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = 8
        articleImageView.backgroundColor = .lightGray
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 2
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .darkGray
        
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray

        // Adding subviews
        contentView.addSubview(articleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        
        // Layout constraints using SnapKit
        articleImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 80, height: 80)) // Set the size of the image view
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(articleImageView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(articleImageView)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(articleImageView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(articleImageView.snp.right).offset(12)
            make.bottom.equalToSuperview().offset(-4)
            make.height.equalTo(20)
        }
    }

    // Configure the cell with ViewModel
    func configure(with viewModel: ArticleViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        dateLabel.text = viewModel.date
        setupImage(from: viewModel.imageURL)
    }
    
    private func setupImage(from url: String?) {
        guard let imageURL = url, let url = URL(string: imageURL) else {
            articleImageView.image = nil
            return
        }
        
        // For simplicity, we'll download the image synchronously. You might want to use a library like SDWebImage for asynchronous image loading and caching.
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.articleImageView.image = image
                }
            }
        }
    }
}
