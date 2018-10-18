class Finances::EntriesController < ApplicationController
  layout 'application'

  before_action :set_finances_entry, only: [:show, :edit, :update, :destroy]

  # GET /finances/entries
  # GET /finances/entries.json
  def index
    @entries = Finances::Entry.all
  end

  # GET /finances/entries/1
  # GET /finances/entries/1.json
  def show
  end

  # GET /finances/entries/new
  def new
    @entry = Finances::Entry.new
  end

  # GET /finances/entries/1/edit
  def edit
  end

  # POST /finances/entries
  # POST /finances/entries.json
  def create
    @entry = Finances::Entry.new(finances_entry_params)

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Entry was successfully created.' }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /finances/entries/1
  # PATCH/PUT /finances/entries/1.json
  def update
    respond_to do |format|
      if @entry.update(finances_entry_params)
        format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /finances/entries/1
  # DELETE /finances/entries/1.json
  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to finances_entries_url, notice: 'Entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_finances_entry
      @entry = Finances::Entry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def finances_entry_params
      params.fetch(:finances_entry, {})
    end
end
