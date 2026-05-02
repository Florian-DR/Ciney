class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :all_gites

    private 
    def all_gites
      @nav_gites = Gite.select(:id, :name).order(:id)
    end
end
