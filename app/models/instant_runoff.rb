class InstantRunoff

  def initialize(poll)
    @poll = poll.deep_clone(include: {ballots: :ranks})
    @ranks = @poll.ballots.map(&:ranks).flatten
    @losers = []
  end

  def winner
    @winner = recursively_vote(@ranks).first.option.name
  end

  private

  def get_loser(ranks)
    # Select all ranks with score = 1 and create a list of the associated names
    list = ranks.select { |r| r.score == 1 }.map { |r| r.option.name }

    # If anyone option has zero votes with rank 1 it should be the loser
    # So we check if any option has no ranks with score = 1
    unique_options = ranks.map { |r| r.option.name }.uniq
    bad_losers = unique_options - (unique_options & list)

    return bad_losers.first if bad_losers.present?

    # select the option which received the fewest votes with rank = 1 (the loser)
    loser = list.group_by(&:itself).map {|option, count| [option, count]}.sort.first.first
    puts list.group_by(&:itself)
    puts list.group_by(&:itself).to_a.sort.first.first.inspect
    puts loser
    return loser
  end

  def remove_loser(ranks)
    loser = get_loser(ranks)
    @losers.push(loser)
    # Redefine ranks as all those except the losers
    ranks.select {|r| r.option.name != loser}
  end

  def bump_remaining_votes()
    # close gaps in each ballot (e.g. no ballot should look like [0,1,3,4])
  end

  def only_one_left(ranks)
    list = ranks.map{ |r| r.option.name }
    list.uniq.length == 1
  end

  def recursively_vote(ranks)
    return ranks if only_one_left(ranks)
    recursively_vote(remove_loser(ranks))
  end

end
