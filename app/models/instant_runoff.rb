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
    # if there are any options with no rank = 1 then one of these is the loser
    return bad_losers.first if bad_losers.present?

    # select the option which received the fewest votes with rank = 1 (the loser)
    list.group_by(&:itself)
      .map {|option, count| [option, count]}
      .sort_by { |e| e[1].length}
      .first
      .first
  end

  def remove_loser(ranks)
    loser = get_loser(ranks)
    @losers.push(loser)
    # Redefine ranks as all those except the losers
    ranks.select {|r| r.option.name != loser}
  end

  def bump_remaining_votes(ballots, ranks)
    # close gaps in each ballot (e.g. no ballot should look like [0,1,3,4])
    #show remaining ballots
    result = ballots.map do |ballot|
      remaining_ranks = ballot.ranks.select{ |rank| ranks.include?(rank) }
      remaining_ranks.sort_by! { |rank| rank.score }
      remaining_ranks.reduce do |acc, rank|
        unless rank.score == acc.score + 1
          rank.score -= 1
          rank.save
        end
        acc = rank
      end
      remaining_ranks
    end
    return result.flatten
  end

  def only_one_left(ranks)
    list = ranks.map{ |r| r.option.name }
    list.uniq.length == 1
  end

  def recursively_vote(ranks)
    return ranks if only_one_left(ranks)
    ranks = bump_remaining_votes(@poll.ballots, ranks)
    recursively_vote(remove_loser(ranks))
  end

end
