
class Scientist < ApplicationRecord
	has_many :experiments, dependent: :destroy
	validates :name, presence: true
	validates :field, presence: true
end
