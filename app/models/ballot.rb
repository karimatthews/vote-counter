class Ballot < ApplicationRecord
  belongs_to :poll
  has_many :ranks
  validate :ranks_are_ordered_correctly

  def ranks_are_ordered_correctly
    unless self.ranks.map{ |r| r.score }.sort == (1..self.poll.options.count).to_a
      errors.add(:base, "Ranks aren't ordered properly")
    end
  end
end
