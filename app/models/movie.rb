class Movie < ActiveRecord::Base
    def self.get_rated
        return %w[G PG PG-13 R]
    end
    
    def self.with_rated(ratings)
        Movie.where(rating: ratings.keys)
    end
    
end