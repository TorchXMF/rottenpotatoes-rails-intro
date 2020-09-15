class Movie < ActiveRecord::Base
    def self.all_ratings
        ratings = Array.new
        self.select("rating").uniq.each {|rt| ratings.push(rt.rating)}
        ratings.sort.uniq
    end
end
