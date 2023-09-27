class GitesController < ApplicationController

    def index
        @gites = Gite.all
    end
end
