require 'test_helper'
# bin/rails test test/models/instant_runoff_test.rb --verbose
# http://guides.rubyonrails.org/testing.html

class InstantRunoffTest < ActiveSupport::TestCase
  test "it picks the right winner" do
    poll = Poll.create(title: 'testpoll')
    option1 = poll.options.create(name: "option1")
    option2 = poll.options.create(name: "option2")
    option3 = poll.options.create(name: "option3")

    ballot1 = poll.ballots.create(name: 'ballot1')
    ballot2 = poll.ballots.create(name: 'ballot2')
    ballot3 = poll.ballots.create(name: 'ballot3')
    ballot4 = poll.ballots.create(name: 'ballot4')

    ballot1.ranks.build(option_id: option1.id, score: 1)
    ballot1.ranks.build(option_id: option2.id, score: 2)
    ballot1.ranks.build(option_id: option3.id, score: 3)

    ballot2.ranks.build(option_id: option1.id, score: 3)
    ballot2.ranks.build(option_id: option2.id, score: 2)
    ballot2.ranks.build(option_id: option3.id, score: 1)

    ballot3.ranks.build(option_id: option1.id, score: 1)
    ballot3.ranks.build(option_id: option2.id, score: 2)
    ballot3.ranks.build(option_id: option3.id, score: 3)

    ballot4.ranks.build(option_id: option1.id, score: 1)
    ballot4.ranks.build(option_id: option2.id, score: 2)
    ballot4.ranks.build(option_id: option3.id, score: 3)

    poll.save!

    runoff = InstantRunoff.new(poll)
    assert_equal(option1.name, runoff.winner)
  end

  test "it picks the right winner when there's an immediate loser" do
    poll = Poll.create(title: 'testpoll')
    option1 = poll.options.create(name: "option1")
    option2 = poll.options.create(name: "option2")

    ballot1 = poll.ballots.create(name: 'ballot1')
    ballot2 = poll.ballots.create(name: 'ballot2')

    ballot1.ranks.build(option_id: option1.id, score: 1)
    ballot1.ranks.build(option_id: option2.id, score: 2)

    ballot2.ranks.build(option_id: option1.id, score: 1)
    ballot2.ranks.build(option_id: option2.id, score: 2)

    poll.save!

    runoff = InstantRunoff.new(poll)
    assert_equal(option1.name, runoff.winner)
  end
end
