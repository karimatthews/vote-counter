class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit, :update, :destroy]

  # GET /polls
  # GET /polls.json
  def index
    @polls = Poll.all
  end

  # GET /polls/1
  # GET /polls/1.json
  def show
    @ballot = Ballot.new

    @losers = []

    def remove_loser(ranks)
      loser = get_loser(ranks)
      @losers.push(loser)
      ranks.select {|r| r.option.name != loser}
    end

    def only_one_left(ranks)
      list = ranks.map{ |r| r.option.name }
      list.uniq.length == 1
    end

    def get_loser(ranks)
      list = ranks.select { |r| r.score == 1 }.map { |r| r.option.name }
      list.group_by(&:itself).map {|option, count| [option, count]}.sort.reverse.first.first
    end

    def recursively_vote(ranks)
      return ranks if only_one_left(ranks)
      recursively_vote(remove_loser(ranks))
    end

    if @poll.ballots.present?
      @winner = recursively_vote(@poll.ranks).first.option.name
    end

  end

  # GET /polls/new
  def new
    @poll = Poll.new
  end

  # GET /polls/1/edit
  def edit
  end

  # POST /polls
  # POST /polls.json
  def create
    @poll = Poll.new(poll_params)


    # declare variable with array from form
    options_param = params[:options]

    # map array from form to array of options in the database
    @poll.options = options_param.map do |o|
      Option.create(name: o) #create a row in the Options table with name == 'o' and poll_id the id of @poll
    end

    respond_to do |format|
      if @poll.save
        format.html { redirect_to @poll, notice: 'Poll was successfully created.' }
        format.json { render :show, status: :created, location: @poll }
      else
        format.html { render :new }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end




  # PATCH/PUT /polls/1
  # PATCH/PUT /polls/1.json
  def update
    respond_to do |format|
      if @poll.update(poll_params)
        format.html { redirect_to @poll, notice: 'Poll was successfully updated.' }
        format.json { render :show, status: :ok, location: @poll }
      else
        format.html { render :edit }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /polls/1
  # DELETE /polls/1.json
  def destroy
    @poll.destroy
    respond_to do |format|
      format.html { redirect_to polls_url, notice: 'Poll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poll_params
      params.require(:poll).permit(:title, :voting_method, :options, :blind)
    end
end
