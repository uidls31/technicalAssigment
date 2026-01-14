import UIKit

struct OnboardingModel {
    let mainImage: UIImage
    let mainTitle: String
    let subTitle: String
    let storageImage: UIImage?
}


extension OnboardingModel {
    static func setupModels() -> [Self] {
        return [
            OnboardingModel.init(mainImage: .firstImageOnb,
                                 mainTitle: "Clean your Storage",
                                 subTitle: "Pick the best & delete the rest",
                                 storageImage: nil),
            
            OnboardingModel.init(mainImage: .secondImageOnb,
                                 mainTitle: "Detect Similar Photos",
                                 subTitle: "Clean similar photos & videos, save your storage \nspace on your phone.",
                                 storageImage: .storage),
            
            OnboardingModel.init(mainImage: .thirdImageOnb,
                                 mainTitle: "Video Compressor",
                                 subTitle: "Find large videos or media files and compress \nthem to free up storage space",
                                 storageImage: nil)
        ]
    }
}
