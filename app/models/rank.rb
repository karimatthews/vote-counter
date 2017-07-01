class Rank < ApplicationRecord
  belongs_to :ballot
  belongs_to :option
end
