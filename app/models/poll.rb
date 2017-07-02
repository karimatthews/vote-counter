class Poll < ApplicationRecord
  has_many :options
  has_many :ballots
  has_many :ranks, through: :ballots
end
