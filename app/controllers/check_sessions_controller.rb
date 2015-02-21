class CheckSessionsController < ApplicationController
  before_action :set_check_session, only: [:show, :edit, :update, :destroy]

  # GET /check_sessions
  # GET /check_sessions.json
  def index
    @check_sessions = CheckSession.all
  end

  # GET /check_sessions/1
  # GET /check_sessions/1.json
  def show
  end

  # GET /check_sessions/new
  def new
    @check_session = CheckSession.new
  end

  # GET /check_sessions/1/edit
  def edit
  end

  # POST /check_sessions
  # POST /check_sessions.json
  def create
    @check_session = CheckSession.new(check_session_params)

    respond_to do |format|
      if @check_session.save
        format.html { redirect_to @check_session, notice: 'Check session was successfully created.' }
        format.json { render action: 'show', status: :created, location: @check_session }
      else
        format.html { render action: 'new' }
        format.json { render json: @check_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /check_sessions/1
  # PATCH/PUT /check_sessions/1.json
  def update
    respond_to do |format|
      if @check_session.update(check_session_params)
        format.html { redirect_to @check_session, notice: 'Check session was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @check_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /check_sessions/1
  # DELETE /check_sessions/1.json
  def destroy
    @check_session.destroy
    respond_to do |format|
      format.html { redirect_to check_sessions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_check_session
      @check_session = CheckSession.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def check_session_params
      params[:check_session]
    end
end
