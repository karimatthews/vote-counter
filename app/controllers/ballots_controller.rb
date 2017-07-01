class BallotsController < ApplicationController

  def create
    poll = Poll.find(params.require(:id))
    @ballot = Ballot.new(ballot_params)
    @ballot.poll = poll
    @ballot.ranks = poll.options.map do |o|
      Rank.new(score: params[o.name + '_score'], option: o)
    end

    respond_to do |format|
      if @ballot.save
        format.html { redirect_to @ballot.poll, notice: 'Ballot was successfully submitted.' }

      else
        format.html { redirect_to @ballot.poll, notice: @ballot.errors.full_messages.join(' ') }

      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def ballot_params
      params.permit(:name)
    end

end
