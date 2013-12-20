class SimilitudesController < ApplicationController
	def index
		@similitudes = Similitude.all
	end
end
