class Movie < ActiveRecord::Base
 

    def self.all_ratings
        @ratings=Array.new
        self.select("rating").uniq.each {|x| @ratings.push(x.rating)}
        puts @ratings
        return  @ratings.sort.uniq
    end
    
end
