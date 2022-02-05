class HomeController < ApplicationController
  def index
     redirect_to tweets_path 
  end
end
