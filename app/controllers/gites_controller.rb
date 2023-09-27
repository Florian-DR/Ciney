class GitesController < ApplicationController

    def index
        @gites = Gite.all
    end

    def edit
        @gite = Gite.find(params[:id])
    end

    def update
        raise
        gite = Gite.find(params[:id])
    end

end
