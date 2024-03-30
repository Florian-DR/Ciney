# class IsSingleton < ActiveModel::Validator
#     def validate(record)
#         unless record.class.all.size < 1
#             record.errors.add :record, "HomePage is a singleton"            
#         end
#     end
# end

class HomePage < ApplicationRecord
    has_many_attached :main_photos
    has_many_attached :entreprises_photos
    has_many_attached :découvrir_photos

    # validates_with IsSingleton
end
