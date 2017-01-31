#Erica Chai
#PA02 Movies

#contains one of the files of ratings, u.data, or u1.test or u1.base etc.
#Knows how to read the file while analyzing what it sees. Importantly it has
#a method predict(user, movie) which will generate a prediction, based on that
#file, of what rating a user would give to a movie.

class Ratings

  

  def predict(user, movie)
    list = most_similar(user) #list of similar users to user who have seen movie

    list.each do |user|


#checks which users have seen the movie
  def watched_movie





#From PA01_Movies:
#this will generate a number which indicates the similarity
#in movie preference between user1 and user2 (where higher
#numbers indicate greater similarity)
  def similarity(user1, user2)
    #find all movies watched by user1 and user2
    @user1_data = Hash.new #movieId -> rating
    @user2_data = Hash.new #movieId -> rating
    count = 0
    similar_movies_avg = []

#fill in user1_data and user2_data
    $data['user_id'].each do |user|
      if user.to_i == user1.to_i
        @user1_data[$data['movie_id'].fetch(count)] = $data['rating'].fetch(count)
      elsif user.to_i == user2.to_i
        @user2_data[$data['movie_id'].fetch(count)] = $data['rating'].fetch(count)
      end
      count += 1
    end

#find similar watched movies, remove differences in both lists
    @user1_data.each_key {|movieId, rating|
      if @user2_data.has_key?(movieId)
        similar_movies_avg.push((rating.to_i - @user2_data[movieId].to_i).abs)
      end
      #puts similar_movies_avg
    }

    #find average
     return similar_movies_avg.inject{ |sum, el| sum + el }.to_f / similar_movies_avg.size
   end


#From PA01_Movies
#this return a list of users whose tastes are most similar
#to the tastes of user u
  def most_similar(u)
    similar_users = []
    $unique_user_id.each do |user|
      num = similarity(u, user)
      if num >= 4
        similar_users.push(user)
      end
    end
    return similar_users
  end
end
