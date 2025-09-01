
class Experiment < ApplicationRecord
  belongs_to :scientist
  has_many :results, dependent: :destroy
  validates :title, presence: true
end
