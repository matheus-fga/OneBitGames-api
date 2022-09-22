module LikeSearchable
  extend ActiveSupport::Concern

  included do
   scope :like, -> (key, value) do
    self.where("#{key} ILIKE ?", "%#{value}%")
   end
  end
end