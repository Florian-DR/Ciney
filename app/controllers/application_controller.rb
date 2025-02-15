class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :all_gites

    private 
    def all_gites
      @gites = Gite.all.order(:id)
    end
end
